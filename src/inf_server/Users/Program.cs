using System.Threading.Tasks;
using Utility;

namespace Users
{
    internal static class Program
    {
        private static async Task Main()
        {
            await ServiceBootstrapper
                .Bootstrap(
                    "Users",
                    context => new Users(context))
                .ContinueOnAnyContext();
        }
    }
}
