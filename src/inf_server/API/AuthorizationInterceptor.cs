using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Grpc.Core;
using Grpc.Core.Interceptors;
using Users.Interfaces;
using Utility;

namespace API
{
    public sealed class AuthorizationInterceptor : Interceptor
    {
        public const string userIdKeyName = "userid";
        public const string userTypeKeyName = "usertype";
        private const string authorizationHeader = "authorization";
        private const string schema = "Bearer";

        // What user types can invoke a given method. If a method does not appear in this list, it won't be callable by anyone.
        private static readonly Dictionary<string, UserTypes> userTypesForMethod = new Dictionary<string, UserTypes>
        {
            // InfAuth
            { "/api.InfAuth/SendLoginEmail", UserTypes.Anonymous },
            { "/api.InfAuth/CreateNewUser", UserTypes.Anonymous },
            { "/api.InfAuth/LoginWithLoginToken", UserTypes.Anonymous },
            { "/api.InfAuth/LoginWithRefreshToken", UserTypes.Anonymous },
            { "/api.InfAuth/GetAccessToken", UserTypes.Anonymous },
            { "/api.InfAuth/GetUser", UserTypes.Influencer | UserTypes.Business },
            { "/api.InfAuth/UpdateUser", UserTypes.Influencer | UserTypes.Business },
            { "/api.InfAuth/Logout", UserTypes.Anonymous },

            // InfBlobStorage
            { "/api.InfBlobStorage/GetUploadUrl", UserTypes.Influencer | UserTypes.Business },

            // InfConfig
            { "/api.InfConfig/GetAppConfig", UserTypes.Anonymous },
            { "/api.InfConfig/GetVersions", UserTypes.Anonymous },
            { "/api.InfConfig/GetWelcomeImages", UserTypes.Anonymous },

            // InfInvitationCodes
            { "/api.InfInvitationCodes/GenerateInvitationCode", UserTypes.Admin },
            { "/api.InfInvitationCodes/GetInvitationCodeStatus", UserTypes.Admin },

            // InfSystem
            { "/api.InfSystem/PingServer", UserTypes.Anonymous },
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
                throw new RpcException(new Status(StatusCode.PermissionDenied, $"RPC '{method}' has no permitted user types defined."));
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
                throw new RpcException(new Status(StatusCode.Unauthenticated, "No Authorization header set."));
            }

            var prefix = schema + " ";

            if (!authorizationHeaderEntry.Value.StartsWith(prefix))
            {
                throw new RpcException(new Status(StatusCode.Unauthenticated, $"Authorization header does not start with expected schema, '{schema}'."));
            }

            var token = authorizationHeaderEntry.Value.Substring(prefix.Length);
            var accessTokenValidationResult = TokenManager.ValidateAccessToken(token);
            var userType = Enum.Parse<UserType>(accessTokenValidationResult.UserType);

            if (!allowedUserTypes.Contains(userType))
            {
                throw new RpcException(new Status(StatusCode.PermissionDenied, $"Method '{method}' cannot be called by user type '{userType}'."));
            }

            context.RequestHeaders.Add(new Metadata.Entry(userIdKeyName, accessTokenValidationResult.UserId));
            context.RequestHeaders.Add(new Metadata.Entry(userTypeKeyName, accessTokenValidationResult.UserType));

            return context;
        }
    }
}
