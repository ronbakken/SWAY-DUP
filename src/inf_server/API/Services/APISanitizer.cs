using System;
using System.Fabric;
using System.Fabric.Health;
using System.Runtime.CompilerServices;
using System.Threading.Tasks;
using Genesis.Ensure;
using Grpc.Core;
using Serilog;

namespace API.Services
{
    public static class APISanitizer
    {
        public static T Sanitize<T>(ILogger logger, Func<ILogger, T> execute, [CallerMemberName]string caller = "")
        {
            Ensure.ArgumentNotNull(logger, nameof(logger));
            Ensure.ArgumentNotNull(execute, nameof(execute));

            var executeLogger = logger
                .ForContext("API", caller)
                .ForContext("CorrelationId", Guid.NewGuid());
            executeLogger.Verbose("Executing");

            try
            {
                return execute(executeLogger);
            }
            catch (RpcException ex)
            {
                logger.Warning(ex, "Expected failure whilst invoking API, caller {Caller}", caller);
                throw;
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Unexpected failure whilst invoking API, caller {Caller}", caller);

                var codePackageActivationContext = FabricRuntime.GetActivationContext();
                SendHealthReport(
                    codePackageActivationContext,
                    caller,
                    ex);

                throw;
            }
            finally
            {
                executeLogger.Verbose("Execution complete");
            }
        }

        public static async Task<T> Sanitize<T>(ILogger logger, Func<ILogger, Task<T>> execute, [CallerMemberName]string caller = "")
        {
            Ensure.ArgumentNotNull(logger, nameof(logger));
            Ensure.ArgumentNotNull(execute, nameof(execute));

            var executeLogger = logger
                .ForContext("API", caller)
                .ForContext("CorrelationId", Guid.NewGuid());
            executeLogger.Verbose("Executing");

            try
            {
                return await execute(executeLogger).ContinueOnAnyContext();
            }
            catch (RpcException ex)
            {
                logger.Warning(ex, "Expected failure whilst invoking API, caller {Caller}", caller);
                throw;
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Unexpected failure whilst invoking API, caller {Caller}", caller);

                var codePackageActivationContext = FabricRuntime.GetActivationContext();
                SendHealthReport(
                    codePackageActivationContext,
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
