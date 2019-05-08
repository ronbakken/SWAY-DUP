using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using FirebaseAdmin;
using FirebaseAdmin.Messaging;
using Google.Apis.Auth.OAuth2;
using Google.Protobuf;
using Grpc.Core;
using Messaging.Interfaces;
using Messaging.ObjectMapping;
using Microsoft.Azure.Cosmos;
using Microsoft.Azure.ServiceBus;
using MoreLinq;
using Newtonsoft.Json.Linq;
using Polly;
using Serilog;
using Utility;
using Utility.gRPC;
using Utility.Sql;
using static Messaging.Interfaces.MessagingService;
using static Users.Interfaces.UsersService;

namespace Messaging
{
    public sealed class MessagingServiceImpl : MessagingServiceBase
    {
        private const string conversationSchemaType = "conversation";
        private const string conversationParticipantSchemaType = "conversationParticipant";

        // TODO: parameterize this
        private const string firebaseToken = "AIzaSyAFTwtVlRziyFEC1kKWNp4SCfexFuyGqlM";

        private readonly ILogger logger;
        private readonly TopicClient conversationUpdatedTopicClient;
        private readonly TopicClient messageUpdatedTopicClient;
        private CosmosContainer defaultContainer;
        private CosmosStoredProcedure createConversationSproc;
        private CosmosStoredProcedure updateConversationSproc;
        private CosmosStoredProcedure setConversationParticipantListeningSproc;
        private CosmosStoredProcedure closeConversationSproc;
        private CosmosStoredProcedure createMessageSproc;

        public MessagingServiceImpl(
            ILogger logger,
            TopicClient conversationUpdatedTopicClient,
            TopicClient messageUpdatedTopicClient)
        {
            this.logger = logger.ForContext<MessagingServiceImpl>();
            this.conversationUpdatedTopicClient = conversationUpdatedTopicClient;
            this.messageUpdatedTopicClient = messageUpdatedTopicClient;
        }

        public async Task Initialize(CosmosClient cosmosClient)
        {
            logger.Debug("Creating database if required");

            this.defaultContainer = await cosmosClient
                .CreateDefaultContainerIfNotExistsAsync()
                .ContinueOnAnyContext();

            var createConversationSprocResult = await defaultContainer
                .CreateStoredProcedureFromResourceIfNotExistsAsync(this.GetType(), "createConversation")
                .ContinueOnAnyContext();
            this.createConversationSproc = createConversationSprocResult.StoredProcedure;

            var updateConversationSprocResult = await defaultContainer
                .CreateStoredProcedureFromResourceIfNotExistsAsync(this.GetType(), "updateConversation")
                .ContinueOnAnyContext();
            this.updateConversationSproc = updateConversationSprocResult.StoredProcedure;

            var setConversationParticipantListeningSprocResult = await defaultContainer
                .CreateStoredProcedureFromResourceIfNotExistsAsync(this.GetType(), "setConversationParticipantListening")
                .ContinueOnAnyContext();
            this.setConversationParticipantListeningSproc = setConversationParticipantListeningSprocResult.StoredProcedure;

            var closeConversationSprocResult = await defaultContainer
                .CreateStoredProcedureFromResourceIfNotExistsAsync(this.GetType(), "closeConversation")
                .ContinueOnAnyContext();
            this.closeConversationSproc = closeConversationSprocResult.StoredProcedure;

            var createMessageSprocResult = await defaultContainer
                .CreateStoredProcedureFromResourceIfNotExistsAsync(this.GetType(), "createMessage")
                .ContinueOnAnyContext();
            this.createMessageSproc = createMessageSprocResult.StoredProcedure;

            logger.Debug("Database creation complete");
        }

        public override Task<CreateConversationResponse> CreateConversation(CreateConversationRequest request, ServerCallContext context) =>
            APISanitizer.Sanitize(
                this.logger,
                async (logger) =>
                {
                    if (request.FirstMessage?.User == null)
                    {
                        throw new ArgumentException("Message must include user information.");
                    }

                    if (request.ParticipantIds.Count < 1)
                    {
                        throw new ArgumentException("At least one participant ID must be specified.");
                    }

                    var id = Guid.NewGuid().ToString();
                    var topicId = request.TopicId;
                    var participantIds = request.ParticipantIds.ToArray();
                    var firstMessage = request.FirstMessage;
                    logger.Debug("Saving conversation with ID {ConversationId}, topic ID {TopicId}, participant IDs {ParticipantIds}, first message {@FirstMessage}, metadata {Metadata}", id, topicId, participantIds, firstMessage, request.Metadata);

                    // Create the initial message record
                    var createMessageArgs = new CreateMessageArgs
                    {
                        ConversationId = id,
                        Message = request.FirstMessage.ToEntity(),
                    };

                    var createMessageResult = await this
                        .createMessageSproc
                        .ExecuteWithLoggingAsync<CreateMessageArgs, MessageEntity>(id, createMessageArgs);
                    var messageEntity = createMessageResult.Resource;
                    logger.Debug("Created initial message {@InitialMessage}", messageEntity);

                    // Create all conversation records, so we can quickly enumerate the conversations that a user is participating in
                    var createConversationTasks = participantIds
                        .Select(
                            async participantId =>
                            {
                                var createConversationArgs = new CreateConversationArgs
                                {
                                    UserId = participantId,
                                    Id = id,
                                    TopicId = topicId,
                                    FirstMessage = request.FirstMessage.ToEntity(),
                                };
                                createConversationArgs.Metadata.Add(request.Metadata);

                                await this
                                    .createConversationSproc
                                    .ExecuteWithLoggingAsync<CreateConversationArgs, string>(participantId, createConversationArgs);
                            })
                        .ToList();

                    var usersService = GetUsersServiceClient();

                    // Create all conversation participant records, so we can quickly determine who needs to be notified when
                    // a new message is created against the conversation
                    var createConversationParticipantTasks = participantIds
                        .Select(
                            async participantId =>
                            {
                                var getUserResponse = await usersService
                                    .GetUserAsync(new Users.Interfaces.GetUserRequest { Id = participantId });
                                var user = getUserResponse.User;

                                var conversationParticipant = new ConversationParticipantEntity
                                {
                                    SchemaType = conversationParticipantSchemaType,
                                    SchemaVersion = 1,
                                    PartitionKey = id,
                                    Id = participantId,
                                };

                                conversationParticipant.RegistrationTokens.AddRange(user.RegistrationTokens);

                                await this
                                    .defaultContainer
                                    .Items
                                    .UpsertItemAsync(id, conversationParticipant)
                                    .ContinueOnAnyContext();
                            })
                        .ToList();

                    await Task
                        .WhenAll(createConversationTasks.Concat(createConversationParticipantTasks))
                        .ContinueOnAnyContext();

                    var conversation = new Conversation
                    {
                        Id = id,
                        UserId = request.ParticipantIds[0],
                        TopicId = topicId,
                        Status = Conversation.Types.Status.Open,
                        LatestMessage = request.FirstMessage,
                        LatestMessageWithAction = string.IsNullOrEmpty(request.FirstMessage.Action) ? null : request.FirstMessage,
                    };
                    conversation.Metadata.Add(request.Metadata);
                    var result = new CreateConversationResponse
                    {
                        Conversation = conversation,
                    };

                    // Kick off the notifications, but don't wait around - there may be retries or batching involved.
                    NotifyRecipients(
                            logger,
                            firebaseToken,
                            request.ParticipantIds.Except(new[] { request.FirstMessage.User.Id }),
                            request.FirstMessage)
                        .Ignore();

                    if (this.conversationUpdatedTopicClient != null)
                    {
                        logger.Debug("Publishing conversation {@Conversation} to service bus", conversation);
                        var message = new Microsoft.Azure.ServiceBus.Message(conversation.ToByteArray());
                        await this
                            .conversationUpdatedTopicClient
                            .SendAsync(message)
                            .ContinueOnAnyContext();
                    }

                    return result;
                });

        public override Task<CloseConversationResponse> CloseConversation(CloseConversationRequest request, ServerCallContext context) =>
            APISanitizer.Sanitize(
                this.logger,
                async (logger) =>
                {
                    var id = request.ConversationId;
                    logger.Debug("Closing conversation with ID {ConversationId}", id);

                    var sql = new CosmosSqlQueryDefinition("SELECT VALUE d.partitionKey FROM d WHERE d.id = @Id");
                    sql.UseParameter("@Id", id);

                    // TODO: HACK: using JObject and manually deserializing to get around this: https://github.com/Azure/azure-cosmos-dotnet-v3/issues/19
                    var itemQuery = this
                        .defaultContainer
                        .Items
                        .CreateItemQuery<string>(sql, 2);

                    if (!itemQuery.HasMoreResults)
                    {
                        logger.Debug("No conversation found with ID {ConversationId}", id);
                        return new CloseConversationResponse();
                    }

                    var currentResultSet = await itemQuery
                        .FetchNextSetAsync()
                        .ContinueOnAnyContext();
                    var participantIds = currentResultSet
                        .ToList();

                    if (participantIds.Count == 0)
                    {
                        logger.Debug("No conversation found with ID {ConversationId}", id);
                        return new CloseConversationResponse();
                    }

                    var tasks = participantIds
                        .Select(
                            participantId =>
                            {
                                var args = new CloseConversationArgs
                                {
                                    UserId = participantId,
                                    Id = id,
                                };

                                return this
                                    .closeConversationSproc
                                    .ExecuteWithLoggingAsync<CloseConversationArgs, ConversationEntity> (participantId, args);
                            })
                        .ToList();

                    var results = await Task
                        .WhenAll(tasks)
                        .ContinueOnAnyContext();

                    // Doesn't matter which result we choose because the user-specific data is not included in the service DTO
                    var conversation = results[0].Resource.ToServiceDto();
                    var result = new CloseConversationResponse
                    {
                        Conversation = conversation,
                    };

                    if (this.conversationUpdatedTopicClient != null)
                    {
                        logger.Debug("Publishing conversation {@Conversation} to service bus", conversation);
                        var message = new Microsoft.Azure.ServiceBus.Message(conversation.ToByteArray());
                        await this
                            .conversationUpdatedTopicClient
                            .SendAsync(message)
                            .ContinueOnAnyContext();
                    }

                    return result;
                });

        public override Task<GetConversationResponse> GetConversation(GetConversationRequest request, ServerCallContext context) =>
            APISanitizer.Sanitize(
                this.logger,
                async (logger) =>
                {
                    var userId = request.UserId;
                    var conversationId = request.ConversationId;

                    logger.Debug("Getting conversation with user ID {UserId}, conversastion ID {ConversationId}", userId, conversationId);

                    var result = await this
                        .defaultContainer
                        .Items
                        .ReadItemAsync<ConversationEntity>(partitionKey: userId, conversationId)
                        .ContinueOnAnyContext();
                    var conversationEntity = result.Resource;
                    logger.Debug("Retrieved conversation with ID {Id}: {@Conversation}", conversationId, conversationEntity);

                    var conversation = conversationEntity.ToServiceDto();

                    return new GetConversationResponse
                    {
                        Conversation = conversation,
                    };
                });

        public override Task<ListConversationsResponse> ListConversations(ListConversationsRequest request, ServerCallContext context) =>
            APISanitizer.Sanitize(
                this.logger,
                async (logger) =>
                {
                    var pageSize = request.PageSize;
                    var continuationToken = request.ContinuationToken;
                    var filter = request.Filter;

                    if (filter == null)
                    {
                        throw new ArgumentNullException(nameof(filter));
                    }

                    if (pageSize < 5 || pageSize > 100)
                    {
                        throw new ArgumentException(nameof(pageSize), "pageSize must be >= 5 and <= 100.");
                    }

                    if (string.IsNullOrEmpty(filter.UserId))
                    {
                        throw new ArgumentException(nameof(filter), "Must specify a user to filter by.");
                    }

                    this.logger.Debug("Retrieving conversations using page size {PageSize}, continuation token {ContinutationToken}, filter {@Filter}", pageSize, continuationToken, filter);

                    var queryBuilder = new CosmosSqlQueryDefinitionBuilder("d");

                    queryBuilder
                        .AppendScalarFieldClause(
                            "schemaType",
                            conversationSchemaType,
                            value => value)
                        .AppendScalarFieldClause(
                            "partitionKey",
                            filter.UserId.ValueOr(null),
                            value => value)
                        .AppendScalarFieldClause(
                            "topicId",
                            filter.TopicId.ValueOr(null),
                            value => value)
                        .AppendScalarFieldOneOfClause(
                            "status",
                            filter.ConversationStatuses,
                            value => value.ToEntity().ToString().ToCamelCase());

                    logger.Debug("SQL for search is {SQL}, parameters are {Parameters}", queryBuilder, queryBuilder.Parameters);
                    var queryDefinition = queryBuilder.Build();

                    // TODO: HACK: using JObject and manually deserializing to get around this: https://github.com/Azure/azure-cosmos-dotnet-v3/issues/19
                    var itemQuery = this
                        .defaultContainer
                        .Items
                        .CreateItemQuery<JObject>(queryDefinition, 2, maxItemCount: pageSize, continuationToken: continuationToken);
                    var items = new List<Conversation>();
                    string nextContinuationToken = null;

                    if (itemQuery.HasMoreResults)
                    {
                        var currentResultSet = await itemQuery
                            .FetchNextSetAsync()
                            .ContinueOnAnyContext();
                        nextContinuationToken = currentResultSet.ContinuationToken;

                        foreach (var conversation in currentResultSet.Select(Utility.Microsoft.Azure.Cosmos.ProtobufJsonSerializer.Transform<ConversationEntity>))
                        {
                            items.Add(conversation.ToServiceDto());
                        }
                    }

                    var result = new ListConversationsResponse();
                    result.Conversations.AddRange(items);

                    if (nextContinuationToken != null)
                    {
                        result.ContinuationToken = nextContinuationToken;
                    }

                    this.logger.Debug("Retrieved conversations using page size {PageSize}, continuation token {ContinutationToken}, filter {@Filter}. The next continuation token is {NextContinuationToken}: {Conversations}", pageSize, continuationToken, filter, nextContinuationToken, items);

                    return result;
                });

        public override Task<Empty> RegisterConversationListener(RegisterConversationListenerRequest request, ServerCallContext context) =>
            APISanitizer.Sanitize(
                this.logger,
                async (logger) =>
                {
                    logger.Debug("Registering conversation listener from request {@Request}", request);

                    var args = new SetConversationParticipantListeningArgs
                    {
                        ConversationId = request.ConversationId,
                        UserId = request.UserId,
                        IsListening = true,
                    };

                    await this
                        .setConversationParticipantListeningSproc
                        .ExecuteWithLoggingAsync<SetConversationParticipantListeningArgs, string>(request.ConversationId, args)
                        .ContinueOnAnyContext();

                    return new Empty();
                });

        public override Task<Empty> DeregisterConversationListener(DeregisterConversationListenerRequest request, ServerCallContext context) =>
            APISanitizer.Sanitize(
                this.logger,
                async (logger) =>
                {
                    logger.Debug("Deregistering conversation listener from request {@Request}", request);

                    var args = new SetConversationParticipantListeningArgs
                    {
                        ConversationId = request.ConversationId,
                        UserId = request.UserId,
                        IsListening = false,
                    };

                    await this
                        .setConversationParticipantListeningSproc
                        .ExecuteWithLoggingAsync<SetConversationParticipantListeningArgs, string>(request.ConversationId, args)
                        .ContinueOnAnyContext();

                    return new Empty();
                });

        public override Task<CreateMessageResponse> CreateMessage(CreateMessageRequest request, ServerCallContext context) =>
            APISanitizer.Sanitize(
                this.logger,
                async (logger) =>
                {
                    if (request.Message?.User == null)
                    {
                        throw new ArgumentException("Message must include user information.");
                    }

                    var id = Guid.NewGuid().ToString();
                    var message = request.Message;
                    message.Id = id;
                    var messageEntity = message.ToEntity();
                    var conversationId = request.ConversationId;
                    logger.Debug("Saving message with ID {MessageId}, conversation ID {ConversationId}: {@Message}", id, conversationId, message);

                    var createMessageArgs = new CreateMessageArgs
                    {
                        ConversationId = conversationId,
                        Message = messageEntity,
                    };

                    var createMessageResult = await this
                        .createMessageSproc
                        .ExecuteWithLoggingAsync<CreateMessageArgs, MessageEntity>(request.ConversationId, createMessageArgs);
                    messageEntity = createMessageResult.Resource;
                    message = messageEntity.ToServiceObject();

                    // Now update the associated conversation entities (one for each participant)
                    var sql = new CosmosSqlQueryDefinition("SELECT * FROM c WHERE c.schemaType=@SchemaType AND c.partitionKey=@PartitionKey");
                    sql.UseParameter("@SchemaType", conversationParticipantSchemaType);
                    sql.UseParameter("@PartitionKey", conversationId);

                    // TODO: HACK: using JObject and manually deserializing to get around this: https://github.com/Azure/azure-cosmos-dotnet-v3/issues/19
                    var conversationParticipantsQuery = this
                        .defaultContainer
                        .Items
                        .CreateItemQuery<JObject>(sql, partitionKey: conversationId);

                    while (conversationParticipantsQuery.HasMoreResults)
                    {
                        var currentResultSet = await conversationParticipantsQuery
                            .FetchNextSetAsync()
                            .ContinueOnAnyContext();
                        var results = currentResultSet
                            .Select(Utility.Microsoft.Azure.Cosmos.ProtobufJsonSerializer.Transform<ConversationParticipantEntity>)
                            .ToList();

                        logger.Debug("Determined that conversation with ID {ConversationId} has participants {@ConversationParticipants}", conversationId, results);

                        var tasks = results
                            .Select(
                                async result =>
                                {
                                    var updateConversationArgs = new UpdateConversationArgs
                                    {
                                        Id = conversationId,
                                        LatestMessage = messageEntity,
                                        LatestMessageWithAction = string.IsNullOrEmpty(messageEntity.Action) ? null : messageEntity,
                                    };

                                    var updateConversationResult = await this
                                        .updateConversationSproc
                                        .ExecuteWithLoggingAsync<UpdateConversationArgs, ConversationEntity>(result.Id, updateConversationArgs);
                                    var conversation = updateConversationResult.Resource;

                                    if (this.conversationUpdatedTopicClient != null)
                                    {
                                        logger.Debug("Publishing conversation {@Conversation} to service bus", conversation);
                                        var conversationMessage = new Microsoft.Azure.ServiceBus.Message(conversation.ToServiceDto().ToByteArray());
                                        await this
                                            .conversationUpdatedTopicClient
                                            .SendAsync(conversationMessage)
                                            .ContinueOnAnyContext();
                                    }

                                })
                            .ToList();

                        await Task
                            .WhenAll(tasks)
                            .ContinueOnAnyContext();
                    }

                    // notify any users that aren't currently "listening" to the conversation
                    sql = new CosmosSqlQueryDefinition("SELECT VALUE d.registrationTokens FROM d WHERE d.schemaType=@SchemaType AND d.partitionKey=@ConversationId AND NOT (d.isListening ?? false) AND d.id!=@UserId");
                    sql.UseParameter("@SchemaType", conversationParticipantSchemaType);
                    sql.UseParameter("@ConversationId", conversationId);
                    sql.UseParameter("@UserId", request.Message.User.Id);

                    var itemQuery = this
                        .defaultContainer
                        .Items
                        .CreateItemQuery<string[]>(sql, partitionKey: conversationId);

                    while (itemQuery.HasMoreResults)
                    {
                        var currentResultSet = await itemQuery
                            .FetchNextSetAsync()
                            .ContinueOnAnyContext();
                        var registrationTokens = currentResultSet
                            .SelectMany(x => x)
                            .ToList();

                        logger.Debug("Determined that registration tokens {RegistrationTokens} should be notified regarding the creation of message {@Message}", registrationTokens, message);

                        // Kick off the notifications, but don't wait around - there may be retries or batching involved.
                        Notify(logger, firebaseToken, registrationTokens, message)
                            .Ignore();
                    }

                    if (this.messageUpdatedTopicClient != null)
                    {
                        logger.Debug("Publishing message {@Message} to service bus", message);
                        var serviceBusMessage = new Microsoft.Azure.ServiceBus.Message(message.ToByteArray());
                        await this
                            .messageUpdatedTopicClient
                            .SendAsync(serviceBusMessage)
                            .ContinueOnAnyContext();
                    }

                    var response = new CreateMessageResponse
                    {
                        Message = message,
                    };

                    return response;
                });

        public override Task<ListMessagesResponse> ListMessages(ListMessagesRequest request, ServerCallContext context) =>
            APISanitizer.Sanitize(
                this.logger,
                async (logger) =>
                {
                    var pageSize = request.PageSize;
                    var continuationToken = request.ContinuationToken;
                    var filter = request.Filter;

                    if (filter == null)
                    {
                        throw new ArgumentNullException(nameof(filter));
                    }

                    if (pageSize < 5 || pageSize > 100)
                    {
                        throw new ArgumentException(nameof(pageSize), "pageSize must be >= 5 and <= 100.");
                    }

                    if (string.IsNullOrEmpty(filter.ConversationId))
                    {
                        throw new ArgumentException(nameof(filter), "Must specify a conversation to filter by.");
                    }

                    this.logger.Debug("Retrieving messages using page size {PageSize}, continuation token {ContinutationToken}, filter {@Filter}", pageSize, continuationToken, filter);

                    var queryBuilder = new CosmosSqlQueryDefinitionBuilder("d");

                    queryBuilder
                        .AppendScalarFieldClause(
                            "schemaType",
                            "message",
                            value => value)
                        .AppendScalarFieldClause(
                            "partitionKey",
                            filter.ConversationId,
                            value => value);

                    logger.Debug("SQL for search is {SQL}, parameters are {Parameters}", queryBuilder, queryBuilder.Parameters);
                    var queryDefinition = queryBuilder.Build();

                    // TODO: HACK: using JObject and manually deserializing to get around this: https://github.com/Azure/azure-cosmos-dotnet-v3/issues/19
                    var itemQuery = this
                        .defaultContainer
                        .Items
                        .CreateItemQuery<JObject>(queryDefinition, 2, maxItemCount: pageSize, continuationToken: continuationToken);
                    var items = new List<Interfaces.Message>();
                    string nextContinuationToken = null;

                    if (itemQuery.HasMoreResults)
                    {
                        var currentResultSet = await itemQuery
                            .FetchNextSetAsync()
                            .ContinueOnAnyContext();
                        nextContinuationToken = currentResultSet.ContinuationToken;

                        foreach (var message in currentResultSet.Select(Utility.Microsoft.Azure.Cosmos.ProtobufJsonSerializer.Transform<MessageEntity>))
                        {
                            items.Add(message.ToServiceObject());
                        }
                    }

                    var result = new ListMessagesResponse();
                    result.Messages.AddRange(items);

                    if (nextContinuationToken != null)
                    {
                        result.ContinuationToken = nextContinuationToken;
                    }

                    this.logger.Debug("Retrieved messages using page size {PageSize}, continuation token {ContinutationToken}, filter {@Filter}. The next continuation token is {NextContinuationToken}: {Messages}", pageSize, continuationToken, filter, nextContinuationToken, items);

                    return result;
                });

        private static async Task NotifyRecipients(
            ILogger logger,
            string token,
            IEnumerable<string> recipientIds,
            Interfaces.Message message)
        {
            var usersService = GetUsersServiceClient();

            var tasks = recipientIds
                .Select(recipientId => usersService.GetUserAsync(new Users.Interfaces.GetUserRequest { Id = recipientId }).ResponseAsync)
                .ToList();

            var userResponses = await Task
                .WhenAll(tasks)
                .ContinueOnAnyContext();

            var registrationTokens = userResponses
                .SelectMany(userResponse => userResponse.User.RegistrationTokens)
                .ToList();

            await Notify(logger, token, registrationTokens, message);
        }

        private static async Task Notify(
            ILogger logger,
            string token,
            IEnumerable<string> registrationTokens,
            Interfaces.Message message)
        {
            using (var client = new HttpClient())
            {
                // TODO: This naff code should be replaced with the new FCM API (can just use the admin client directly).
                // However, blocked by this: https://github.com/firebase/firebase-admin-dotnet/issues/35
                var tasks = registrationTokens
                    .Batch(
                        1000,
                        batch => batch
                            .Aggregate(
                                new StringBuilder(),
                                (acc, next) =>
                                {
                                    if (acc.Length == 0)
                                    {
                                        acc.Append("[");
                                    }
                                    else
                                    {
                                        acc.Append(",");
                                    }

                                    acc
                                        .Append("\"")
                                        .Append(next)
                                        .Append("\"");

                                    return acc;
                                },
                                sb => sb.Append("]").ToString()))
                    .Select(
                        registrationTokensArray =>
                            $@"{{
    ""registration_ids"": {registrationTokensArray},
    ""notification"": {{
        ""body"": ""{message.Text}"",
        ""title"": ""Message Received""
    }}
}}")
                    .Select(
                        messageJson =>
                        {
                            var policy = Policy
                                .Handle<Exception>()
                                .WaitAndRetryAsync(
                                    10,
                                    retryAttempt => TimeSpan.FromSeconds(Math.Min(8, Math.Pow(2, retryAttempt))),
                                    (exception, timespan) =>
                                    {
                                        logger.Error(exception, "Failed to send notification");
                                    });

                            return policy.ExecuteAsync(
                                async () =>
                                {
                                    var httpRequest = new HttpRequestMessage
                                    {
                                        Method = HttpMethod.Post,
                                        RequestUri = new Uri("https://fcm.googleapis.com/fcm/send"),
                                    };
                                    httpRequest.Headers.TryAddWithoutValidation("Authorization", $"key={token}");

                                    var content = new StringContent(messageJson, Encoding.UTF8, "application/json");
                                    httpRequest.Content = content;

                                    logger.Debug("Sending notification with payload {Payload}", messageJson);

                                    var result = await client
                                        .SendAsync(httpRequest)
                                        .ContinueOnAnyContext();
                                    result.EnsureSuccessStatusCode();

                                    logger.Debug("Notification sent with result {@Result}", result);
                                });
                        })
                    .ToList();

                await Task
                    .WhenAll(tasks)
                    .ContinueOnAnyContext();
            }
        }

        private static UsersServiceClient GetUsersServiceClient() =>
            APIClientResolver.Resolve<UsersServiceClient>("users", 9031);
    }
}
