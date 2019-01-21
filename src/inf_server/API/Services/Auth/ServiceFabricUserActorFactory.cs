using System;
using Microsoft.ServiceFabric.Actors;
using Microsoft.ServiceFabric.Actors.Client;
using User.Interfaces;

namespace API.Services.Auth
{
    public sealed class ServiceFabricUserActorFactory : IUserActorFactory
    {
        public static readonly ServiceFabricUserActorFactory Instance = new ServiceFabricUserActorFactory();

        public IUser Get(string userId) =>
            ActorProxy.Create<IUser>(new ActorId(userId), new Uri("fabric:/server/UserActorService"));
    }
}
