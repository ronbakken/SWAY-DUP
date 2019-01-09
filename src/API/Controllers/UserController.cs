using Microsoft.AspNetCore.Mvc;
using Microsoft.ServiceFabric.Actors;
using Microsoft.ServiceFabric.Actors.Client;
using System;
using System.Threading.Tasks;
using User.Interfaces;

namespace API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public sealed class UserController : Controller
    {
        [HttpGet("{id}")]
        public async Task<string> GetName(string id)
        {
            var user = GetUserActor(id);
            var result = await user.GetName();

            return result ?? "<NONE>";
        }

        [HttpPost("{id}")]
        public async Task SetName(string id, [FromBody] string name)
        {
            var user = GetUserActor(id);
            await user.SetName(name);
        }

        private IUser GetUserActor(string id) => ActorProxy.Create<IUser>(new ActorId(id), new Uri("fabric:/server/UserActorService"));
    }
}