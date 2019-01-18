using System;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Security.Cryptography;
using Microsoft.IdentityModel.Tokens;

namespace Utility
{
    /// <summary>
    /// Manages token generation and validation.
    /// </summary>
    public static class TokenManager
    {
        private const string secret = "utNULhCvR6FTH7HaSjVid4VGmMk8yL4Xep8GnhM6ZvLmFVdfumnpzobtuuLXxyx9XksWyAhlV9AeIaJSGZEGhg==";
        private const string tokenTypeClaimType = "tokenType";
        private const string userTypeClaimType = "userType";
        private const string userStatusClaimType = "userStatus";
        private const string oneTimeAccessTokenType = "one-time access";
        private const string refreshTokenType = "refresh";
        private const string authorizationTokenType = "authorization";

        /// <summary>
        /// Generate an opaque, general-purpose token.
        /// </summary>
        /// <returns>
        /// An opaque token.
        /// </returns>
        public static string GenerateOpaqueToken()
        {
            var hmac = new HMACSHA256();
            var token = Convert.ToBase64String(hmac.Key);
            return token;
        }

        /// <summary>
        /// Generates a one-time access token.
        /// </summary>
        /// <remarks>
        /// <para>
        /// One-time access tokens are JWT tokens used to verify that a user owns an email address. They are emailed
        /// to users in the form of a deep link. Tapping the link will open the mobile app and validate the token
        /// against the server.
        /// </para>
        /// <para>
        /// These tokens encapsulate an associated user ID, their status, and their type. Status and type information
        /// is included in the token so that clients can make decisions based upon it.
        /// </para>
        /// </remarks>
        /// <param name="userId">
        /// The associated user ID.
        /// </param>
        /// <param name="userStatus">
        /// The status of the user.
        /// </param>
        /// <param name="userType">
        /// The type of the user.
        /// </param>
        /// <returns>
        /// The token in JWT format.
        /// </returns>
        public static string GenerateOneTimeAccessToken(string userId, string userStatus, string userType)
        {
            var descriptor = new SecurityTokenDescriptor
            {
                Subject = new ClaimsIdentity(
                    new[]
                    {
                        new Claim(ClaimTypes.NameIdentifier, userId),
                    }),
                Expires = DateTime.UtcNow.AddHours(12),
                IssuedAt = DateTime.Now,
                SigningCredentials = GetSigningCredentials(),
            };
            var handler = new JwtSecurityTokenHandler();
            var token = handler.CreateJwtSecurityToken(descriptor);
            token.Payload[tokenTypeClaimType] = oneTimeAccessTokenType;
            token.Payload[userStatusClaimType] = userStatus;
            token.Payload[userType] = userType;
            return handler.WriteToken(token);
        }

        /// <summary>
        /// Validates a one-time access token, throwing an exception if validation fails.
        /// </summary>
        /// <param name="token">
        /// The token to validate.
        /// </param>
        /// <returns>
        /// The results of a successful validation.
        /// </returns>
        public static OneTimeTokenValidationResult ValidateOneTimeAccessToken(string token)
        {
            var principal = GetPrincipal(token, requireExpirationTime: true);

            if (principal == null)
            {
                throw new ArgumentException("Not a valid token.", nameof(token));
            }

            var identity = (ClaimsIdentity)principal.Identity;
            var tokenTypeClaim = identity.FindFirst(tokenTypeClaimType);
            var tokenType = tokenTypeClaim?.Value;
            var userIdClaim = identity.FindFirst(ClaimTypes.NameIdentifier);
            var userId = userIdClaim?.Value;
            var userStatusClaim = identity.FindFirst(userStatusClaimType);
            var userStatus = userStatusClaim?.Value;
            var userTypeClaim = identity.FindFirst(userTypeClaimType);
            var userType = userTypeClaim?.Value;

            if (tokenType == null || tokenType != oneTimeAccessTokenType || userId == null || userStatus == null || userType == null)
            {
                throw new ArgumentException("Not a valid token.", nameof(token));
            }

            return new OneTimeTokenValidationResult(userId, userStatus, userType);
        }

        /// <summary>
        /// Generates a refresh token.
        /// </summary>
        /// <remarks>
        /// <para>
        /// Refresh tokens are long-lived tokens stored securely by clients. They are used to obtain short-lived
        /// API tokens so that API calls can be made.
        /// </para>
        /// </remarks>
        /// <param name="userId">
        /// The associated user ID.
        /// </param>
        /// <returns>
        /// The token in JWT format.
        /// </returns>
        public static string GenerateRefreshToken(string userId)
        {
            var descriptor = new SecurityTokenDescriptor
            {
                Subject = new ClaimsIdentity(
                    new[]
                    {
                        new Claim(ClaimTypes.NameIdentifier, userId),
                    }),
                IssuedAt = DateTime.Now,
                SigningCredentials = GetSigningCredentials(),
            };
            var handler = new JwtSecurityTokenHandler();
            var token = handler.CreateJwtSecurityToken(descriptor);
            token.Payload[tokenTypeClaimType] = refreshTokenType;
            return handler.WriteToken(token);
        }

        /// <summary>
        /// Validates a refresh token, throwing an exception if validation fails.
        /// </summary>
        /// <param name="token">
        /// The token to validate.
        /// </param>
        /// <returns>
        /// The results of a successful validation.
        /// </returns>
        public static RefreshTokenValidationResult ValidateRefreshToken(string token)
        {
            var principal = GetPrincipal(token, requireExpirationTime: true);

            if (principal == null)
            {
                throw new ArgumentException("Not a valid token.", nameof(token));
            }

            var identity = (ClaimsIdentity)principal.Identity;
            var tokenTypeClaim = identity.FindFirst(tokenTypeClaimType);
            var tokenType = tokenTypeClaim?.Value;
            var userIdClaim = identity.FindFirst(ClaimTypes.NameIdentifier);
            var userId = userIdClaim?.Value;

            if (tokenType == null || tokenType != refreshTokenType || userId == null)
            {
                throw new ArgumentException("Not a valid token.", nameof(token));
            }

            return new RefreshTokenValidationResult(userId);
        }

        /// <summary>
        /// Generates an authorization token.
        /// </summary>
        /// <remarks>
        /// <para>
        /// Authorization tokens are JWT tokens used to verify that a client is authorized to call an API (gRPC procedure).
        /// They are short-lived tokens, issued upon request when a valid refresh token is provided.
        /// </para>
        /// <para>
        /// These tokens encapsulate an associated user ID and their type. This information is included in the token so that
        /// the server can make authorization decisions based upon it.
        /// </para>
        /// </remarks>
        /// <param name="userId">
        /// The associated user ID.
        /// </param>
        /// <param name="userType">
        /// The type of the user.
        /// </param>
        /// <returns>
        /// The token in JWT format.
        /// </returns>
        public static string GenerateAuthorizationToken(string userId, string userType)
        {
            var descriptor = new SecurityTokenDescriptor
            {
                Subject = new ClaimsIdentity(
                    new[]
                    {
                        new Claim(ClaimTypes.NameIdentifier, userId),
                    }),
                Expires = DateTime.UtcNow.AddMinutes(30),
                IssuedAt = DateTime.Now,
                SigningCredentials = GetSigningCredentials(),
            };
            var handler = new JwtSecurityTokenHandler();
            var token = handler.CreateJwtSecurityToken(descriptor);
            token.Payload[tokenTypeClaimType] = authorizationTokenType;
            token.Payload[userTypeClaimType] = userType;
            return handler.WriteToken(token);
        }

        /// <summary>
        /// Validates a one-time access token, throwing an exception if validation fails.
        /// </summary>
        /// <param name="token">
        /// The token to validate.
        /// </param>
        /// <returns>
        /// The results of a successful validation.
        /// </returns>
        public static AuthorizationTokenValidationResult ValidateAuthorizationToken(string token)
        {
            var principal = GetPrincipal(token, requireExpirationTime: true);

            if (principal == null)
            {
                throw new ArgumentException("Not a valid token.", nameof(token));
            }

            var identity = (ClaimsIdentity)principal.Identity;
            var tokenTypeClaim = identity.FindFirst(tokenTypeClaimType);
            var tokenType = tokenTypeClaim?.Value;
            var userIdClaim = identity.FindFirst(ClaimTypes.NameIdentifier);
            var userId = userIdClaim?.Value;
            var userTypeClaim = identity.FindFirst(userTypeClaimType);
            var userType = userTypeClaim?.Value;

            if (tokenType == null || tokenType != authorizationTokenType || userId == null || userType == null)
            {
                throw new ArgumentException("Not a valid token.", nameof(token));
            }

            return new AuthorizationTokenValidationResult(userId, userType);
        }

        private static ClaimsPrincipal GetPrincipal(string token, bool requireExpirationTime)
        {
            try
            {
                var tokenHandler = new JwtSecurityTokenHandler();
                var jwtToken = (JwtSecurityToken)tokenHandler.ReadToken(token);

                if (jwtToken == null)
                {
                    return null;
                }

                var key = Convert.FromBase64String(secret);

                var parameters = new TokenValidationParameters
                {
                    RequireExpirationTime = requireExpirationTime,
                    ValidateIssuer = false,
                    ValidateAudience = false,
                    IssuerSigningKey = new SymmetricSecurityKey(key),
                    ClockSkew = TimeSpan.Zero,
                };

                var principal = tokenHandler.ValidateToken(token, parameters, out var securityToken);
                return principal;
            }
            catch (Exception)
            {
                return null;
            }
        }

        private static SigningCredentials GetSigningCredentials()
        {
            var key = Convert.FromBase64String(secret);

            // TODO: this will need to be asymmetric so that client can validate
            var securityKey = new SymmetricSecurityKey(key);
            var signingCredentials = new SigningCredentials(securityKey, SecurityAlgorithms.HmacSha256Signature);

            return signingCredentials;
        }
    }
}
