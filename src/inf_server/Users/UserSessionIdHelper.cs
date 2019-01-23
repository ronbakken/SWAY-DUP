namespace Users
{
    public static class UserSessionIdHelper
    {
        public static string GetIdFrom(string refreshToken) =>
            // CosmosDB document IDs must be 254 characters or fewer.
            refreshToken.Substring(0, 254);
    }
}
