namespace Utility
{
    public struct OneTimeTokenValidationResult
    {
        public OneTimeTokenValidationResult(
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
