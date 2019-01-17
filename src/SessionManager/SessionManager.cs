using System.Collections.Generic;
using System.Fabric;
using System.Threading.Tasks;
using Microsoft.ServiceFabric.Services.Communication.Runtime;
using Microsoft.ServiceFabric.Services.Runtime;
using SessionManager.Interfaces;
using Utility;

namespace SessionManager
{
    internal sealed class SessionManager : StatelessService, ISessionManagerService
    {
        public SessionManager(StatelessServiceContext context)
            : base(context)
        { }

        public Task<string> CreateSession()
        {
            Log("Creating a session.");
            var token = TokenManager.GenerateToken();
            return Task.FromResult(token);
        }

        protected override IEnumerable<ServiceInstanceListener> CreateServiceInstanceListeners() =>
            this.CreateServiceInstanceListeners();

        private static void Log(string message, params object[] args) =>
            ServiceEventSource.Current.Message(message, args);
    }
}
