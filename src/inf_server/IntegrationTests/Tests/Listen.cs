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
    public static class Listen
    {
        public static async Task<ExecutionContext> ListenForSingleUser(ExecutionContext context)
        {
            var logger = context.Logger;
            var client = new InfListen.InfListenClient(context.GetServerChannel());

            var call = client.Listen(headers: context.GetAccessHeaders(UserType.Influencer));
            var userIdToListenTo = context.GetUserId(UserType.Influencer);

            using (call)
            {
                await call.RequestStream.WriteAsync(
                    new ListenRequest
                    {
                        Action = ListenRequest.Types.Action.Register,
                        SingleItemFilter = new SingleItemFilterDto
                        {
                            Type = SingleItemFilterDto.Types.Type.User,
                            Id = userIdToListenTo
                        }
                    });

                // Allow time for the listen request to "stick" (they are buffered)
                await Task.Delay(TimeSpan.FromMilliseconds(500));

                // Kick off a task to update the relevant user
                Task
                    .Run(
                        async () =>
                        {
                            var usersClient = new InfUsers.InfUsersClient(context.GetServerChannel());
                            var getUserResponse = await usersClient.GetUserAsync(new GetUserRequest { UserId = userIdToListenTo }, headers: context.GetAccessHeaders(UserType.Influencer));

                            var modifiedUser = getUserResponse.User;
                            modifiedUser.Full.Description += "Foo";

                            await usersClient.UpdateUserAsync(new UpdateUserRequest { User = modifiedUser }, headers: context.GetAccessHeaders(UserType.Influencer));
                        })
                    .Ignore();

                var cts = new CancellationTokenSource();
                cts.CancelAfter(TimeSpan.FromSeconds(1));
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

                Assert.Single(items);

                Assert.Equal(ItemDto.DataOneofCase.User, items[0].DataCase);
                Assert.Equal(UserDto.DataOneofCase.Full, items[0].User.DataCase);
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
                };
                filter.ItemTypes.Add(ItemFilterDto.Types.ItemType.Offers);

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
                cts.CancelAfter(TimeSpan.FromSeconds(1));
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
