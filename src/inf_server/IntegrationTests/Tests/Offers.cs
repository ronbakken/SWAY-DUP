using System.Threading.Tasks;
using API.Interfaces;
using AutoFixture;
using Xunit;

namespace IntegrationTests.Tests
{
    public static class Offers
    {
        public static async Task<ExecutionContext> UpdateOffer(ExecutionContext context)
        {
            var logger = context.Logger;
            var client = new InfOffers.InfOffersClient(context.GetServerChannel());

            var generatedOffer = context.Fixture.Create<OfferDto>();
            generatedOffer.Id = "";

            logger.Debug("Updating offer to {@Offer}", generatedOffer);
            var updateOfferResponse = await client.UpdateOfferAsync(new UpdateOfferRequest { Offer = generatedOffer }, headers: context.GetAccessHeaders(UserType.Business));
            var savedOffer = updateOfferResponse.Offer;

            Assert.NotNull(savedOffer);

            logger.Debug("Requesting offer {OfferId} back from server", savedOffer.Id);
            var getOfferResponse = await client.GetOfferAsync(new GetOfferRequest { Id = savedOffer.Id }, headers: context.GetAccessHeaders(UserType.Business));
            var offerReceived = getOfferResponse.Offer;

            generatedOffer.Id = offerReceived.Id;
            generatedOffer.Revision = offerReceived.Revision;
            generatedOffer.Full.Created = offerReceived.Full.Created;
            generatedOffer.Full.ProposalStatus = offerReceived.Full.ProposalStatus;
            logger.Debug("Validating that offer sent {@OfferSent} is equivalent to offer received {@OfferReceived} (ignoring server-assigned fields)", generatedOffer, offerReceived);
            Assert.Equal(generatedOffer, offerReceived);

            return context;
        }
    }
}
