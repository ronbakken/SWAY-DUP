using System;
using System.Linq;
using Grpc.Core;
using User.Interfaces;

namespace API
{
    public static class AuthorizationExtensions
    {
        public static string GetAuthenticatedUserId(this ServerCallContext @this)
        {
            var userId = @this
                .RequestHeaders
                .FirstOrDefault(x => x.Key == AuthorizationInterceptor.userIdKeyName)
                ?.Value;

            if (userId == null)
            {
                throw new InvalidOperationException("No user authenticated.");
            }

            return userId;
        }

        public static UserType GetAuthenticatedUserType(this ServerCallContext @this)
        {
            var userType = @this
                .RequestHeaders
                .FirstOrDefault(x => x.Key == AuthorizationInterceptor.userTypeKeyName)
                ?.Value;

            if (userType == null)
            {
                throw new InvalidOperationException("No user authenticated.");
            }

            return Enum.Parse<UserType>(userType);
        }
    }
}
