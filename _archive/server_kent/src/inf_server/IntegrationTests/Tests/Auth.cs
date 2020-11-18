using System;
using System.Linq;
using System.Threading.Tasks;
using API.Interfaces;
using Microsoft.Azure.Cosmos;
using Newtonsoft.Json.Linq;
using Xunit;

namespace IntegrationTests.Tests
{
    public static class Auth
    {
        public static Task<ExecutionContext> LoginNewInfluencer(ExecutionContext context) =>
            LoginNewUser(context, UserType.Influencer);

        public static Task<ExecutionContext> LoginNewBusiness(ExecutionContext context) =>
            LoginNewUser(context, UserType.Business);

        private static async Task<ExecutionContext> LoginNewUser(ExecutionContext context, UserType userType)
        {
            var logger = context.Logger;
            var code = Guid.NewGuid().ToString();
            var databaseClient = context.GetDatabaseClient();

            logger.Debug("Creating dummy invitation code");
            var expiry = DateTime.UtcNow.AddDays(1).ToString("yyyy-MM-ddTHH:mm:ss.fffZ");
            var invitationCodeJson = $@"
{{
    'schemaType': 'invitationCode',
    'schemaVersion': 1,
    'partitionKey': 'invitationCode',
    'id': '{code}',
    'expiryTimestamp': '{expiry}',
}}";
            var invitationCode = JToken.Parse(invitationCodeJson);

            await databaseClient
                .Databases["inf"]
                .Containers["default"]
                .Items
                .UpsertItemAsync("invitationCode", invitationCode);

            var client = new InfAuth.InfAuthClient(context.GetServerChannel());
            var userEmail = $"{Guid.NewGuid()}@somewhere.com";

            logger.Debug("Sending login email");
            await client.SendLoginEmailAsync(new SendLoginEmailRequest { Email = userEmail, InvitationCode = code, UserType = userType });

            logger.Debug("Reading user's login token");
            var userLoginTokenQuery = new CosmosSqlQueryDefinition("SELECT VALUE u.loginToken FROM u WHERE u.schemaType = @SchemaType AND u.email = @UserEmail");
            userLoginTokenQuery.UseParameter("@SchemaType", "user");
            userLoginTokenQuery.UseParameter("@UserEmail", userEmail);
            var resultsIterator = databaseClient
                .Databases["inf"]
                .Containers["default"]
                .Items
                .CreateItemQuery<string>(userLoginTokenQuery, 2, maxItemCount: 2);
            string loginToken = null;

            while (resultsIterator.HasMoreResults)
            {
                loginToken = (await resultsIterator.FetchNextSetAsync()).Single();
            }

            Assert.NotEmpty(loginToken);

            logger.Debug("Logging in with login token {LoginToken}", loginToken);
            var loginWithLoginTokenResult = await client.LoginWithLoginTokenAsync(new LoginWithLoginTokenRequest { LoginToken = loginToken });
            var refreshToken = loginWithLoginTokenResult.RefreshToken;

            logger.Debug("Exchanging refresh token {RefreshToken} for an access token", refreshToken);
            var loginWithRefreshTokenResult = await client.LoginWithRefreshTokenAsync(new LoginWithRefreshTokenRequest { RefreshToken = refreshToken });
            var accessToken = loginWithRefreshTokenResult.AccessToken;

            var userId = loginWithRefreshTokenResult.User.Id;

            logger.Information("Logged in as user {UserId} with login token {LoginToken}, refresh token {RefreshToken}, and access token {AccessToken}", userId, loginToken, refreshToken, accessToken);

            return context
                .WithUserId(userId, userType)
                .WithUserEmail(userEmail, userType)
                .WithLoginToken(loginToken, userType)
                .WithRefreshToken(refreshToken, userType)
                .WithAccessToken(accessToken, userType);
        }

        public static Task<ExecutionContext> ActivateInfluencer(ExecutionContext context) =>
            ActivateUser(context, UserType.Influencer);

        public static Task<ExecutionContext> ActivateBusiness(ExecutionContext context) =>
            ActivateUser(context, UserType.Business);

        private static async Task<ExecutionContext> ActivateUser(ExecutionContext context, UserType userType)
        {
            var logger = context.Logger;
            var usersClient = new InfUsers.InfUsersClient(context.GetServerChannel());
            var authClient = new InfAuth.InfAuthClient(context.GetServerChannel());
            var userId = context.GetUserId(userType);

            logger.Debug("Getting user {UserId}", userId);
            var getUserResponse = await usersClient.GetUserAsync(
                new GetUserRequest { UserId = userId },
                headers: context.GetAccessHeaders(userType));
            var user = getUserResponse.User;
            Assert.NotNull(user);

            logger.Debug("Activating user {User}", user);
            var loginToken = context.GetLoginToken(userType);
            var activateUserResponse = await authClient.ActivateUserAsync(
                new ActivateUserRequest { User = user, LoginToken = loginToken },
                headers: context.GetAccessHeaders(userType));
            user = activateUserResponse.User;
            Assert.NotNull(user);

            return context;
        }

        public static Task<ExecutionContext> LoginExistingInfluencer(ExecutionContext context) =>
            LoginExistingUser(context, UserType.Influencer);

        public static Task<ExecutionContext> LoginExistingBusiness(ExecutionContext context) =>
            LoginExistingUser(context, UserType.Business);

        private static async Task<ExecutionContext> LoginExistingUser(ExecutionContext context, UserType userType)
        {
            var logger = context.Logger;
            var client = new InfAuth.InfAuthClient(context.GetServerChannel());

            var userEmail = context.GetUserEmail(userType);

            logger.Debug("Sending login email to {Email}", userEmail);
            await client.SendLoginEmailAsync(new SendLoginEmailRequest { Email = userEmail, UserType = UserType.UnknownType });

            logger.Debug("Reading user's login token");
            var databaseClient = context.GetDatabaseClient();
            var userLoginTokenQuery = new CosmosSqlQueryDefinition("SELECT VALUE u.loginToken FROM u WHERE u.schemaType = @SchemaType AND u.email = @UserEmail");
            userLoginTokenQuery.UseParameter("@SchemaType", "user");
            userLoginTokenQuery.UseParameter("@UserEmail", userEmail);
            var resultsIterator = databaseClient
                .Databases["inf"]
                .Containers["default"]
                .Items
                .CreateItemQuery<string>(userLoginTokenQuery, 2, maxItemCount: 2);
            string loginToken = null;

            while (resultsIterator.HasMoreResults)
            {
                loginToken = (await resultsIterator.FetchNextSetAsync()).Single();
            }

            Assert.NotEmpty(loginToken);

            logger.Debug("Logging in with login token {LoginToken}", loginToken);
            var loginWithLoginTokenResult = await client.LoginWithLoginTokenAsync(new LoginWithLoginTokenRequest { LoginToken = loginToken });
            var refreshToken = loginWithLoginTokenResult.RefreshToken;

            logger.Debug("Exchanging refresh token {RefreshToken} for an access token", refreshToken);
            var loginWithRefreshTokenResult = await client.LoginWithRefreshTokenAsync(new LoginWithRefreshTokenRequest { RefreshToken = refreshToken });
            var accessToken = loginWithRefreshTokenResult.AccessToken;

            var userId = loginWithRefreshTokenResult.User.Id;

            logger.Information("Logged in as user {UserId} with login token {LoginToken}, refresh token {RefreshToken}, and access token {AccessToken}", userId, loginToken, refreshToken, accessToken);

            return context
                .WithUserId(userId, userType)
                .WithLoginToken(loginToken, userType)
                .WithRefreshToken(refreshToken, userType)
                .WithAccessToken(accessToken, userType);
        }

        public static Task<ExecutionContext> LogoutInfluencer(ExecutionContext context) =>
            LogoutUser(context, UserType.Influencer);

        public static Task<ExecutionContext> LogoutBusiness(ExecutionContext context) =>
            LogoutUser(context, UserType.Business);

        private static async Task<ExecutionContext> LogoutUser(ExecutionContext context, UserType userType)
        {
            var logger = context.Logger;
            var client = new InfAuth.InfAuthClient(context.GetServerChannel());
            var refreshToken = context.GetRefreshToken(userType);

            logger.Debug("Attempting to log back in using refresh token {RefreshToken}, expecting success", refreshToken);
            await client.LoginWithRefreshTokenAsync(new LoginWithRefreshTokenRequest { RefreshToken = refreshToken });

            logger.Debug("Logging out user with refresh token {RefreshToken}", refreshToken);
            await client.LogoutAsync(new LogoutRequest { RefreshToken = context.GetRefreshToken(userType) });

            logger.Debug("Attempting to log back in using refresh token {RefreshToken}, expecting failure", refreshToken);

            try
            {
                await client.LoginWithRefreshTokenAsync(new LoginWithRefreshTokenRequest { RefreshToken = refreshToken });
                logger.Error("Did not fail to log back in, even though refresh token {RefreshToken} should have been invalidated", refreshToken);
                Assert.True(false);
            }
            catch
            {
            }

            return context
                .WithoutLoginToken(userType)
                .WithoutRefreshToken(userType)
                .WithoutAccessToken(userType);
        }
    }
}
