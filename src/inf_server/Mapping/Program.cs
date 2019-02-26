using System.Linq;
using System.Threading.Tasks;
using Mapping.Interfaces;
using Offers.Interfaces;
using Users.Interfaces;
using Utility;

namespace Mapping
{
    internal static class Program
    {
        private static async Task Main()
        {
            await ServiceBootstrapper
                .Bootstrap(
                    "Mapping",
                    context => new Mapping(context))
                .ContinueOnAnyContext();
        }
    }
}
