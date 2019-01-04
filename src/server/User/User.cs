using Microsoft.ServiceFabric.Actors;
using Microsoft.ServiceFabric.Actors.Runtime;
using System.Threading;
using System.Threading.Tasks;
using User.Interfaces;

namespace User
{
    [StatePersistence(StatePersistence.Persisted)]
    internal class User : Actor, IUser
    {
        public User(ActorService actorService, ActorId actorId)
            : base(actorService, actorId)
        {
        }

        public async Task<string> GetName(CancellationToken cancellationToken = default)
        {
            var result = await this.StateManager.TryGetStateAsync<string>("name", cancellationToken);
            return result.HasValue ? result.Value : null;
        }

        public Task SetName(string name, CancellationToken cancellationToken = default)
        {
            return this.StateManager.SetStateAsync("name", name, cancellationToken);
        }
    }
}
