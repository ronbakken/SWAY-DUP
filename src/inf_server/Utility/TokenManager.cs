using System;
using System.Collections.Generic;
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
        private const string signingSecret = "utNULhCvR6FTH7HaSjVid4VGmMk8yL4Xep8GnhM6ZvLmFVdfumnpzobtuuLXxyx9XksWyAhlV9AeIaJSGZEGhg==";
        private const string encryptingSecret = "YQ1Dry8XqxydjPVNo9hA582xFuwCc3ULd+I+s/rUQIo=";
        private const string issuer = "https://api.inf-marketplace.com";
        private const string userStatusClaimType = "userStatus";
        private const string loginTokenType = "login";
        private const string refreshTokenType = "refresh";
        private const string accessTokenType = "access";

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
        /// Generates a login token.
        /// </summary>
        /// <remarks>
        /// <para>
        /// Login tokens are one-time-use, JWT tokens used to verify that a user owns an email address. They are emailed
        /// to users in the form of a deep link. Tapping the link will open the mobile app and validate the token
        /// against the server. They are intentionally reversible so that the client can obtain information it requires
        /// to make decisions based on the user information embedded in the token's payload.
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
        public static string GenerateLoginToken(string userId, string userStatus, string userType)
        {
            var descriptor = new SecurityTokenDescriptor
            {
                Issuer = issuer,
                IssuedAt = DateTime.Now,
                Audience = userType,
                Subject = new ClaimsIdentity(
                    new[]
                    {
                        new Claim(JwtRegisteredClaimNames.Sub, loginTokenType),
                        new Claim(JwtRegisteredClaimNames.Email, userId),
                        new Claim(userStatusClaimType, userStatus),
                    }),
                Expires = DateTime.UtcNow.AddHours(12),
                SigningCredentials = GetSigningCredentials(),
            };
            var handler = new JwtSecurityTokenHandler();
            var token = handler.CreateJwtSecurityToken(descriptor);
            return handler.WriteToken(token);
        }

        /// <summary>
        /// Validates a login token, throwing an exception if validation fails.
        /// </summary>
        /// <param name="token">
        /// The token to validate.
        /// </param>
        /// <returns>
        /// The results of a successful validation.
        /// </returns>
        public static LoginTokenValidationResult ValidateLoginToken(string token)
        {
            var principal = GetPrincipal(token, requireExpirationTime: true);

            if (principal == null)
            {
                throw new ArgumentException("Not a valid token.", nameof(token));
            }

            var identity = (ClaimsIdentity)principal.Identity;
            var subjectClaim = identity.FindFirst(JwtRegisteredClaimNames.Sub);
            var subject = subjectClaim?.Value;
            var emailClaim = identity.FindFirst(JwtRegisteredClaimNames.Email);
            var email = emailClaim?.Value;
            var userStatusClaim = identity.FindFirst(userStatusClaimType);
            var userStatus = userStatusClaim?.Value;
            var audienceClaim = identity.FindFirst(JwtRegisteredClaimNames.Aud);
            var audience = audienceClaim?.Value;

            if (subject == null || subject != loginTokenType || email == null || userStatus == null || audience == null)
            {
                throw new ArgumentException("Not a valid token.", nameof(token));
            }

            return new LoginTokenValidationResult(email, userStatus, audience);
        }

        /// <summary>
        /// Generates a refresh token.
        /// </summary>
        /// <remarks>
        /// <para>
        /// Refresh tokens are long-lived tokens stored securely by clients. They are used to obtain short-lived
        /// API tokens so that API calls can be made. They are non-reversible by virtue of being encrypted.
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
        public static string GenerateRefreshToken(string userId, string userType)
        {
            var descriptor = new SecurityTokenDescriptor
            {
                Issuer = issuer,
                IssuedAt = DateTime.Now,
                Audience = userType,
                Subject = new ClaimsIdentity(
                    new[]
                    {
                        new Claim(JwtRegisteredClaimNames.Sub, refreshTokenType),
                        new Claim(JwtRegisteredClaimNames.Email, userId),
                    }),
                SigningCredentials = GetSigningCredentials(),
                EncryptingCredentials = GetEncryptingCredentials(),
            };
            var handler = new JwtSecurityTokenHandler();
            var token = handler.CreateJwtSecurityToken(descriptor);
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
            var principal = GetPrincipal(
                token,
                requireExpirationTime: true,
                decrypt: true);

            if (principal == null)
            {
                throw new ArgumentException("Not a valid token.", nameof(token));
            }

            var identity = (ClaimsIdentity)principal.Identity;
            var subjectClaim = identity.FindFirst(JwtRegisteredClaimNames.Sub);
            var subject = subjectClaim?.Value;
            var emailClaim = identity.FindFirst(JwtRegisteredClaimNames.Email);
            var email = emailClaim?.Value;
            var audienceClaim = identity.FindFirst(JwtRegisteredClaimNames.Aud);
            var audience = audienceClaim?.Value;

            if (subject == null || subject != refreshTokenType || email == null || audience == null)
            {
                throw new ArgumentException("Not a valid token.", nameof(token));
            }

            return new RefreshTokenValidationResult(email, audience);
        }

        /// <summary>
        /// Generates an access token.
        /// </summary>
        /// <remarks>
        /// <para>
        /// Access tokens are short-lived, irreversible JWT tokens used to verify that a client is authorized to call an API
        /// (gRPC procedure). They are issued upon request when a valid refresh token is provided.
        /// </para>
        /// <para>
        /// These tokens encapsulate an associated user ID and their type. This information is included in the token so that
        /// the server can make authorization decisions based upon it, but is inaccessible to the client due to the token
        /// being encrypted.
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
        public static string GenerateAccessToken(string userId, string userType)
        {
            var descriptor = new SecurityTokenDescriptor
            {
                Issuer = issuer,
                IssuedAt = DateTime.Now,
                Expires = DateTime.UtcNow.AddMinutes(30),
                Audience = userType,
                Subject = new ClaimsIdentity(
                    new[]
                    {
                        new Claim(JwtRegisteredClaimNames.Sub, accessTokenType),
                        new Claim(JwtRegisteredClaimNames.Email, userId),
                    }),
                SigningCredentials = GetSigningCredentials(),
                EncryptingCredentials = GetEncryptingCredentials(),
            };
            var handler = new JwtSecurityTokenHandler();
            var token = handler.CreateJwtSecurityToken(descriptor);
            return handler.WriteToken(token);
        }

        /// <summary>
        /// Validates a login token, throwing an exception if validation fails.
        /// </summary>
        /// <param name="token">
        /// The token to validate.
        /// </param>
        /// <returns>
        /// The results of a successful validation.
        /// </returns>
        public static AccessTokenValidationResult ValidateAccessToken(string token)
        {
            var principal = GetPrincipal(
                token,
                requireExpirationTime: true,
                decrypt: true);

            if (principal == null)
            {
                throw new ArgumentException("Not a valid token.", nameof(token));
            }

            var identity = (ClaimsIdentity)principal.Identity;
            var subjectClaim = identity.FindFirst(JwtRegisteredClaimNames.Sub);
            var subject = subjectClaim?.Value;
            var emailClaim = identity.FindFirst(JwtRegisteredClaimNames.Email);
            var email = emailClaim?.Value;
            var audienceClaim = identity.FindFirst(JwtRegisteredClaimNames.Aud);
            var audience = audienceClaim?.Value;

            if (subject == null || subject != accessTokenType || email == null || audience == null)
            {
                throw new ArgumentException("Not a valid token.", nameof(token));
            }

            return new AccessTokenValidationResult(email, audience);
        }

        private static ClaimsPrincipal GetPrincipal(string token, bool requireExpirationTime, bool decrypt = false)
        {
            try
            {
                var tokenHandler = new JwtSecurityTokenHandler
                {
                    // Disable mapping default handler that maps short claim names to .NET's long claim names.
                    InboundClaimTypeMap = new Dictionary<string, string>(),
                };
                var jwtToken = (JwtSecurityToken)tokenHandler.ReadToken(token);

                if (jwtToken == null)
                {
                    return null;
                }

                var parameters = new TokenValidationParameters
                {
                    RequireExpirationTime = requireExpirationTime,
                    ValidateIssuer = true,
                    ValidateAudience = false,
                    IssuerSigningKey = new SymmetricSecurityKey(Convert.FromBase64String(signingSecret)),
                    TokenDecryptionKey = decrypt ? new SymmetricSecurityKey(Convert.FromBase64String(encryptingSecret)) : null,
                    ClockSkew = TimeSpan.Zero,
                    ValidIssuer = issuer,
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
            var key = Convert.FromBase64String(signingSecret);
            var securityKey = new SymmetricSecurityKey(key);
            var signingCredentials = new SigningCredentials(securityKey, SecurityAlgorithms.HmacSha256Signature);

            return signingCredentials;
        }

        private static EncryptingCredentials GetEncryptingCredentials()
        {
            var key = Convert.FromBase64String(encryptingSecret);
            var securityKey = new SymmetricSecurityKey(key);
            var encryptingCredentials = new EncryptingCredentials(securityKey, SecurityAlgorithms.Aes256KW, SecurityAlgorithms.Aes256CbcHmacSha512);

            return encryptingCredentials;
        }
    }
}
