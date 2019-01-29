using System;
using System.Fabric;
using System.Fabric.Health;
using System.Runtime.CompilerServices;
using System.Threading.Tasks;

namespace API.Services
{
    public static class APISanitizer
    {
        public static T Sanitize<T>(Func<T> execute, [CallerMemberName]string caller = "")
        {
            try
            {
                return execute();
            }
            catch (Exception ex)
            {
                ServiceEventSource.Instance.Failure(ex, "Failed whilst invoking API, caller '{0}'.", caller);

                var codePackageActivationContext = FabricRuntime.GetActivationContext();
                SendHealthReport(
                    codePackageActivationContext,
                    caller,
                    ex);

                throw;
            }
        }

        public static async Task<T> Sanitize<T>(Func<Task<T>> execute, [CallerMemberName]string caller = "")
        {
            try
            {
                return await execute();
            }
            catch (Exception ex)
            {
                ServiceEventSource.Instance.Failure(ex, "Failed whilst invoking API, caller '{0}'.", caller);

                var codePackageActivationContext = FabricRuntime.GetActivationContext();
                SendHealthReport(
                    codePackageActivationContext,
                    caller,
                    ex);

                throw;
            }
        }

        private static void SendHealthReport(
            ICodePackageActivationContext codePackageActivationContext,
            string property,
            Exception exception)
        {
            var healthInformation = new HealthInformation("API", property, HealthState.Error)
            {
                Description = exception.ToString(),
            };
            var sendOptions = new HealthReportSendOptions
            {
                Immediate = true,
            };

            codePackageActivationContext.ReportDeployedServicePackageHealth(healthInformation, sendOptions);
        }
    }
}
