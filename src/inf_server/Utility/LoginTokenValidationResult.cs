using System;

namespace Utility
{
    public struct LoginTokenValidationResult
    {
        public static readonly LoginTokenValidationResult Invalid = new LoginTokenValidationResult(false, default, default, default, default);

        private LoginTokenValidationResult(
            bool isValid,
            string userId,
            string userStatus,
            string userType,
            string invitationCode)
        {
            this.IsValid = isValid;
            this.userId = userId;
            this.userStatus = userStatus;
            this.userType = userType;
            this.invitationCode = invitationCode;
        }

        private readonly string userId;
        private readonly string userStatus;
        private readonly string userType;
        private readonly string invitationCode;

        public bool IsValid { get; }

        public string UserId
        {
            get
            {
                if (!IsValid)
                {
                    throw new InvalidOperationException("Invalid token.");
                }

                return this.userId;
            }
        }

        public string UserStatus
        {
            get
            {
                if (!IsValid)
                {
                    throw new InvalidOperationException("Invalid token.");
                }

                return this.userStatus;
            }
        }

        public string UserType
        {
            get
            {
                if (!IsValid)
                {
                    throw new InvalidOperationException("Invalid token.");
                }

                return this.userType;
            }
        }

        public string InvitationCode
        {
            get
            {
                if (!IsValid)
                {
                    throw new InvalidOperationException("Invalid token.");
                }

                return this.invitationCode;
            }
        }

        internal static LoginTokenValidationResult From(string userId, string userStatus, string userType, string invitationCode) =>
            new LoginTokenValidationResult(
                true,
                userId,
                userStatus,
                userType,
                invitationCode);
    }
}
