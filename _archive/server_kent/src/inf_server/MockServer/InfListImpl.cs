using System.Threading;
using System.Threading.Tasks;
using API.Interfaces;
using Grpc.Core;
using static API.Interfaces.InfList;

namespace MockServer
{
    class InfListImpl : InfListBase
    {
        CancellationToken CancelToken = new CancellationToken();
        public override async Task List(IAsyncStreamReader<ListRequest> requestStream, IServerStreamWriter<ListResponse> responseStream, ServerCallContext context)
        {
            System.Console.WriteLine("InfListImpl.List called");

            while (await requestStream.MoveNext(CancelToken))
            {
                System.Console.WriteLine("InfListImpl.List new filter sent");

                var request = requestStream.Current;

                var response = new ListResponse();
                response.Items.AddRange(DatabaseMock.Instance().GetOffersAsItems());
                await responseStream.WriteAsync(response);
                
            }

        }
    }
}
