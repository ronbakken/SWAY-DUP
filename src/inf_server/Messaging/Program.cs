using System.Threading.Tasks;
using Utility;

namespace Messaging
{
    internal static class Program
    {
        private static async Task Main()
        {
            await ServiceBootstrapper
                .Bootstrap(
                    "Messaging",
                    context => new Messaging(context))
                .ContinueOnAnyContext();
        }
    }
}
