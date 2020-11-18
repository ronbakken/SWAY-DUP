using System.Threading.Tasks;
using API.Interfaces;
using Grpc.Core;

namespace MockServer
{
    class InfSystemImpl : InfSystem.InfSystemBase
    {
        public override Task<AliveMessage> PingServer(Empty request, ServerCallContext context)
        {
            return Task.FromResult(new AliveMessage());
        }
    }
}
