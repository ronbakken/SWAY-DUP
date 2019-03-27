using System;
using System.Threading.Tasks;
using API.Interfaces;
using API.ObjectMapping;
using Grpc.Core;
using Serilog;
using Utility;
using Utility.gRPC;
using static API.Interfaces.InfMessaging;
using static Messaging.Interfaces.MessagingService;
using static Users.Interfaces.UsersService;

namespace API.Services.Messaging
{
    public sealed class InfMessagingImpl : InfMessagingBase
    {
        private readonly ILogger logger;

        public InfMessagingImpl(ILogger logger)
        {
            this.logger = logger.ForContext<InfMessagingImpl>();
        }

        public override Task<CreateConversationResponse> CreateConversation(CreateConversationRequest request, ServerCallContext context) =>
            APISanitizer.Sanitize(
                this.logger,
                async (logger) =>
                {
                    var messagingService = await GetMessagingServiceClient().ContinueOnAnyContext();
                    var usersService = await GetUsersServiceClient().ContinueOnAnyContext();
                    var userId = context.GetAuthenticatedUserId();
                    logger.Debug("Creating conversation on behalf of user {UserId} for participants with IDs {ParticipantIDs}", userId, request.ParticipantIds);

                    if (request.ParticipantIds.Count == 0)
                    {
                        logger.Warning("No participant IDs provided");
                        throw new RpcException(new Status(StatusCode.FailedPrecondition, $"At least one participant ID must be provided."));
                    }

                    if (!string.Equals(request.ParticipantIds[0], userId, StringComparison.Ordinal))
                    {
                        logger.Warning("Expected the first participant ID to be {UserId}, but received {FirstParticipantId}", userId, request.ParticipantIds[0]);
                        throw new RpcException(new Status(StatusCode.FailedPrecondition, $"User '{userId}' must be first in the participant IDs."));
                    }

                    var getUserResponse = await usersService.GetUserAsync(new global::Users.Interfaces.GetUserRequest { Id = userId });
                    var user = getUserResponse.User;

                    logger.Debug("Resolved to user {@User}", user);

                    var createConversationRequest = new global::Messaging.Interfaces.CreateConversationRequest
                    {
                        TopicId = request.TopicId,
                        FirstMessage = request.FirstMessage.ToMessage(user),
                    };

                    createConversationRequest.ParticipantIds.AddRange(request.ParticipantIds);

                    var createConversationResponse = await messagingService.CreateConversationAsync(createConversationRequest);
                    var conversation = createConversationResponse.Conversation;
                    logger.Debug("Created conversation for user {UserId}: {@Conversation}", userId, conversation);

                    var response = new CreateConversationResponse
                    {
                        Conversation = conversation.ToConversationDto(),
                    };

                    return response;
                });

        public override Task<CloseConversationResponse> CloseConversation(CloseConversationRequest request, ServerCallContext context) =>
            APISanitizer.Sanitize(
                this.logger,
                async (logger) =>
                {
                    var messagingService = await GetMessagingServiceClient().ContinueOnAnyContext();
                    var userId = context.GetAuthenticatedUserId();
                    logger.Debug("Closing conversation with ID {ConversationId} on behalf of user {UserId}", request.ConversationId, userId);

                    var closeConversationRequest = new global::Messaging.Interfaces.CloseConversationRequest
                    {
                        ConversationId = request.ConversationId,
                    };

                    var closeConversationResponse = await messagingService.CloseConversationAsync(closeConversationRequest);
                    var conversation = closeConversationResponse.Conversation;
                    logger.Debug("Closed conversation for user {UserId}: {@Conversation}", userId, conversation);

                    var response = new CloseConversationResponse
                    {
                        Conversation = conversation.ToConversationDto(),
                    };

                    return response;
                });

        public override Task<CreateMessageResponse> CreateMessage(CreateMessageRequest request, ServerCallContext context) =>
            APISanitizer.Sanitize(
                this.logger,
                async (logger) =>
                {
                    var messagingService = await GetMessagingServiceClient().ContinueOnAnyContext();
                    var usersService = await GetUsersServiceClient().ContinueOnAnyContext();
                    var userId = context.GetAuthenticatedUserId();
                    logger.Debug("Creating message on behalf of user {UserId}: {@Message}", userId, request.Message);

                    var getUserResponse = await usersService.GetUserAsync(new global::Users.Interfaces.GetUserRequest { Id = userId });
                    var user = getUserResponse.User;

                    logger.Debug("Resolved to user {@User}", user);

                    var createMessageRequest = new global::Messaging.Interfaces.CreateMessageRequest
                    {
                        ConversationId = request.ConversationId,
                        Message = request.Message.ToMessage(user),
                    };

                    var createMessageResponse = await messagingService.CreateMessageAsync(createMessageRequest);
                    var message = createMessageResponse.Message;
                    logger.Debug("Created message for user {UserId}: {@Message}", userId, message);

                    var response = new CreateMessageResponse
                    {
                        Message = message.ToMessageDto(),
                    };

                    return response;
                });

        private static Task<MessagingServiceClient> GetMessagingServiceClient() =>
            APIClientResolver.Resolve<MessagingServiceClient>("Messaging");

        private static Task<UsersServiceClient> GetUsersServiceClient() =>
            APIClientResolver.Resolve<UsersServiceClient>("Users");
    }
}
