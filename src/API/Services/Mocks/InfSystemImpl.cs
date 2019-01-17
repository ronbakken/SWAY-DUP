using System.Threading.Tasks;
using Grpc.Core;
using static API.InfSystem;

namespace API.Services.Mocks
{
    class InfSystemImpl : InfSystemBase
    {
        public override Task<AliveMessage> PingServer(Empty request, ServerCallContext context)
        {
            return Task.FromResult(new AliveMessage());
        }
    }
}
