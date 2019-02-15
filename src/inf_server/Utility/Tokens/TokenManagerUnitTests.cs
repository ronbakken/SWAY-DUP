using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Security.Claims;
using Microsoft.IdentityModel.Tokens;
using Xunit;

namespace Utility.Tokens
{
    public sealed class TokenManagerUnitTests
    {
        [Theory]
        [InlineData("ID1", "kent.boogaart@gmail.com", "WaitingForActivation", "Influencer", "ABC123")]
        [InlineData("ID2", "someone@somewhere.com", "Disabled", "Business", "XYZ789")]
        public void login_tokens_generate_and_validate_correctly(
            string userId,
            string email,
            string userStatus,
            string userType,
            string invitationCode)
        {
            var loginToken = TokenManager.GenerateLoginToken(
                userId,
                email,
                userStatus,
                userType,
                invitationCode);

            var validationResult = TokenManager.ValidateLoginToken(loginToken);

            Assert.True(validationResult.IsValid);
            Assert.Equal(userId, validationResult.UserId);
            Assert.Equal(email, validationResult.Email);
            Assert.Equal(userStatus, validationResult.UserStatus);
            Assert.Equal(userType, validationResult.UserType);
            Assert.Equal(invitationCode, validationResult.InvitationCode);
        }

        [Theory]
        [InlineData("ID1", "kent.boogaart@gmail.com", "WaitingForActivation", "Influencer", "ABC123")]
        [InlineData("ID2", "someone@somewhere.com", "Disabled", "Business", "XYZ789")]
        public void login_tokens_are_reversible(
            string userId,
            string email,
            string userStatus,
            string userType,
            string invitationCode)
        {
            var loginToken = TokenManager.GenerateLoginToken(
                userId,
                email,
                userStatus,
                userType,
                invitationCode);

            // Pretend to be a client without access to the TokenManager (or its secrets).
            var tokenHandler = new JwtSecurityTokenHandler
            {
                // Disable mapping default handler that maps short claim names to .NET's long claim names.
                InboundClaimTypeMap = new Dictionary<string, string>(),
            };
            var jwtToken = (JwtSecurityToken)tokenHandler.ReadToken(loginToken);

            Assert.NotNull(jwtToken);

            Assert.Equal("https://api.sway-marketplace.com", jwtToken.Issuer);
            Assert.Equal(userId, jwtToken.Subject);
            Assert.Equal(userType, jwtToken.Audiences.First());
            var claims = jwtToken.Claims;
            Assert.Equal("login", claims.FirstOrDefault(claim => claim.Type == "_tt").Value);
            Assert.Equal(email, claims.FirstOrDefault(claim => claim.Type == "email").Value);
            Assert.Equal(userStatus, claims.FirstOrDefault(claim => claim.Type == "userStatus").Value);
            Assert.Equal(invitationCode, claims.FirstOrDefault(claim => claim.Type == "_ic").Value);
        }

        [Fact]
        public void login_tokens_cannot_be_spoofed()
        {
            // Try to create a token that will successfully validate using TokenManager. Without access to the secret,
            // I just made my own and hoped the server would accept it.
            var key = Convert.FromBase64String("n1C4kLt0EZ1gpSzc8QW1JPd54VqH8XemGXL4JvTRYHjsaAv/A6kt6U8hUU7qVc8rlqvPsLmdIgpS7RHfoamz0A==");
            var securityKey = new SymmetricSecurityKey(key);
            var signingCredentials = new SigningCredentials(securityKey, SecurityAlgorithms.HmacSha256Signature);
            var descriptor = new SecurityTokenDescriptor
            {
                Issuer = "https://api.sway-marketplace.com",
                IssuedAt = DateTime.Now,
                Audience = "Influencer",
                Subject = new ClaimsIdentity(
                    new[]
                    {
                        new Claim(JwtRegisteredClaimNames.Sub, "login"),
                        new Claim(JwtRegisteredClaimNames.Email, "kent.boogaart@gmail.com"),
                        new Claim("userStatus", "WaitingForActivation"),
                        new Claim("invitationCode", "ABC123"),
                    }),
                Expires = DateTime.UtcNow.AddHours(12),
                SigningCredentials = signingCredentials,
            };
            var handler = new JwtSecurityTokenHandler();
            var token = handler.CreateJwtSecurityToken(descriptor);
            var loginToken = handler.WriteToken(token);

            var result = TokenManager.ValidateLoginToken(loginToken);
            Assert.False(result.IsValid);
        }

        [Theory]
        [InlineData("kent.boogaart@gmail.com", "Influencer")]
        [InlineData("someone@somewhere.com", "Business")]
        public void refresh_tokens_generate_and_validate_correctly(
            string userId,
            string userType)
        {
            var refreshToken = TokenManager.GenerateRefreshToken(
                userId,
                userType);

            var validationResult = TokenManager.ValidateRefreshToken(refreshToken);

            Assert.True(validationResult.IsValid);
            Assert.Equal(userId, validationResult.UserId);
            Assert.Equal(userType, validationResult.UserType);
        }

        [Theory]
        [InlineData("kent.boogaart@gmail.com", "Influencer")]
        [InlineData("someone@somewhere.com", "Business")]
        public void refresh_tokens_are_irreversible(
            string userId,
            string userType)
        {
            var refreshToken = TokenManager.GenerateRefreshToken(
                userId,
                userType);

            // Pretend to be a client without access to the TokenManager (or its secrets).
            var tokenHandler = new JwtSecurityTokenHandler
            {
                // Disable mapping default handler that maps short claim names to .NET's long claim names.
                InboundClaimTypeMap = new Dictionary<string, string>(),
            };
            var jwtToken = (JwtSecurityToken)tokenHandler.ReadToken(refreshToken);

            Assert.NotNull(jwtToken);

            Assert.Null(jwtToken.Issuer);
            Assert.Null(jwtToken.Subject);
            Assert.Empty(jwtToken.Audiences);
            Assert.Empty(jwtToken.Claims);
        }

        [Theory]
        [InlineData("kent.boogaart@gmail.com", "Influencer")]
        [InlineData("someone@somewhere.com", "Business")]
        public void access_tokens_generate_and_validate_correctly(
            string userId,
            string userType)
        {
            var accessToken = TokenManager.GenerateAccessToken(
                userId,
                userType);

            var validationResult = TokenManager.ValidateAccessToken(accessToken);

            Assert.True(validationResult.IsValid);
            Assert.Equal(userId, validationResult.UserId);
            Assert.Equal(userType, validationResult.UserType);
        }

        [Theory]
        [InlineData("kent.boogaart@gmail.com", "Influencer")]
        [InlineData("someone@somewhere.com", "Business")]
        public void access_tokens_are_irreversible(
            string userId,
            string userType)
        {
            var accessToken = TokenManager.GenerateAccessToken(
                userId,
                userType);

            // Pretend to be a client without access to the TokenManager (or its secrets).
            var tokenHandler = new JwtSecurityTokenHandler
            {
                // Disable mapping default handler that maps short claim names to .NET's long claim names.
                InboundClaimTypeMap = new Dictionary<string, string>(),
            };
            var jwtToken = (JwtSecurityToken)tokenHandler.ReadToken(accessToken);

            Assert.NotNull(jwtToken);

            Assert.Null(jwtToken.Issuer);
            Assert.Null(jwtToken.Subject);
            Assert.Empty(jwtToken.Audiences);
            Assert.Empty(jwtToken.Claims);
        }
    }
}
