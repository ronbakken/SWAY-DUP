using System.Threading.Tasks;
using API.Interfaces;
using Grpc.Core;
using static API.Interfaces.InfOffers;

namespace MockServer
{
    class InfOffersImpl : InfOffersBase
    {
        public override Task<GetOfferResponse> GetOffer(GetOfferRequest request, ServerCallContext context)
        {
            System.Console.WriteLine("InfOffersImpl.GetOffer called");

            return Task.FromResult(new GetOfferResponse {Offer = DatabaseMock.Instance().GetOffer(request.Id) });
        }

        public override Task<UpdateOfferResponse> UpdateOffer(UpdateOfferRequest request, ServerCallContext context)
        {
            System.Console.WriteLine("InfOffersImpl.UpdateOffer called");

            return Task.FromResult(new UpdateOfferResponse { Offer = DatabaseMock.Instance().UpsertOffer(request.Offer) });
        }
    }
}
