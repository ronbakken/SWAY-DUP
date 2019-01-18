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
        private static readonly string secret = "utNULhCvR6FTH7HaSjVid4VGmMk8yL4Xep8GnhM6ZvLmFVdfumnpzobtuuLXxyx9XksWyAhlV9AeIaJSGZEGhg==";

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
        /// A one-time access token is a JWT token that encapsulates an associated user ID, their status, and their
        /// type. Status information can be included in the token so that clients can make decisions based upon it.
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
            var key = Convert.FromBase64String(secret);
            var handler = new JwtSecurityTokenHandler();
            var securityKey = new SymmetricSecurityKey(key);
            var descriptor = new SecurityTokenDescriptor
            {
                Subject = new ClaimsIdentity(
                    new[]
                    {
                    new Claim(ClaimTypes.NameIdentifier, userId),
                    }),
                Expires = DateTime.UtcNow.AddHours(12),
                IssuedAt = DateTime.Now,
                SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256Signature),
            };

            var token = handler.CreateJwtSecurityToken(descriptor);
            token.Payload["status"] = userStatus;
            token.Payload["type"] = userType;
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
            var userIdClaim = identity.FindFirst(ClaimTypes.NameIdentifier);
            var statusClaim = identity.FindFirst("status");
            var typeClaim = identity.FindFirst("type");
            var userId = userIdClaim?.Value;
            var status = statusClaim?.Value;
            var type = typeClaim?.Value;

            if (userId == null || status == null || type == null)
            {
                throw new ArgumentException("Not a valid token.", nameof(token));
            }

            return new OneTimeTokenValidationResult(userId, status, type);
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























        // REMOVE ALL THIS!?


        /// <summary>
        /// Generates a session ID, then generates a token representing that session ID.
        /// </summary>
        /// <returns>
        /// A new token that represents a generated session ID.
        /// </returns>
        public static string GenerateToken()
        {
            var hmac = new HMACSHA256();
            var sessionId = Convert.ToBase64String(hmac.Key);
            return GenerateToken(sessionId);
        }

        /// <summary>
        /// Generate a token for the specified session ID.
        /// </summary>
        /// <param name="sessionId">
        /// The session ID.
        /// </param>
        /// <returns>
        /// A new token that represents the specified session ID.
        /// </returns>
        public static string GenerateToken(string sessionId)
        {
            var key = Convert.FromBase64String(secret);
            var handler = new JwtSecurityTokenHandler();
            var securityKey = new SymmetricSecurityKey(key);
            var descriptor = new SecurityTokenDescriptor
            {
                Subject = new ClaimsIdentity(
                    new[]
                    {
                        new Claim("sessionId", sessionId)
                    }),
                IssuedAt = DateTime.Now,
                SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256Signature),
            };

            var token = handler.CreateJwtSecurityToken(descriptor);
            return handler.WriteToken(token);
        }

        /// <summary>
        /// Gets the session ID from a given token.
        /// </summary>
        /// <param name="token">
        /// The token that was created with <see cref="GenerateToken"/>.
        /// </param>
        /// <returns>
        /// The session ID.
        /// </returns>
        public static string GetSessionId(string token)
        {
            string sessionId = null;
            var principal = GetPrincipal(token, requireExpirationTime: false);

            if (principal == null)
            {
                throw new ArgumentException("Not a valid session token.", nameof(token));
            }

            var identity = (ClaimsIdentity)principal.Identity;
            var sessionIdClaim = identity.FindFirst("sessionId");
            sessionId = sessionIdClaim?.Value;

            if (sessionId == null)
            {
                throw new ArgumentException("Not a valid session token.", nameof(token));
            }

            return sessionId;
        }
    }
}
