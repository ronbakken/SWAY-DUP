using System;
using System.Fabric;
using System.Fabric.Health;
using System.Runtime.CompilerServices;
using System.Threading.Tasks;
using Grpc.Core;

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
            catch (RpcException ex)
            {
                ServiceEventSource.Instance.Warn("Expected failure whilst invoking API, caller '{0}'. Exception was: '{1}'.", caller, ex);
                throw;
            }
            catch (Exception ex)
            {
                ServiceEventSource.Instance.Failure(ex, "Unexpected failure whilst invoking API, caller '{0}'.", caller);

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
            catch (RpcException ex)
            {
                ServiceEventSource.Instance.Warn("Expected failure whilst invoking API, caller '{0}'. Exception was: '{1}'.", caller, ex);
                throw;
            }
            catch (Exception ex)
            {
                ServiceEventSource.Instance.Failure(ex, "Unexpected failure whilst invoking API, caller '{0}'.", caller);

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
