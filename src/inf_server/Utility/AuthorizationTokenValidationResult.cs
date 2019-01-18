namespace Utility
{
    public struct AuthorizationTokenValidationResult
    {
        public AuthorizationTokenValidationResult(
            string userId,
            string userType)
        {
            this.UserId = userId;
            this.UserType = userType;
        }

        public string UserId { get; }

        public string UserType { get; }
    }
}
