﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Grpc.Core;
using Grpc.Core.Interceptors;
using Serilog;
using Users.Interfaces;
using Utility.Tokens;

namespace API
{
    public sealed class AuthorizationInterceptor : Interceptor
    {
        public const string userIdKeyName = "userid";
        public const string userTypeKeyName = "usertype";
        private const string authorizationHeader = "authorization";
        private const string schema = "Bearer";

        private readonly ILogger logger;

        public AuthorizationInterceptor(ILogger logger)
        {
            this.logger = logger.ForContext<AuthorizationInterceptor>();
        }

        // What user types can invoke a given method. If a method does not appear in this list, it won't be callable by anyone.
        private static readonly Dictionary<string, UserTypes> userTypesForMethod = new Dictionary<string, UserTypes>
        {
            // InfAuth
            { "/api.InfAuth/SendLoginEmail", UserTypes.Anonymous },
            { "/api.InfAuth/CreateNewUser", UserTypes.Anonymous },
            { "/api.InfAuth/LoginWithLoginToken", UserTypes.Anonymous },
            { "/api.InfAuth/LoginWithRefreshToken", UserTypes.Anonymous },
            { "/api.InfAuth/GetAccessToken", UserTypes.Anonymous },
            { "/api.InfAuth/Logout", UserTypes.Anonymous },

            // InfBlobStorage
            { "/api.InfBlobStorage/GetUploadUrl", UserTypes.Influencer | UserTypes.Business },

            // InfConfig
            { "/api.InfConfig/GetAppConfig", UserTypes.Anonymous },
            { "/api.InfConfig/GetVersions", UserTypes.Anonymous },
            { "/api.InfConfig/GetWelcomeImages", UserTypes.Anonymous },

            // InfInvitationCodes
            { "/api.InfInvitationCodes/GenerateInvitationCode", UserTypes.Admin },
            { "/api.InfInvitationCodes/GetInvitationCodeStatus", UserTypes.Anonymous },

            // InfMapping
            { "/api.InfMapping/SearchOffers", UserTypes.Influencer | UserTypes.Business },

            // InfOffers
            { "/api.InfOffers/CreateOffer", UserTypes.Influencer | UserTypes.Business },

            // InfSystem
            { "/api.InfSystem/PingServer", UserTypes.Anonymous },

            // InfUsers
            { "/api.InfUsers/GetUser", UserTypes.Influencer | UserTypes.Business },
            { "/api.InfUsers/UpdateUser", UserTypes.Influencer | UserTypes.Business },
            { "/api.InfUsers/Search", UserTypes.Influencer | UserTypes.Business | UserTypes.Admin },
        };

        public override async Task<TResponse> ClientStreamingServerHandler<TRequest, TResponse>(IAsyncStreamReader<TRequest> requestStream, ServerCallContext context, ClientStreamingServerMethod<TRequest, TResponse> continuation)
        {
            this.logger.Verbose("ClientStreamingServerHandler");
            var newContext = Authorize(context);
            var result = await continuation(requestStream, newContext);
            return result;
        }

        public override async Task DuplexStreamingServerHandler<TRequest, TResponse>(IAsyncStreamReader<TRequest> requestStream, IServerStreamWriter<TResponse> responseStream, ServerCallContext context, DuplexStreamingServerMethod<TRequest, TResponse> continuation)
        {
            this.logger.Verbose("DuplexStreamingServerHandler");
            var newContext = Authorize(context);
            await continuation(requestStream, responseStream, newContext);
        }

        public override async Task ServerStreamingServerHandler<TRequest, TResponse>(TRequest request, IServerStreamWriter<TResponse> responseStream, ServerCallContext context, ServerStreamingServerMethod<TRequest, TResponse> continuation)
        {
            this.logger.Verbose("ServerStreamingServerHandler");
            var newContext = Authorize(context);
            await continuation(request, responseStream, newContext);
        }

        public override async Task<TResponse> UnaryServerHandler<TRequest, TResponse>(TRequest request, ServerCallContext context, UnaryServerMethod<TRequest, TResponse> continuation)
        {
            this.logger.Verbose("UnaryServerHandler");
            var newContext = Authorize(context);
            var result = await continuation(request, newContext);
            return result;
        }

        private ServerCallContext Authorize(ServerCallContext context)
        {
            var method = context.Method;

            try
            {
                this.logger.Debug("Authorizing method {Method}.", method);

                if (!userTypesForMethod.TryGetValue(method, out var allowedUserTypes))
                {
                    this.logger.Debug("Denied - no permitted user types defined for method {Method}", method);
                    throw new RpcException(new Status(StatusCode.PermissionDenied, $"RPC '{method}' has no permitted user types defined."));
                }

                if (allowedUserTypes.HasFlag(UserTypes.Anonymous))
                {
                    this.logger.Debug("Allowed - anonymous access permitted for method {Method}", method);
                    return context;
                }

                var headers = context.RequestHeaders;
                var authorizationHeaderEntry = headers
                    .SingleOrDefault(entry => entry.Key == authorizationHeader);

                if (authorizationHeaderEntry == null)
                {
                    this.logger.Debug("Denied - no Authorization header set");
                    throw new RpcException(new Status(StatusCode.Unauthenticated, "No Authorization header set."));
                }

                var prefix = schema + " ";

                if (!authorizationHeaderEntry.Value.StartsWith(prefix))
                {
                    this.logger.Debug("Denied - Authorization header {AuthorizationHeader} is not in expected format", authorizationHeaderEntry.Value);
                    throw new RpcException(new Status(StatusCode.Unauthenticated, $"Authorization header does not start with expected schema, '{schema}'."));
                }

                var token = authorizationHeaderEntry.Value.Substring(prefix.Length);
                var accessTokenValidationResult = TokenManager.ValidateAccessToken(token);

                if (!accessTokenValidationResult.IsValid)
                {
                    this.logger.Debug("Denied - access token {AccessToken} is invalid", token);
                    throw new RpcException(new Status(StatusCode.PermissionDenied, "Access token is invalid."));
                }

                var userType = Enum.Parse<UserType>(accessTokenValidationResult.UserType);

                if (!allowedUserTypes.Contains(userType))
                {
                    this.logger.Debug("Denied - method {Method} cannot be called by user type {UserType}", method, userType);
                    throw new RpcException(new Status(StatusCode.PermissionDenied, $"Method '{method}' cannot be called by user type '{userType}'."));
                }

                context.RequestHeaders.Add(new Metadata.Entry(userIdKeyName, accessTokenValidationResult.UserId));
                context.RequestHeaders.Add(new Metadata.Entry(userTypeKeyName, accessTokenValidationResult.UserType));

                this.logger.Debug("Allowed - all checks passed");

                return context;
            }
            catch (Exception ex)
            {
                this.logger.Fatal(ex, "Authorization interception failed for method {Method}", method);
                throw;
            }
        }
    }
}
