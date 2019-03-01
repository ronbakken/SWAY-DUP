using System.Threading.Tasks;
using API.Interfaces;
using AutoFixture;
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
    }
}
