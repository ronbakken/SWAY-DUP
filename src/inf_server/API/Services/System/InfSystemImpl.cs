using System.Threading.Tasks;
using API.Interfaces;
using Grpc.Core;
using Serilog;

namespace API.Services.System
{
    public sealed class InfSystemImpl : InfSystem.InfSystemBase
    {
        private readonly ILogger logger;

        public InfSystemImpl(ILogger logger)
        {
            this.logger = logger.ForContext<InfSystemImpl>();
        }

        public override Task<AliveMessage> PingServer(Empty request, ServerCallContext context) =>
            APISanitizer.Sanitize(
                this.logger,
                (logger) => Task.FromResult(AliveMessage.Instance));
    }
}
