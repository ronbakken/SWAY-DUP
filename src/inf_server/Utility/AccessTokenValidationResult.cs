using System;

namespace Utility
{
    public struct AccessTokenValidationResult
    {
        public static readonly AccessTokenValidationResult Invalid = new AccessTokenValidationResult(false, default, default);

        private AccessTokenValidationResult(
            bool isValid,
            string userId,
            string userType)
        {
            this.IsValid = isValid;
            this.userId = userId;
            this.userType = userType;
        }

        private readonly string userId;
        private readonly string userType;

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

        internal static AccessTokenValidationResult From(string userId, string userType) =>
            new AccessTokenValidationResult(
                true,
                userId,
                userType);
    }
}
