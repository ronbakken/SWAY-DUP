using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using API.Interfaces;
using AutoFixture;
using Grpc.Core;
using Xunit;

namespace IntegrationTests.Tests
{
    public static class Messaging
    {
        public static async Task<ExecutionContext> CreateConversation(ExecutionContext context)
        {
            var logger = context.Logger;
            var topicId = Guid.NewGuid().ToString();

            logger.Debug("Creating conversation with topic ID {TopicId}", topicId);

            var client = new InfMessaging.InfMessagingClient(context.GetServerChannel());
            var generatedMessage = context.Fixture.Create<MessageDto>();
            generatedMessage.User.Handle = context.Fixture.Create<UserDto.Types.HandleDataDto>();
            var request = new CreateConversationRequest
            {
                TopicId = topicId,
                FirstMessage = generatedMessage,
            };
            request.ParticipantIds.Add(context.GetUserId(UserType.Influencer));
            request.ParticipantIds.Add(context.GetUserId(UserType.Business));

            var response = await client.CreateConversationAsync(request, headers: context.GetAccessHeaders(UserType.Influencer));
            var conversation = response.Conversation;

            logger.Debug("Conversation created: {@Conversation}", conversation);

            Assert.NotNull(conversation);
            Assert.NotEmpty(conversation.Id);
            Assert.Equal(ConversationDto.Types.Status.Open, conversation.Status);
            Assert.NotNull(conversation.LatestMessage);
            Assert.NotNull(conversation.LatestMessage.User);
            Assert.Equal(context.GetUserId(UserType.Influencer), conversation.LatestMessage.User.Id);

            return context
                .WithConversationId(conversation.Id);
        }

        public static async Task<ExecutionContext> CreateMessage(ExecutionContext context)
        {
            var logger = context.Logger;
            var conversationId = context.GetConversationId();

            logger.Debug("Creating message against conversation with ID {ConversationId}", conversationId);

            var client = new InfMessaging.InfMessagingClient(context.GetServerChannel());
            var generatedMessage = context.Fixture.Create<MessageDto>();
            var request = new CreateMessageRequest
            {
                ConversationId = conversationId,
                Message = generatedMessage,
            };

            var response = await client.CreateMessageAsync(request, headers: context.GetAccessHeaders(UserType.Influencer));
            var messageReceived = response.Message;

            logger.Debug("Message created: {@Message}", messageReceived);

            Assert.NotNull(messageReceived);
            Assert.NotEmpty(messageReceived.Id);
            Assert.NotNull(messageReceived.User);
            Assert.Equal(context.GetUserId(UserType.Influencer), messageReceived.User.Id);
            generatedMessage.Id = messageReceived.Id;
            generatedMessage.User = messageReceived.User;
            generatedMessage.Timestamp = messageReceived.Timestamp;
            Assert.Equal(generatedMessage, messageReceived);

            return context;
        }

        public static async Task<ExecutionContext> CloseConversation(ExecutionContext context)
        {
            var logger = context.Logger;
            var conversationId = context.GetConversationId();

            logger.Debug("Closing conversation with ID {ConversationId}", conversationId);

            var client = new InfMessaging.InfMessagingClient(context.GetServerChannel());
            var request = new CloseConversationRequest
            {
                ConversationId = conversationId,
            };
            var response = await client.CloseConversationAsync(request, headers: context.GetAccessHeaders(UserType.Influencer));
            var conversation = response.Conversation;

            logger.Debug("Conversation closed: {@Conversation}", conversation);

            Assert.Equal(ConversationDto.Types.Status.Closed, conversation.Status);

            return context
                .WithoutConversationId();
        }

        public static async Task<ExecutionContext> ListConversations(ExecutionContext context)
        {
            var logger = context.Logger;
            var client = new InfList.InfListClient(context.GetServerChannel());

            var call = client.List(headers: context.GetAccessHeaders(UserType.Influencer));

            using (call)
            {
                var filter = new ItemFilterDto
                {
                    ConversationFilter = new ItemFilterDto.Types.ConversationFilterDto
                    {
                        ParticipatingUserId = context.GetUserId(UserType.Influencer),
                    },
                };

                await call.RequestStream.WriteAsync(
                    new ListRequest
                    {
                        State = ListRequest.Types.State.Resumed,
                        Filter = filter
                    });

                var cts = new CancellationTokenSource();
                cts.CancelAfter(TimeSpan.FromSeconds(1));
                var items = new List<ItemDto>();

                try
                {
                    while (await call.ResponseStream.MoveNext(cts.Token))
                    {
                        items.AddRange(call.ResponseStream.Current.Items);
                    }
                }
                catch (RpcException ex) when (ex.StatusCode == StatusCode.Cancelled)
                {
                }

                Assert.NotEmpty(items);

                foreach (var item in items)
                {
                    Assert.Equal(ItemDto.DataOneofCase.Conversation, item.DataCase);
                }
            }

            return context;
        }

        public static async Task<ExecutionContext> ListMessages(ExecutionContext context)
        {
            var logger = context.Logger;
            var client = new InfList.InfListClient(context.GetServerChannel());

            var call = client.List(headers: context.GetAccessHeaders(UserType.Influencer));

            using (call)
            {
                var filter = new ItemFilterDto
                {
                    MessageFilter = new ItemFilterDto.Types.MessageFilterDto
                    {
                        ConversationId = context.GetConversationId(),
                    },
                };

                await call.RequestStream.WriteAsync(
                    new ListRequest
                    {
                        State = ListRequest.Types.State.Resumed,
                        Filter = filter
                    });

                var cts = new CancellationTokenSource();
                cts.CancelAfter(TimeSpan.FromSeconds(1));
                var items = new List<ItemDto>();

                try
                {
                    while (await call.ResponseStream.MoveNext(cts.Token))
                    {
                        items.AddRange(call.ResponseStream.Current.Items);
                    }
                }
                catch (RpcException ex) when (ex.StatusCode == StatusCode.Cancelled)
                {
                }

                Assert.NotEmpty(items);

                foreach (var item in items)
                {
                    Assert.Equal(ItemDto.DataOneofCase.Message, item.DataCase);
                }
            }

            return context;
        }

        public static async Task<ExecutionContext> ListenForConversations(ExecutionContext context)
        {
            async Task<ConversationDto> CreateConversation(InfMessaging.InfMessagingClient client)
            {
                var generatedMessage = context.Fixture.Create<MessageDto>();
                generatedMessage.User.Handle = context.Fixture.Create<UserDto.Types.HandleDataDto>();
                var request = new CreateConversationRequest
                {
                    TopicId = Guid.NewGuid().ToString(),
                    FirstMessage = generatedMessage,
                };
                request.ParticipantIds.Add(context.GetUserId(UserType.Influencer));
                request.ParticipantIds.Add(context.GetUserId(UserType.Business));

                var response = await client.CreateConversationAsync(request, headers: context.GetAccessHeaders(UserType.Influencer));
                var conversation = response.Conversation;

                return conversation;
            }

            var logger = context.Logger;
            var listenClient = new InfListen.InfListenClient(context.GetServerChannel());
            var messagingClient = new InfMessaging.InfMessagingClient(context.GetServerChannel());

            var call = listenClient.Listen(headers: context.GetAccessHeaders(UserType.Influencer));

            using (call)
            {
                var filter = new ItemFilterDto
                {
                    ConversationFilter = new ItemFilterDto.Types.ConversationFilterDto
                    {
                        ParticipatingUserId = context.GetUserId(UserType.Influencer),
                    },
                };

                await call.RequestStream.WriteAsync(
                    new ListenRequest
                    {
                        Action = ListenRequest.Types.Action.Register,
                        Filter = filter,
                    });

                // Allow time for the listen request to "stick" (they are buffered)
                await Task.Delay(TimeSpan.FromMilliseconds(500));

                await Task
                    .WhenAll(
                        CreateConversation(messagingClient),
                        CreateConversation(messagingClient),
                        CreateConversation(messagingClient));

                var cts = new CancellationTokenSource();
                cts.CancelAfter(TimeSpan.FromSeconds(1));
                var items = new List<ItemDto>();

                try
                {
                    while (await call.ResponseStream.MoveNext(cts.Token))
                    {
                        items.AddRange(call.ResponseStream.Current.Items);
                    }
                }
                catch (RpcException ex) when (ex.StatusCode == StatusCode.Cancelled)
                {
                }

                Assert.Equal(3, items.Count);
                Assert.All(items, item => Assert.Equal(ItemDto.DataOneofCase.Conversation, item.DataCase));
            }

            return context;
        }

        public static async Task<ExecutionContext> ListenForMessages(ExecutionContext context)
        {
            var logger = context.Logger;
            var conversationId = context.GetConversationId();

            async Task<MessageDto> CreateMessage(InfMessaging.InfMessagingClient client)
            {
                var generatedMessage = context.Fixture.Create<MessageDto>();
                var request = new CreateMessageRequest
                {
                    ConversationId = conversationId,
                    Message = generatedMessage,
                };

                var response = await client.CreateMessageAsync(request, headers: context.GetAccessHeaders(UserType.Influencer));
                var message = response.Message;

                return message;
            }

            var listenClient = new InfListen.InfListenClient(context.GetServerChannel());
            var messagingClient = new InfMessaging.InfMessagingClient(context.GetServerChannel());

            var call = listenClient.Listen(headers: context.GetAccessHeaders(UserType.Influencer));

            using (call)
            {
                var filter = new ItemFilterDto
                {
                    MessageFilter = new ItemFilterDto.Types.MessageFilterDto
                    {
                        ConversationId = conversationId,
                    },
                };

                await call.RequestStream.WriteAsync(
                    new ListenRequest
                    {
                        Action = ListenRequest.Types.Action.Register,
                        Filter = filter,
                    });

                // Allow time for the listen request to "stick" (they are buffered)
                await Task.Delay(TimeSpan.FromMilliseconds(500));

                await Task
                    .WhenAll(
                        CreateMessage(messagingClient),
                        CreateMessage(messagingClient),
                        CreateMessage(messagingClient));

                var cts = new CancellationTokenSource();
                cts.CancelAfter(TimeSpan.FromSeconds(1));
                var items = new List<ItemDto>();

                try
                {
                    while (await call.ResponseStream.MoveNext(cts.Token))
                    {
                        items.AddRange(call.ResponseStream.Current.Items);
                    }
                }
                catch (RpcException ex) when (ex.StatusCode == StatusCode.Cancelled)
                {
                }

                Assert.Equal(3, items.Count);
                Assert.All(items, item => Assert.Equal(ItemDto.DataOneofCase.Message, item.DataCase));
            }

            return context;
        }
    }
}
