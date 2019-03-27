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
    public static class Users
    {
        public static Task<ExecutionContext> UpdateInfluencer(ExecutionContext context) =>
            UpdateUser(context, UserType.Influencer);

        public static Task<ExecutionContext> UpdateBusiness(ExecutionContext context) =>
            UpdateUser(context, UserType.Business);

        private static async Task<ExecutionContext> UpdateUser(ExecutionContext context, UserType userType)
        {
            var logger = context.Logger;
            var client = new InfUsers.InfUsersClient(context.GetServerChannel());
            var userId = context.GetUserId(userType);

            logger.Debug("Getting user {UserId}", userId);
            var getUserResponse = await client.GetUserAsync(
                new GetUserRequest { UserId = userId },
                headers: context.GetAccessHeaders(userType));
            var user = getUserResponse.User;

            var generatedUser = context.Fixture.Create<UserDto>();
            generatedUser.Id = userId;
            generatedUser.Revision = user.Revision;
            generatedUser.Full.Email = user.Full.Email;
            generatedUser.Full.Type = user.Full.Type;

            logger.Debug("Updating user data to {@User}", user);
            await client.UpdateUserAsync(new UpdateUserRequest { User = generatedUser }, headers: context.GetAccessHeaders(userType));

            logger.Debug("Requesting user data back from server");
            getUserResponse = await client.GetUserAsync(new GetUserRequest { UserId = userId }, headers: context.GetAccessHeaders(userType));
            var userReceived = getUserResponse.User;

            logger.Debug("Validating that user sent {@User} is equivalent to user received {@UserReceived} (apart from revision)", generatedUser, userReceived);
            generatedUser.Revision = userReceived.Revision;
            Assert.Equal(generatedUser, userReceived);

            return context;
        }

        public static Task<ExecutionContext> ListUsersAsAnInfluencer(ExecutionContext context) =>
            ListUsersAsUserType(context, UserType.Influencer);

        public static Task<ExecutionContext> ListUsersAsABusiness(ExecutionContext context) =>
            ListUsersAsUserType(context, UserType.Business);

        private static async Task<ExecutionContext> ListUsersAsUserType(ExecutionContext context, UserType userType)
        {
            var logger = context.Logger;
            var client = new InfList.InfListClient(context.GetServerChannel());

            var call = client.List(headers: context.GetAccessHeaders(userType));

            using (call)
            {
                var filter = new ItemFilterDto
                {
                    UserFilter = new ItemFilterDto.Types.UserFilterDto
                    {
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
                    Assert.Equal(ItemDto.DataOneofCase.User, item.DataCase);
                    Assert.Equal(UserDto.DataOneofCase.List, item.User.DataCase);

                    // Influencers should never see other influencers, nor should business see other businesses
                    Assert.NotEqual(userType, item.User.List.Type);
                }
            }

            return context;
        }

        public static async Task<ExecutionContext> ListenForSingleUser(ExecutionContext context)
        {
            var logger = context.Logger;
            var client = new InfListen.InfListenClient(context.GetServerChannel());

            var call = client.Listen(headers: context.GetAccessHeaders(UserType.Influencer));
            var userIdToListenTo = context.GetUserId(UserType.Influencer);

            using (call)
            {
                await call.RequestStream.WriteAsync(
                    new ListenRequest
                    {
                        Action = ListenRequest.Types.Action.Register,
                        SingleItemFilter = new SingleItemFilterDto
                        {
                            Type = SingleItemFilterDto.Types.Type.User,
                            Id = userIdToListenTo
                        }
                    });

                // Allow time for the listen request to "stick" (they are buffered)
                await Task.Delay(TimeSpan.FromMilliseconds(500));

                // Kick off a task to update the relevant user
                Task
                    .Run(
                        async () =>
                        {
                            var usersClient = new InfUsers.InfUsersClient(context.GetServerChannel());
                            var getUserResponse = await usersClient.GetUserAsync(new GetUserRequest { UserId = userIdToListenTo }, headers: context.GetAccessHeaders(UserType.Influencer));

                            var modifiedUser = getUserResponse.User;
                            modifiedUser.Full.Description += "Foo";

                            await usersClient.UpdateUserAsync(new UpdateUserRequest { User = modifiedUser }, headers: context.GetAccessHeaders(UserType.Influencer));
                        })
                    .Ignore();

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

                Assert.Single(items);

                Assert.Equal(ItemDto.DataOneofCase.User, items[0].DataCase);
                Assert.Equal(UserDto.DataOneofCase.Full, items[0].User.DataCase);
            }

            return context;
        }
    }
}
