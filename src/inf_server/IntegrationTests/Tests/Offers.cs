using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using API.Interfaces;
using AutoFixture;
using Grpc.Core;
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
            logger.Debug("Validating that offer sent {@OfferSent} is equivalent to offer received {@OfferReceived} (ignoring server-assigned fields)", generatedOffer, offerReceived);
            Assert.Equal(generatedOffer, offerReceived);

            return context;
        }

        public static async Task<ExecutionContext> ListOffers(ExecutionContext context)
        {
            var logger = context.Logger;
            var client = new InfList.InfListClient(context.GetServerChannel());

            var call = client.List(headers: context.GetAccessHeaders(UserType.Influencer));

            using (call)
            {
                var filter = new ItemFilterDto
                {
                    OfferFilter = new ItemFilterDto.Types.OfferFilterDto
                    {
                    },
                };

                await call.RequestStream.WriteAsync(
                    new ListRequest
                    {
                        State = ListRequest.Types.State.Resumed,
                        Filter = filter
                    });

                var cts = new CancellationTokenSource();
                cts.CancelAfter(TimeSpan.FromSeconds(10));
                var items = new List<ItemDto>();

                try
                {
                    while (await call.ResponseStream.MoveNext(cts.Token))
                    {
                        items.AddRange(call.ResponseStream.Current.Items);

                        if (items.Count > 0)
                        {
                            break;
                        }
                    }
                }
                catch (RpcException ex) when (ex.StatusCode == StatusCode.Cancelled)
                {
                }

                Assert.NotEmpty(items);

                foreach (var item in items)
                {
                    Assert.Equal(ItemDto.DataOneofCase.Offer, item.DataCase);
                    Assert.Equal(OfferDto.DataOneofCase.List, item.Offer.DataCase);
                }
            }

            return context;
        }

        public static async Task<ExecutionContext> ListenForOffers(ExecutionContext context)
        {
            var logger = context.Logger;
            var client = new InfListen.InfListenClient(context.GetServerChannel());

            var call = client.Listen(headers: context.GetAccessHeaders(UserType.Influencer));

            using (call)
            {
                var filter = new ItemFilterDto
                {
                    OfferFilter = new ItemFilterDto.Types.OfferFilterDto
                    {
                    },
                };

                await call.RequestStream.WriteAsync(
                    new ListenRequest
                    {
                        Action = ListenRequest.Types.Action.Register,
                        Filter = filter,
                    });

                // Allow time for the listen request to "stick" (they are buffered)
                await Task.Delay(TimeSpan.FromMilliseconds(500));

                var generatedOffer1 = context.Fixture.Create<OfferDto>();
                var generatedOffer2 = context.Fixture.Create<OfferDto>();
                var generatedOffer3 = context.Fixture.Create<OfferDto>();

                // Kick off a task to add several offers
                Task
                    .Run(
                        async () =>
                        {
                            var offersClient = new InfOffers.InfOffersClient(context.GetServerChannel());

                            logger.Debug("Adding offers {@Offer1}, {@Offer2}, and {@Offer3}", generatedOffer1, generatedOffer2, generatedOffer3);

                            await Task.WhenAll(
                                offersClient.UpdateOfferAsync(new UpdateOfferRequest { Offer = generatedOffer1 }, headers: context.GetAccessHeaders(UserType.Business)).ResponseAsync,
                                offersClient.UpdateOfferAsync(new UpdateOfferRequest { Offer = generatedOffer2 }, headers: context.GetAccessHeaders(UserType.Business)).ResponseAsync,
                                offersClient.UpdateOfferAsync(new UpdateOfferRequest { Offer = generatedOffer3 }, headers: context.GetAccessHeaders(UserType.Business)).ResponseAsync);
                        })
                    .Ignore();

                var cts = new CancellationTokenSource();
                cts.CancelAfter(TimeSpan.FromSeconds(5));
                var items = new List<ItemDto>();

                try
                {
                    while (await call.ResponseStream.MoveNext(cts.Token))
                    {
                        items.AddRange(call.ResponseStream.Current.Items);
                    }
                }
                catch (RpcException ex) when (ex.StatusCode == StatusCode.Cancelled)
                {
                }

                Assert.Equal(3, items.Count);
                Assert.All(items, item => Assert.Equal(ItemDto.DataOneofCase.Offer, item.DataCase));

                var itemIds = items
                    .Select(item => item.Offer.Id)
                    .ToList();

                Assert.Contains(generatedOffer1.Id, itemIds);
                Assert.Contains(generatedOffer2.Id, itemIds);
                Assert.Contains(generatedOffer3.Id, itemIds);
            }

            return context;
        }
    }
}
