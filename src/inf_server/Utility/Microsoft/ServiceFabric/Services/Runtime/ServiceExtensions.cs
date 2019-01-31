using System;
using System.Fabric;
using System.Fabric.Health;
using System.Runtime.CompilerServices;
using System.Threading.Tasks;
using Genesis.Ensure;
using Serilog;

namespace Microsoft.ServiceFabric.Services.Runtime
{
    public static class ServiceExtensions
    {
        public static T ReportExceptionsWithin<T>(this StatelessService @this, ILogger logger, Func<ILogger, T> execute, [CallerMemberName]string caller = "")
        {
            Ensure.ArgumentNotNull(logger, nameof(logger));
            Ensure.ArgumentNotNull(execute, nameof(execute));

            var serviceName = @this.Context.ServiceName.ToString();
            var executeLogger = logger
                .ForContext("ServiceName", serviceName)
                .ForContext("Procedure", caller)
                .ForContext("CorrelationId", Guid.NewGuid());
            executeLogger.Verbose("Executing");

            try
            {
                return execute(executeLogger);
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed whilst executing service");

                SendHealthReport(
                    @this.Context.CodePackageActivationContext,
                    @this.Context.ServiceName.ToString(),
                    caller,
                    ex);
                throw;
            }
            finally
            {
                executeLogger.Verbose("Execution complete");
            }
        }

        public static async Task<T> ReportExceptionsWithin<T>(this StatelessService @this, ILogger logger, Func<ILogger, Task<T>> execute, [CallerMemberName]string caller = "")
        {
            Ensure.ArgumentNotNull(logger, nameof(logger));
            Ensure.ArgumentNotNull(execute, nameof(execute));

            var serviceName = @this.Context.ServiceName.ToString();
            var executeLogger = logger
                .ForContext("ServiceName", serviceName)
                .ForContext("Procedure", caller)
                .ForContext("CorrelationId", Guid.NewGuid());
            executeLogger.Verbose("Executing");

            try
            {
                return await execute(executeLogger);
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed whilst executing service");

                SendHealthReport(
                    @this.Context.CodePackageActivationContext,
                    @this.Context.ServiceName.ToString(),
                    caller,
                    ex);
                throw;
            }
            finally
            {
                executeLogger.Verbose("Execution complete");
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
