using System.Threading.Tasks;
using API.Interfaces;

namespace IntegrationTests.Tests
{
    public static class System
    {
        public static async Task<ExecutionContext> Ping(ExecutionContext context)
        {
            var client = new InfSystem.InfSystemClient(context.GetServerChannel());
            await client.PingServerAsync(Empty.Instance);

            return context;
        }
    }
}
