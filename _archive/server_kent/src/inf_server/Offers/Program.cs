﻿using System.Threading;
using System.Threading.Tasks;
using Utility;
using Utility.gRPC;
using Utility.Microsoft.Azure.Cosmos;
using Utility.Microsoft.Azure.ServiceBus;

namespace Offers
{
    static class Program
    {
        static async Task Main(string[] args)
        {
            var logger = Logging.GetLogger(typeof(Program));
            var offerUpdated = ServiceBus.GetServiceBusTopicClient(logger, "OfferUpdated");
            var offersService = new OffersServiceImpl(logger, offerUpdated);
            var cosmosClient = Cosmos.GetCosmosClient();
            await offersService
                .Initialize(cosmosClient)
                .ContinueOnAnyContext();
            var server = ServerFactory.Create(
                useSsl: false,
                Interfaces.OffersService.BindService(offersService));

            logger.Debug("Starting server");
            server.Start();
            logger.Debug("Server started");

            await Task.Delay(Timeout.Infinite);
        }
    }
}
