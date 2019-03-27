using System.Collections.Generic;
using System.Fabric;
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
using Microsoft.ServiceFabric.Services.Communication.Runtime;
using Microsoft.ServiceFabric.Services.Runtime;
using Serilog;
using Utility;
using Utility.gRPC;

namespace API
{
    internal sealed class API : StatelessService
    {
        private readonly ILogger logger;
        private readonly SubscriptionClient conversationUpdatedSubscriptionClient;
        private readonly SubscriptionClient messageUpdatedSubscriptionClient;
        private readonly SubscriptionClient offerUpdatedSubscriptionClient;
        private readonly SubscriptionClient userUpdatedSubscriptionClient;

        public API(StatelessServiceContext context)
            : base(context)
        {
            this.logger = Logging.GetLogger(this);
            this.conversationUpdatedSubscriptionClient = this.Context.CodePackageActivationContext.GetServiceBusSubscriptionClient(this.logger, "ConversationUpdated", "listen_api", ReceiveMode.ReceiveAndDelete);
            this.messageUpdatedSubscriptionClient = this.Context.CodePackageActivationContext.GetServiceBusSubscriptionClient(this.logger, "MessageUpdated", "listen_api", ReceiveMode.ReceiveAndDelete);
            this.offerUpdatedSubscriptionClient = this.Context.CodePackageActivationContext.GetServiceBusSubscriptionClient(this.logger, "OfferUpdated", "listen_api", ReceiveMode.ReceiveAndDelete);
            this.userUpdatedSubscriptionClient = this.Context.CodePackageActivationContext.GetServiceBusSubscriptionClient(this.logger, "UserUpdated", "listen_api", ReceiveMode.ReceiveAndDelete);
        }

        protected override IEnumerable<ServiceInstanceListener> CreateServiceInstanceListeners()
        {
            var authorizationInterceptor = new AuthorizationInterceptor(this.logger);

            var communicationListener = new CommunicationListener(
                this.logger,
                useSsl: true,
                InfApi.BindService(new Services.Mocks.InfApiImpl()).Intercept(authorizationInterceptor),
                InfAuth.BindService(new InfAuthImpl(this.logger)).Intercept(authorizationInterceptor),
                InfBlobStorage.BindService(new InfBlobStorageImpl(this.logger)).Intercept(authorizationInterceptor),
                InfConfig.BindService(new Services.Mocks.InfConfigImpl()).Intercept(authorizationInterceptor),
                InfInvitationCodes.BindService(new InfInvitationCodesImpl(this.logger)).Intercept(authorizationInterceptor),
                InfList.BindService(new InfListImpl(this.logger)).Intercept(authorizationInterceptor),
                InfListen
                    .BindService(
                        new InfListenImpl(
                            this.logger,
                            this.conversationUpdatedSubscriptionClient,
                            this.messageUpdatedSubscriptionClient,
                            this.offerUpdatedSubscriptionClient,
                            this.userUpdatedSubscriptionClient))
                    .Intercept(authorizationInterceptor),
                InfMessaging.BindService(new InfMessagingImpl(this.logger)).Intercept(authorizationInterceptor),
                InfOffers.BindService(new InfOffersImpl(this.logger)).Intercept(authorizationInterceptor),
                InfSystem.BindService(new InfSystemImpl(this.logger)).Intercept(authorizationInterceptor),
                InfUsers.BindService(new InfUsersImpl(this.logger)).Intercept(authorizationInterceptor));

            return new[]
            {
                new ServiceInstanceListener(initParams => communicationListener),
            };
        }
    }
}
