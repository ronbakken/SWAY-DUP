using System;
using System.Linq;
using System.Threading.Tasks;
using Grpc.Core;
using Grpc.Core.Interceptors;
using Microsoft.ServiceFabric.Actors;
using Microsoft.ServiceFabric.Actors.Client;
using User.Interfaces;
using Utility;

namespace API
{
    public class FooInterceptor : Interceptor
    {
        public override AsyncClientStreamingCall<TRequest, TResponse> AsyncClientStreamingCall<TRequest, TResponse>(ClientInterceptorContext<TRequest, TResponse> context, AsyncClientStreamingCallContinuation<TRequest, TResponse> continuation)
        {
            return base.AsyncClientStreamingCall(context, continuation);
        }

        public override AsyncDuplexStreamingCall<TRequest, TResponse> AsyncDuplexStreamingCall<TRequest, TResponse>(ClientInterceptorContext<TRequest, TResponse> context, AsyncDuplexStreamingCallContinuation<TRequest, TResponse> continuation)
        {
            return base.AsyncDuplexStreamingCall(context, continuation);
        }

        public override AsyncServerStreamingCall<TResponse> AsyncServerStreamingCall<TRequest, TResponse>(TRequest request, ClientInterceptorContext<TRequest, TResponse> context, AsyncServerStreamingCallContinuation<TRequest, TResponse> continuation)
        {
            return base.AsyncServerStreamingCall(request, context, continuation);
        }

        public override AsyncUnaryCall<TResponse> AsyncUnaryCall<TRequest, TResponse>(TRequest request, ClientInterceptorContext<TRequest, TResponse> context, AsyncUnaryCallContinuation<TRequest, TResponse> continuation)
        {
            return base.AsyncUnaryCall(request, context, continuation);
        }

        public override TResponse BlockingUnaryCall<TRequest, TResponse>(TRequest request, ClientInterceptorContext<TRequest, TResponse> context, BlockingUnaryCallContinuation<TRequest, TResponse> continuation)
        {
            return base.BlockingUnaryCall(request, context, continuation);
        }

        public override Task<TResponse> ClientStreamingServerHandler<TRequest, TResponse>(IAsyncStreamReader<TRequest> requestStream, ServerCallContext context, ClientStreamingServerMethod<TRequest, TResponse> continuation)
        {
            return base.ClientStreamingServerHandler(requestStream, context, continuation);
        }

        public override Task DuplexStreamingServerHandler<TRequest, TResponse>(IAsyncStreamReader<TRequest> requestStream, IServerStreamWriter<TResponse> responseStream, ServerCallContext context, DuplexStreamingServerMethod<TRequest, TResponse> continuation)
        {
            return base.DuplexStreamingServerHandler(requestStream, responseStream, context, continuation);
        }

        public override Task ServerStreamingServerHandler<TRequest, TResponse>(TRequest request, IServerStreamWriter<TResponse> responseStream, ServerCallContext context, ServerStreamingServerMethod<TRequest, TResponse> continuation)
        {
            return base.ServerStreamingServerHandler(request, responseStream, context, continuation);
        }

        public override Task<TResponse> UnaryServerHandler<TRequest, TResponse>(TRequest request, ServerCallContext context, UnaryServerMethod<TRequest, TResponse> continuation)
        {
            return base.UnaryServerHandler(request, context, continuation);
        }
    }

    public static class AuthorizationInterception
    {
        private const string authorizationHeader = "Authorization";
        private const string schema = "Bearer";

        public static AsyncAuthInterceptor Create()
        {
            return new AsyncAuthInterceptor(
                async (context, metadata) =>
                {
                    await Authorize(metadata);
                });
        }

        private static async Task Authorize(Metadata metadata)
        {
            // TODO: allow methods that don't even require a session (CreateSession)

            //var authorizationHeaderEntry = metadata
            //    .SingleOrDefault(entry => entry.Key == authorizationHeader);

            //if (authorizationHeaderEntry == null)
            //{
            //    throw new InvalidOperationException($"No authorization header set.");
            //}

            //var prefix = schema + " ";

            //if (!authorizationHeaderEntry.Value.StartsWith(prefix))
            //{
            //    throw new InvalidOperationException($"Authorization header does not start with expected schema, '{schema}'.");
            //}

            //var token = authorizationHeaderEntry.Value.Substring(prefix.Length);
            //var sessionId = TokenManager.GetSessionId(token);

            // TODO: allow methods that require a session, but don't require a logged in user

            //var session = GetSessionActor(sessionId);
            //var userId = await session.GetAssociatedUserId();

            //if (userId == null)
            //{
            //    throw new InvalidOperationException("No user is associated with session.");
            //}

            //var user = GetUserActor(userId);
            //var isCreated = await user.IsCreated();

            //if (!isCreated)
            //{
            //    throw new InvalidOperationException($"User with ID '{userId}' is not yet created.");
            //}

            //var userData = await user.GetData();
            //var userType = userData.Type;

            // TODO: determine whether the user can perform the method call based on their type
        }

        private static IUser GetUserActor(string userId) =>
            ActorProxy.Create<IUser>(new ActorId(userId), new Uri("fabric:/server/UserActorService"));
    }
}
