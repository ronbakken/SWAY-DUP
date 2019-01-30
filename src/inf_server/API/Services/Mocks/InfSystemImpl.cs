using System.Threading.Tasks;
using API.Interfaces;
using Grpc.Core;

namespace API.Services.Mocks
{
    class InfSystemImpl : InfSystem.InfSystemBase
    {
        public override Task<AliveMessage> PingServer(Empty request, ServerCallContext context)
        {
            ServiceEventSource.Current.Message("Ping received.");
            return Task.FromResult(new AliveMessage());
        }
    }
}
