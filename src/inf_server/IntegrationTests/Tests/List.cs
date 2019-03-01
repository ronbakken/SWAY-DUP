using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using API.Interfaces;
using Grpc.Core;
using Xunit;

namespace IntegrationTests.Tests
{
    public static class List
    {
        public static Task<ExecutionContext> ListUsersAsAnInfluencer(ExecutionContext context) =>
            ListUsersAsUserType(context, UserType.Influencer);

        public static Task<ExecutionContext> ListUsersAsABusiness(ExecutionContext context) =>
            ListUsersAsUserType(context, UserType.Business);

        private static async Task<ExecutionContext> ListUsersAsUserType(ExecutionContext context, UserType userType)
        {
            var logger = context.Logger;
            var client = new InfList.InfListClient(context.GetServerChannel());

            var call = client.List(headers: context.GetAccessHeaders(userType));

            using (call)
            {
                var filter = new ItemFilterDto
                {
                };
                filter.ItemTypes.Add(ItemFilterDto.Types.ItemType.Users);

                await call.RequestStream.WriteAsync(
                    new ListRequest
                    {
                        State = ListRequest.Types.State.Resumed,
                        Filter = filter
                    });

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

                Assert.NotEmpty(items);

                foreach (var item in items)
                {
                    Assert.Equal(ItemDto.DataOneofCase.User, item.DataCase);
                    Assert.Equal(UserDto.DataOneofCase.List, item.User.DataCase);

                    // Influencers should never see other influencers, nor should business see other businesses
                    Assert.NotEqual(userType, item.User.List.Type);
                }
            }

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
                };
                filter.ItemTypes.Add(ItemFilterDto.Types.ItemType.Offers);

                await call.RequestStream.WriteAsync(
                    new ListRequest
                    {
                        State = ListRequest.Types.State.Resumed,
                        Filter = filter
                    });

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

                Assert.NotEmpty(items);

                foreach (var item in items)
                {
                    Assert.Equal(ItemDto.DataOneofCase.Offer, item.DataCase);
                    Assert.Equal(OfferDto.DataOneofCase.List, item.Offer.DataCase);
                }
            }

            return context;
        }
    }
}
