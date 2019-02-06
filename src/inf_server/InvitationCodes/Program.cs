using System.Threading.Tasks;
using Utility;

namespace InvitationCodes
{
    internal static class Program
    {
        private static async Task Main()
        {
            await ServiceBootstrapper
                .Bootstrap("InvitationCodes", context => new InvitationCodes(context))
                .ContinueOnAnyContext();
        }
    }
}
