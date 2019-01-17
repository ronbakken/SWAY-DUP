using System;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Security.Cryptography;
using Microsoft.IdentityModel.Tokens;

namespace Utility
{
    /// <summary>
    /// Generates and validates session tokens, which are in JWT format.
    /// </summary>
    public static class TokenManager
    {
        private static readonly string secret = "utNULhCvR6FTH7HaSjVid4VGmMk8yL4Xep8GnhM6ZvLmFVdfumnpzobtuuLXxyx9XksWyAhlV9AeIaJSGZEGhg==";

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
            var principal = GetPrincipal(token);

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

        private static ClaimsPrincipal GetPrincipal(string token)
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

                var parameters = new TokenValidationParameters()
                {
                    ValidateIssuer = false,
                    ValidateAudience = false,
                    IssuerSigningKey = new SymmetricSecurityKey(key),
                };

                var principal = tokenHandler.ValidateToken(token, parameters, out var securityToken);
                return principal;
            }
            catch (Exception)
            {
                return null;
            }
        }
    }
}
