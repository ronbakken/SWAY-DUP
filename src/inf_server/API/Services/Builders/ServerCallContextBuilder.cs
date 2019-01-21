using System;
using System.Threading;
using System.Threading.Tasks;
using Genesis.TestUtil;
using Grpc.Core;
using Grpc.Core.Testing;

namespace API.Services.Builders
{
    public sealed class ServerCallContextBuilder : IBuilder
    {
        private string method;
        private string host;
        private DateTime deadline;
        private Metadata requestHeaders;
        private CancellationToken cancellationToken;
        private string peer;
        private AuthContext authContext;
        private ContextPropagationToken contextPropagationToken;
        private Func<Metadata, Task> writeHeadersFunc;
        private Func<WriteOptions> writeOptionsGetter;
        private Action<WriteOptions> writeOptionsSetter;

        public ServerCallContextBuilder()
        {
        }

        public ServerCallContextBuilder WithMethod(string method) =>
            this.With(ref this.method, method);

        public ServerCallContextBuilder WithHost(string host) =>
            this.With(ref this.host, host);

        public ServerCallContextBuilder WithDeadline(DateTime deadline) =>
            this.With(ref this.deadline, deadline);

        public ServerCallContextBuilder WithRequestHeaders(Metadata requestHeaders) =>
            this.With(ref this.requestHeaders, requestHeaders);

        public ServerCallContextBuilder WithCancellationToken(CancellationToken cancellationToken) =>
            this.With(ref this.cancellationToken, cancellationToken);

        public ServerCallContextBuilder WithPeer(string peer) =>
            this.With(ref this.peer, peer);

        public ServerCallContextBuilder WithAuthContext(AuthContext authContext) =>
            this.With(ref this.authContext, authContext);

        public ServerCallContextBuilder WithContextPropagationToken(ContextPropagationToken contextPropagationToken) =>
            this.With(ref this.contextPropagationToken, contextPropagationToken);

        public ServerCallContextBuilder WithWriteHeadersFunc(Func<Metadata, Task> writeHeadersFunc) =>
            this.With(ref this.writeHeadersFunc, writeHeadersFunc);

        public ServerCallContextBuilder WithWriteOptionsGetter(Func<WriteOptions> writeOptionsGetter) =>
            this.With(ref this.writeOptionsGetter, writeOptionsGetter);

        public ServerCallContextBuilder WithWriteOptionsSetter(Action<WriteOptions> writeOptionsSetter) =>
            this.With(ref this.writeOptionsSetter, writeOptionsSetter);

        public ServerCallContext Build() =>
            TestServerCallContext.Create(
                this.method,
                this.host,
                this.deadline,
                this.requestHeaders,
                this.cancellationToken,
                this.peer,
                this.authContext,
                this.contextPropagationToken,
                this.writeHeadersFunc,
                this.writeOptionsGetter,
                this.writeOptionsSetter);

        public static implicit operator ServerCallContext(ServerCallContextBuilder builder) =>
            builder.Build();
    }
}
