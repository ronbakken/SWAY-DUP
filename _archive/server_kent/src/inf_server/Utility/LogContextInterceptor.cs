using System.Linq;
using System.Reactive.Disposables;
using System.Threading.Tasks;
using Grpc.Core;
using Grpc.Core.Interceptors;

namespace Utility
{
    // gRPC call interceptor that injects and applies headers related to maintaining log context across RPC boundaries.
    public sealed class LogContextInterceptor : Interceptor
    {
        public static readonly LogContextInterceptor Instance = new LogContextInterceptor();

        private const string correlationIdHeaderKey = "correlation_id";
        private const string apiHeaderKey = "api";

        private LogContextInterceptor()
        {
        }

        public override async Task<TResponse> UnaryServerHandler<TRequest, TResponse>(TRequest request, ServerCallContext context, UnaryServerMethod<TRequest, TResponse> continuation)
        {
            var correlationIdDisposable = Disposable.Empty;
            var apiDisposable = Disposable.Empty;

            var correlationIdHeader = context
                .RequestHeaders
                .FirstOrDefault(header => header.Key == correlationIdHeaderKey);
            var apiHeader = context
                .RequestHeaders
                .FirstOrDefault(header => header.Key == apiHeaderKey);

            if (correlationIdHeader != null)
            {
                correlationIdDisposable = LoggingContextCorrelator.BeginOrReplaceCorrelationScope(APISanitizer.CorrelationIdKey, correlationIdHeader.Value);
            }

            if (apiHeader != null)
            {
                apiDisposable = LoggingContextCorrelator.BeginOrReplaceCorrelationScope(APISanitizer.ApiKey, apiHeader.Value);
            }

            using (correlationIdDisposable)
            using (apiDisposable)
            {
                return await base.UnaryServerHandler(request, context, continuation);
            }
        }

        public override AsyncUnaryCall<TResponse> AsyncUnaryCall<TRequest, TResponse>(
            TRequest request,
            ClientInterceptorContext<TRequest, TResponse> context,
            AsyncUnaryCallContinuation<TRequest, TResponse> continuation)
        {
            var headers = context.Options.Headers ?? new Metadata();

            if (LoggingContextCorrelator.TryGetValue(APISanitizer.CorrelationIdKey, out var existingCorrelationId) && existingCorrelationId != null)
            {
                headers.Add(correlationIdHeaderKey, existingCorrelationId.ToString());
            }

            if (LoggingContextCorrelator.TryGetValue(APISanitizer.ApiKey, out var existingApi) && existingApi != null)
            {
                headers.Add(apiHeaderKey, existingApi.ToString());
            }

            var callOptions = context.Options.WithHeaders(headers);
            context = new ClientInterceptorContext<TRequest, TResponse>(context.Method, context.Host, callOptions);

            return base.AsyncUnaryCall(request, context, continuation);
        }
    }
}
