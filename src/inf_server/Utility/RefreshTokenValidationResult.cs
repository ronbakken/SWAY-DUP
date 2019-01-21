namespace Utility
{
    public struct RefreshTokenValidationResult
    {
        public RefreshTokenValidationResult(
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
