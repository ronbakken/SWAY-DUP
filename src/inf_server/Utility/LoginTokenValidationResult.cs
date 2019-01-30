namespace Utility
{
    public struct LoginTokenValidationResult
    {
        public LoginTokenValidationResult(
            string userId,
            string userStatus,
            string userType,
            string invitationCode)
        {
            this.UserId = userId;
            this.UserStatus = userStatus;
            this.UserType = userType;
            this.InvitationCode = invitationCode;
        }

        public string UserId { get; }

        public string UserStatus { get; }

        public string UserType { get; }

        public string InvitationCode { get; }
    }
}
