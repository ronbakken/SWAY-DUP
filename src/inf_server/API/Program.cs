using System.Threading;
using System.Threading.Tasks;
using API.Interfaces;
using API.Services.Auth;
using API.Services.BlobStorage;
using API.Services.InvitationCodes;
using API.Services.List;
using API.Services.Listen;
using API.Services.Messaging;
using API.Services.Offers;
using API.Services.System;
using API.Services.Users;
using Grpc.Core.Interceptors;
using Microsoft.Azure.ServiceBus;
using Utility;
using Utility.gRPC;
using Utility.Microsoft.Azure.ServiceBus;

namespace API
{
    static class Program
    {
        static async Task Main(string[] args)
        {
            var logger = Logging.GetLogger(typeof(Program));
            var conversationUpdated = ServiceBus.GetServiceBusSubscriptionClient(logger, "ConversationUpdated", "listen_api", ReceiveMode.ReceiveAndDelete);
            var messageUpdated = ServiceBus.GetServiceBusSubscriptionClient(logger, "MessageUpdated", "listen_api", ReceiveMode.ReceiveAndDelete);
            var offerUpdated = ServiceBus.GetServiceBusSubscriptionClient(logger, "OfferUpdated", "listen_api", ReceiveMode.ReceiveAndDelete);
            var userUpdated = ServiceBus.GetServiceBusSubscriptionClient(logger, "UserUpdated", "listen_api", ReceiveMode.ReceiveAndDelete);
            var authorizationInterceptor = new AuthorizationInterceptor(logger);
            var server = ServerFactory.Create(
                useSsl: true,
                InfApi.BindService(new Services.Mocks.InfApiImpl()).Intercept(authorizationInterceptor),
                InfAuth.BindService(new InfAuthImpl(logger)).Intercept(authorizationInterceptor),
                InfBlobStorage.BindService(new InfBlobStorageImpl(logger)).Intercept(authorizationInterceptor),
                InfConfig.BindService(new Services.Mocks.InfConfigImpl()).Intercept(authorizationInterceptor),
                InfInvitationCodes.BindService(new InfInvitationCodesImpl(logger)).Intercept(authorizationInterceptor),
                InfList.BindService(new InfListImpl(logger)).Intercept(authorizationInterceptor),
                InfListen
                    .BindService(
                        new InfListenImpl(
                            logger,
                            conversationUpdated,
                            messageUpdated,
                            offerUpdated,
                            userUpdated))
                    .Intercept(authorizationInterceptor),
                InfMessaging.BindService(new InfMessagingImpl(logger)).Intercept(authorizationInterceptor),
                InfOffers.BindService(new InfOffersImpl(logger)).Intercept(authorizationInterceptor),
                InfSystem.BindService(new InfSystemImpl(logger)).Intercept(authorizationInterceptor),
                InfUsers.BindService(new InfUsersImpl(logger)).Intercept(authorizationInterceptor));

            logger.Debug("Starting server");
            server.Start();
            logger.Debug("Server started");

            await Task.Delay(Timeout.Infinite);
        }
    }
}
