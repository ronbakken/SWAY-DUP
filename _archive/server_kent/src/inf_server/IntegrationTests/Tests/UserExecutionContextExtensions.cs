using API.Interfaces;
using Grpc.Core;

namespace IntegrationTests.Tests
{
    // Adds user related information/abilities to execution context.
    public static class UserExecutionContextExtensions
    {
        private const string userIdKey = "UserId";
        private const string userEmailKey = "UserEmail";
        private const string loginTokenKey = "LoginToken";
        private const string refreshTokenKey = "RefreshToken";
        private const string accessTokenKey = "AccessToken";

        public static ExecutionContext WithUserId(this ExecutionContext @this, string userId, UserType userType) =>
            @this.WithDataValue(userIdKey + userType, userId);

        public static string GetUserId(this ExecutionContext @this, UserType userType) =>
            (string)@this.Data[userIdKey + userType];

        public static ExecutionContext WithUserEmail(this ExecutionContext @this, string userEmail, UserType userType) =>
            @this.WithDataValue(userEmailKey + userType, userEmail);

        public static string GetUserEmail(this ExecutionContext @this, UserType userType) =>
            (string)@this.Data[userEmailKey + userType];

        public static ExecutionContext WithLoginToken(this ExecutionContext @this, string loginToken, UserType userType) =>
            @this.WithDataValue(loginTokenKey + userType, loginToken);

        public static ExecutionContext WithoutLoginToken(this ExecutionContext @this, UserType userType) =>
            @this.WithoutDataValue(loginTokenKey + userType);

        public static string GetLoginToken(this ExecutionContext @this, UserType userType) =>
            (string)@this.Data[loginTokenKey + userType];

        public static ExecutionContext WithRefreshToken(this ExecutionContext @this, string refreshToken, UserType userType) =>
            @this.WithDataValue(refreshTokenKey + userType, refreshToken);

        public static ExecutionContext WithoutRefreshToken(this ExecutionContext @this, UserType userType) =>
            @this.WithoutDataValue(refreshTokenKey + userType);

        public static string GetRefreshToken(this ExecutionContext @this, UserType userType) =>
            (string)@this.Data[refreshTokenKey + userType];

        public static ExecutionContext WithAccessToken(this ExecutionContext @this, string accessToken, UserType userType) =>
            @this.WithDataValue(accessTokenKey + userType, accessToken);

        public static ExecutionContext WithoutAccessToken(this ExecutionContext @this, UserType userType) =>
            @this.WithoutDataValue(accessTokenKey + userType);

        public static string GetAccessToken(this ExecutionContext @this, UserType userType) =>
            (string)@this.Data[accessTokenKey + userType];

        public static Metadata GetAccessHeaders(this ExecutionContext @this, UserType userType)
        {
            var headers = new Metadata();
            headers.Add(new Metadata.Entry("Authorization", "Bearer " + @this.GetAccessToken(userType)));
            return headers;
        }
    }
}
