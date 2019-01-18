namespace Utility
{
    public struct RefreshTokenValidationResult
    {
        public RefreshTokenValidationResult(
            string userId)
        {
            this.UserId = userId;
        }

        public string UserId { get; }
    }
}
