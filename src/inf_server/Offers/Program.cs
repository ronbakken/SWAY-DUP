using System.Threading.Tasks;
using Utility;

namespace Offers
{
    internal static class Program
    {
        private static async Task Main()
        {
            await ServiceBootstrapper
                .Bootstrap("Offers", context => new Offers(context))
                .ContinueOnAnyContext();
        }
    }
}
