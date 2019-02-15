using System.Collections.Generic;
using System.Fabric;
using API.Interfaces;
using API.Services.Auth;
using API.Services.BlobStorage;
using API.Services.InvitationCodes;
using API.Services.Mapping;
using API.Services.Messaging;
using API.Services.Offers;
using API.Services.System;
using API.Services.Users;
using Grpc.Core.Interceptors;
using Microsoft.ServiceFabric.Services.Communication.Runtime;
using Microsoft.ServiceFabric.Services.Runtime;
using Serilog;
using Utility;

namespace API
{
    internal sealed class API : StatelessService
    {
        private readonly ILogger logger;

        public API(StatelessServiceContext context)
            : base(context)
        {
            var configurationPackage = this.Context.CodePackageActivationContext.GetConfigurationPackageObject("Config");
            var logStorageConnectionString = configurationPackage.Settings.Sections["Logging"].Parameters["StorageConnectionString"].Value;
            this.logger = Logging.GetLogger(this, logStorageConnectionString);
        }

        protected override IEnumerable<ServiceInstanceListener> CreateServiceInstanceListeners()
        {
            var authorizationInterceptor = new AuthorizationInterceptor(this.logger);
            var gRPCCommunicationListener = new gRPCCommunicationListener(
                this.logger,
                InfApi.BindService(new Services.Mocks.InfApiImpl()).Intercept(authorizationInterceptor),
                InfAuth.BindService(new InfAuthImpl(this.logger)).Intercept(authorizationInterceptor),
                InfBlobStorage.BindService(new InfBlobStorageImpl(this.logger)).Intercept(authorizationInterceptor),
                InfConfig.BindService(new Services.Mocks.InfConfigImpl()).Intercept(authorizationInterceptor),
                InfInvitationCodes.BindService(new InfInvitationCodesImpl(this.logger)).Intercept(authorizationInterceptor),
                InfMapping.BindService(new InfMappingImpl(this.logger)).Intercept(authorizationInterceptor),
                InfMessaging.BindService(new InfMessagingImpl(this.logger)).Intercept(authorizationInterceptor),
                InfOffers.BindService(new InfOffersImpl(this.logger)).Intercept(authorizationInterceptor),
                InfSystem.BindService(new InfSystemImpl(this.logger)).Intercept(authorizationInterceptor),
                InfUsers.BindService(new InfUsersImpl(this.logger)).Intercept(authorizationInterceptor));

            return new[]
            {
                new ServiceInstanceListener(initParams => gRPCCommunicationListener),
            };
        }
    }
}
