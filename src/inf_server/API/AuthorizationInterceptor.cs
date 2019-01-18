﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Grpc.Core;
using Grpc.Core.Interceptors;
using User.Interfaces;
using Utility;

namespace API
{
    public sealed class AuthorizationInterceptor : Interceptor
    {
        private const string authorizationHeader = "Authorization";
        private const string schema = "Bearer";

        // What user types can invoke a given method. If a method does not appear in this list, it won't be callable.
        private static readonly Dictionary<string, UserTypes> userTypesForMethod = new Dictionary<string, UserTypes>
        {
            // InfAuth
            { "/api.InfAuth/SendLoginEmail", UserTypes.Anonymous },
            { "/api.InfAuth/ValidateInvitationCode", UserTypes.Anonymous },
            { "/api.InfAuth/CreateNewUser", UserTypes.Anonymous },
            { "/api.InfAuth/RequestRefreshToken", UserTypes.Anonymous },
            { "/api.InfAuth/Login", UserTypes.Anonymous },
            { "/api.InfAuth/GetCurrentUser", UserTypes.Influencer | UserTypes.Business },
            { "/api.InfAuth/UpdateUser", UserTypes.Influencer | UserTypes.Business },
            { "/api.InfAuth/GetSocialMediaAccountsForUser", UserTypes.Influencer },
        };

        public override async Task<TResponse> ClientStreamingServerHandler<TRequest, TResponse>(IAsyncStreamReader<TRequest> requestStream, ServerCallContext context, ClientStreamingServerMethod<TRequest, TResponse> continuation)
        {
            var newContext = Authorize(context);
            var result = await continuation(requestStream, newContext);
            return result;
        }

        public override async Task DuplexStreamingServerHandler<TRequest, TResponse>(IAsyncStreamReader<TRequest> requestStream, IServerStreamWriter<TResponse> responseStream, ServerCallContext context, DuplexStreamingServerMethod<TRequest, TResponse> continuation)
        {
            var newContext = Authorize(context);
            await continuation(requestStream, responseStream, newContext);
        }

        public override async Task ServerStreamingServerHandler<TRequest, TResponse>(TRequest request, IServerStreamWriter<TResponse> responseStream, ServerCallContext context, ServerStreamingServerMethod<TRequest, TResponse> continuation)
        {
            var newContext = Authorize(context);
            await continuation(request, responseStream, newContext);
        }

        public override async Task<TResponse> UnaryServerHandler<TRequest, TResponse>(TRequest request, ServerCallContext context, UnaryServerMethod<TRequest, TResponse> continuation)
        {
            var newContext = Authorize(context);
            var result = await continuation(request, newContext);
            return result;
        }

        private static ServerCallContext Authorize(ServerCallContext context)
        {
            var method = context.Method;

            if (!userTypesForMethod.TryGetValue(method, out var allowedUserTypes))
            {
                throw new InvalidOperationException($"Method '{method}' has no permitted user types defined.");
            }

            if (allowedUserTypes.HasFlag(UserTypes.Anonymous))
            {
                return context;
            }

            var headers = context.RequestHeaders;
            var authorizationHeaderEntry = headers
                .SingleOrDefault(entry => entry.Key == authorizationHeader);

            if (authorizationHeaderEntry == null)
            {
                throw new InvalidOperationException($"No authorization header set.");
            }

            var prefix = schema + " ";

            if (!authorizationHeaderEntry.Value.StartsWith(prefix))
            {
                throw new InvalidOperationException($"Authorization header does not start with expected schema, '{schema}'.");
            }

            var token = authorizationHeaderEntry.Value.Substring(prefix.Length);
            var authorizationTokenValidationResult = TokenManager.ValidateAuthorizationToken(token);
            var userType = Enum.Parse<UserType>(authorizationTokenValidationResult.UserType);

            if (!allowedUserTypes.Contains(userType))
            {
                throw new InvalidOperationException($"Method '{method}' cannot be called by user type '{userType}'.");
            }

            context.RequestHeaders.Add(new Metadata.Entry("userId", authorizationTokenValidationResult.UserId));
            context.RequestHeaders.Add(new Metadata.Entry("userType", authorizationTokenValidationResult.UserType));

            return context;
        }
    }

    [Flags]
    internal enum UserTypes
    {
        None = 0,
        Anonymous = 1,
        Influencer = 2,
        Business = 4,
        Support = 8,
        Admin = 16,
    }

    internal static class UserTypesExtensions
    {
        public static bool Contains(this UserTypes @this, UserType value)
        {
            switch (value)
            {
                case UserType.Admin:
                    return @this.HasFlag(UserTypes.Admin);
                case UserType.Business:
                    return @this.HasFlag(UserTypes.Business);
                case UserType.Influencer:
                    return @this.HasFlag(UserTypes.Influencer);
                case UserType.Support:
                    return @this.HasFlag(UserTypes.Support);
                case UserType.Unknown:
                    return false;
                default:
                    throw new NotSupportedException();
            }
        }
    }
}
