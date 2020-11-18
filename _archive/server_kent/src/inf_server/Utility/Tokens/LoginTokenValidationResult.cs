using System;

namespace Utility.Tokens
{
    public struct LoginTokenValidationResult
    {
        public static readonly LoginTokenValidationResult Invalid = new LoginTokenValidationResult(false, default, default, default, default, default);

        private LoginTokenValidationResult(
            bool isValid,
            string userId,
            string email,
            string userStatus,
            string userType,
            string invitationCode)
        {
            this.IsValid = isValid;
            this.userId = userId;
            this.email = email;
            this.userStatus = userStatus;
            this.userType = userType;
            this.invitationCode = invitationCode;
        }

        private readonly string userId;
        private readonly string email;
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

        public string Email
        {
            get
            {
                if (!IsValid)
                {
                    throw new InvalidOperationException("Invalid token.");
                }

                return this.email;
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

        internal static LoginTokenValidationResult From(string userId, string email, string userStatus, string userType, string invitationCode) =>
            new LoginTokenValidationResult(
                true,
                userId,
                email,
                userStatus,
                userType,
                invitationCode);
    }
}
