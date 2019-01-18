using System.Threading.Tasks;
using API.Interfaces;
using Grpc.Core;
using static API.Interfaces.InfApi;

namespace API.Services.Mocks
{
    class InfApiImpl : InfApiBase
    {
        public override Task<HelloReply> SayHello(HelloRequest request, ServerCallContext context)
        {
            return Task.FromResult(new HelloReply { Message = "Hello " + request.Name });
        }

        public override Task<HelloReply> SayHelloAgain(HelloRequest request, ServerCallContext context)
        {
            return Task.FromResult(new HelloReply { Message = "Hello " + request.Name });
        }
    }
}
