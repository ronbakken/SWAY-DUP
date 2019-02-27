using System;
using System.Fabric;
using System.Fabric.Health;
using System.Runtime.CompilerServices;
using System.Threading.Tasks;
using Genesis.Ensure;
using Grpc.Core;
using Serilog;

namespace Utility
{
    public static class APISanitizer
    {
        public const string CorrelationIdKey = "CorrelationId";
        public const string ApiKey = "API";

        public static T Sanitize<T>(ILogger logger, Func<ILogger, T> execute, [CallerMemberName]string caller = "")
        {
            Ensure.ArgumentNotNull(logger, nameof(logger));
            Ensure.ArgumentNotNull(execute, nameof(execute));

            var correlationId = Guid.NewGuid().ToString();
            var api = caller;

            if (LoggingContextCorrelator.TryGetValue(CorrelationIdKey, out var existingCorrelationId))
            {
                correlationId = existingCorrelationId + "->" + correlationId;
            }

            if (LoggingContextCorrelator.TryGetValue(ApiKey, out var existingApi))
            {
                api = existingApi + "->" + api;
            }

            using (LoggingContextCorrelator.BeginOrReplaceCorrelationScope(CorrelationIdKey, correlationId))
            using (LoggingContextCorrelator.BeginOrReplaceCorrelationScope(ApiKey, api))
            {
                logger.Verbose("Executing");

                try
                {
                    return execute(logger);
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
                    logger.Verbose("Execution complete");
                }
            }
        }

        public static async Task<T> Sanitize<T>(ILogger logger, Func<ILogger, Task<T>> execute, [CallerMemberName]string caller = "")
        {
            Ensure.ArgumentNotNull(logger, nameof(logger));
            Ensure.ArgumentNotNull(execute, nameof(execute));

            var correlationId = Guid.NewGuid().ToString();
            var api = caller;

            if (LoggingContextCorrelator.TryGetValue(CorrelationIdKey, out var existingCorrelationId))
            {
                correlationId = existingCorrelationId + "->" + correlationId;
            }

            if (LoggingContextCorrelator.TryGetValue(ApiKey, out var existingApi))
            {
                api = existingApi + "->" + api;
            }

            using (LoggingContextCorrelator.BeginOrReplaceCorrelationScope(CorrelationIdKey, correlationId))
            using (LoggingContextCorrelator.BeginOrReplaceCorrelationScope(ApiKey, api))
            {
                logger.Verbose("Executing");

                try
                {
                    // We continue on same context because pushing properties onto LogContext (via the LoggingContextCorrelator) has thread affinity.
                    return await execute(logger).ContinueOnSameContext();
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
                    logger.Verbose("Execution complete");
                }
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
