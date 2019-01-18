using System.Threading.Tasks;
using API.Interfaces;
using Grpc.Core;
using static API.Interfaces.InfSystem;

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
