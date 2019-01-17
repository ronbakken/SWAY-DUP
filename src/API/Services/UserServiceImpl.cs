using System;
using System.Threading.Tasks;
using Grpc.Core;
using Microsoft.ServiceFabric.Actors;
using Microsoft.ServiceFabric.Actors.Client;
using User.Interfaces;
using static API.UserService;

namespace API.Services
{
    public sealed class UserServiceImpl : UserServiceBase
    {
        //public override async Task<GetNameResponse> GetName(GetNameRequest request, ServerCallContext context)
        //{
        //    //var userActor = GetUserActor(request.Id);
        //    //var name = await userActor.GetName(context.CancellationToken);
        //    //var result = new GetNameResponse
        //    //{
        //    //    Name = name,
        //    //};

        //    //return result;

        //    return new GetNameResponse();
        //}

        //public override async Task<SetNameResponse> SetName(SetNameRequest request, ServerCallContext context)
        //{
        //    //var userActor = GetUserActor(request.Id);
        //    //await userActor.SetName(request.Name, context.CancellationToken);

        //    return new SetNameResponse();
        //}

        private IUser GetUserActor(int id) => ActorProxy.Create<IUser>(new ActorId(id), new Uri("fabric:/server/UserActorService"));
    }
}
