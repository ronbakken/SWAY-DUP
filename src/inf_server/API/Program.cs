using System.Threading.Tasks;
using Utility;

namespace API
{
    internal static class Program
    {
        private static async Task Main()
        {
            await ServiceBootstrapper
                .Bootstrap("API", context => new API(context))
                .ContinueOnAnyContext();
        }
    }
}
