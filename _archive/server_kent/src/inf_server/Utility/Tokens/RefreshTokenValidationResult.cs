using System;

namespace Utility.Tokens
{
    public struct RefreshTokenValidationResult
    {
        public static readonly RefreshTokenValidationResult Invalid = new RefreshTokenValidationResult(false, default, default);

        private RefreshTokenValidationResult(
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

        internal static RefreshTokenValidationResult From(string userId, string userType) =>
            new RefreshTokenValidationResult(
                true,
                userId,
                userType);
    }
}
