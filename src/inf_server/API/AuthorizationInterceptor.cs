using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Grpc.Core;
using Grpc.Core.Interceptors;
using Serilog;
using Serilog.Events;
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
        private static readonly Dictionary<string, AuthenticatedUserTypes> userTypesForMethod = new Dictionary<string, AuthenticatedUserTypes>
        {
            // InfAuth
            { "/api.InfAuth/SendLoginEmail", AuthenticatedUserTypes.Anonymous },
            { "/api.InfAuth/ActivateUser", AuthenticatedUserTypes.Influencer | AuthenticatedUserTypes.Business },
            { "/api.InfAuth/LoginWithLoginToken", AuthenticatedUserTypes.Anonymous },
            { "/api.InfAuth/LoginWithRefreshToken", AuthenticatedUserTypes.Anonymous },
            { "/api.InfAuth/GetAccessToken", AuthenticatedUserTypes.Anonymous },
            { "/api.InfAuth/Logout", AuthenticatedUserTypes.Anonymous },

            // InfBlobStorage
            { "/api.InfBlobStorage/GetUploadUrl", AuthenticatedUserTypes.Influencer | AuthenticatedUserTypes.Business },

            // InfConfig
            { "/api.InfConfig/GetAppConfig", AuthenticatedUserTypes.Anonymous },
            { "/api.InfConfig/GetVersions", AuthenticatedUserTypes.Anonymous },
            { "/api.InfConfig/GetWelcomeImages", AuthenticatedUserTypes.Anonymous },

            // InfInvitationCodes
            { "/api.InfInvitationCodes/GenerateInvitationCode", AuthenticatedUserTypes.Admin },
            { "/api.InfInvitationCodes/GetInvitationCodeStatus", AuthenticatedUserTypes.Anonymous },

            // InfList
            { "/api.InfList/List", AuthenticatedUserTypes.Influencer | AuthenticatedUserTypes.Business },

            // InfListen
            { "/api.InfListen/Listen", AuthenticatedUserTypes.Influencer | AuthenticatedUserTypes.Business },

            // InfMessaging
            { "/api.InfMessaging/Notify", AuthenticatedUserTypes.Anonymous },

            // InfOffers
            { "/api.InfOffers/UpdateOffer", AuthenticatedUserTypes.Influencer | AuthenticatedUserTypes.Business },
            { "/api.InfOffers/GetOffer", AuthenticatedUserTypes.Influencer | AuthenticatedUserTypes.Business },
            { "/api.InfOffers/ListOffers", AuthenticatedUserTypes.Influencer | AuthenticatedUserTypes.Business },

            // InfSystem
            { "/api.InfSystem/PingServer", AuthenticatedUserTypes.Anonymous },

            // InfUsers
            { "/api.InfUsers/GetUser", AuthenticatedUserTypes.Influencer | AuthenticatedUserTypes.Business },
            { "/api.InfUsers/UpdateUser", AuthenticatedUserTypes.Influencer | AuthenticatedUserTypes.Business },
            { "/api.InfUsers/Search", AuthenticatedUserTypes.Influencer | AuthenticatedUserTypes.Business | AuthenticatedUserTypes.Admin },
        };

        private static readonly Dictionary<string, LogEventLevel> logEventLevelOverrides = new Dictionary<string, LogEventLevel>
        {
            { "/api.InfSystem/PingServer", LogEventLevel.Verbose },
        };

        public override async Task<TResponse> ClientStreamingServerHandler<TRequest, TResponse>(IAsyncStreamReader<TRequest> requestStream, ServerCallContext context, ClientStreamingServerMethod<TRequest, TResponse> continuation)
        {
            this.logger.Verbose("ClientStreamingServerHandler");
            var newContext = Authorize(context);
            var result = await continuation(requestStream, newContext).ContinueOnAnyContext();
            return result;
        }

        public override async Task DuplexStreamingServerHandler<TRequest, TResponse>(IAsyncStreamReader<TRequest> requestStream, IServerStreamWriter<TResponse> responseStream, ServerCallContext context, DuplexStreamingServerMethod<TRequest, TResponse> continuation)
        {
            this.logger.Verbose("DuplexStreamingServerHandler");
            var newContext = Authorize(context);
            await continuation(requestStream, responseStream, newContext).ContinueOnAnyContext();
        }

        public override async Task ServerStreamingServerHandler<TRequest, TResponse>(TRequest request, IServerStreamWriter<TResponse> responseStream, ServerCallContext context, ServerStreamingServerMethod<TRequest, TResponse> continuation)
        {
            this.logger.Verbose("ServerStreamingServerHandler");
            var newContext = Authorize(context);
            await continuation(request, responseStream, newContext).ContinueOnAnyContext();
        }

        public override async Task<TResponse> UnaryServerHandler<TRequest, TResponse>(TRequest request, ServerCallContext context, UnaryServerMethod<TRequest, TResponse> continuation)
        {
            this.logger.Verbose("UnaryServerHandler");
            var newContext = Authorize(context);
            var result = await continuation(request, newContext).ContinueOnAnyContext();
            return result;
        }

        private ServerCallContext Authorize(ServerCallContext context)
        {
            var method = context.Method;

            // Allow overriding the log level for "noisy" APIs like pinging the server.
            if (!logEventLevelOverrides.TryGetValue(method, out var logEventLevel))
            {
                logEventLevel = LogEventLevel.Debug;
            }

            try
            {
                this.logger.Write(logEventLevel, "Authorizing method {Method}.", method);

                if (!userTypesForMethod.TryGetValue(method, out var allowedUserTypes))
                {
                    this.logger.Write(logEventLevel, "Denied - no permitted user types defined for method {Method}", method);
                    throw new RpcException(new Status(StatusCode.PermissionDenied, $"RPC '{method}' has no permitted user types defined."));
                }

                if (allowedUserTypes == AuthenticatedUserTypes.None)
                {
                    this.logger.Write(logEventLevel, "Denied - method {Method} has been explicitly denied access for all users", method);
                    throw new RpcException(new Status(StatusCode.PermissionDenied, $"RPC '{method}' is explicitly denied access for all users."));
                }

                if (allowedUserTypes.HasFlag(AuthenticatedUserTypes.Anonymous))
                {
                    this.logger.Write(logEventLevel, "Allowed - anonymous access permitted for method {Method}", method);
                    return context;
                }

                var headers = context.RequestHeaders;
                var authorizationHeaderEntry = headers
                    .SingleOrDefault(entry => entry.Key == authorizationHeader);

                if (authorizationHeaderEntry == null)
                {
                    this.logger.Write(logEventLevel, "Denied - no Authorization header set");
                    throw new RpcException(new Status(StatusCode.Unauthenticated, "No Authorization header set."));
                }

                var prefix = schema + " ";

                if (!authorizationHeaderEntry.Value.StartsWith(prefix))
                {
                    this.logger.Write(logEventLevel, "Denied - Authorization header {AuthorizationHeader} is not in expected format", authorizationHeaderEntry.Value);
                    throw new RpcException(new Status(StatusCode.Unauthenticated, $"Authorization header does not start with expected schema, '{schema}'."));
                }

                var token = authorizationHeaderEntry.Value.Substring(prefix.Length);
                var accessTokenValidationResult = TokenManager.ValidateAccessToken(token);

                if (!accessTokenValidationResult.IsValid)
                {
                    this.logger.Write(logEventLevel, "Denied - access token {AccessToken} is invalid", token);
                    throw new RpcException(new Status(StatusCode.PermissionDenied, "Access token is invalid."));
                }

                var userType = Enum.Parse<AuthenticatedUserTypes>(accessTokenValidationResult.UserType);

                if (!allowedUserTypes.HasFlag(userType))
                {
                    this.logger.Write(logEventLevel, "Denied - method {Method} cannot be called by user type {UserType}", method, userType);
                    throw new RpcException(new Status(StatusCode.PermissionDenied, $"Method '{method}' cannot be called by user type '{userType}'."));
                }

                context.RequestHeaders.Add(new Metadata.Entry(userIdKeyName, accessTokenValidationResult.UserId));
                context.RequestHeaders.Add(new Metadata.Entry(userTypeKeyName, accessTokenValidationResult.UserType));

                this.logger.Write(logEventLevel, "Allowed - all checks passed");

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
