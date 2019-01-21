namespace Utility
{
    public struct LoginTokenValidationResult
    {
        public LoginTokenValidationResult(
            string userId,
            string userStatus,
            string userType)
        {
            this.UserId = userId;
            this.UserStatus = userStatus;
            this.UserType = userType;
        }

        public string UserId { get; }

        public string UserStatus { get; }

        public string UserType { get; }
    }
}
