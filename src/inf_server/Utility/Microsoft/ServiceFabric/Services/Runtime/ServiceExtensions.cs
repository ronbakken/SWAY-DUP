using System;
using System.Fabric;
using System.Fabric.Health;
using System.Runtime.CompilerServices;
using System.Threading.Tasks;

namespace Microsoft.ServiceFabric.Services.Runtime
{
    public static class ServiceExtensions
    {
        public static T ReportExceptionsWithin<T>(this StatelessService @this, Func<T> execute, [CallerMemberName]string caller = "")
        {
            try
            {
                return execute();
            }
            catch (Exception ex)
            {
                SendHealthReport(
                    @this.Context.CodePackageActivationContext,
                    @this.Context.ServiceName.ToString(),
                    caller,
                    ex);
                throw;
            }
        }

        public static async Task<T> ReportExceptionsWithin<T>(this StatelessService @this, Func<Task<T>> execute, [CallerMemberName]string caller = "")
        {
            try
            {
                return await execute();
            }
            catch (Exception ex)
            {
                SendHealthReport(
                    @this.Context.CodePackageActivationContext,
                    @this.Context.ServiceName.ToString(),
                    caller,
                    ex);
                throw;
            }
        }

        private static void SendHealthReport(
            ICodePackageActivationContext codePackageActivationContext,
            string serviceName,
            string property,
            Exception exception)
        {
            var healthInformation = new HealthInformation(serviceName, property, HealthState.Error)
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
