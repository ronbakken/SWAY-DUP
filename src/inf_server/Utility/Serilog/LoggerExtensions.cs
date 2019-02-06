using System;
using Serilog.Events;

namespace Serilog
{
    public static class LoggerExtensions
    {
        public static PerformanceBlock Performance(this ILogger @this, string messageTemplate)
        {
            if (!@this.IsEnabled(LogEventLevel.Debug))
            {
                return PerformanceBlock.Empty;
            }

            return new PerformanceBlock(@this, messageTemplate, null);
        }

        public static PerformanceBlock Performance<T>(this ILogger @this, string messageTemplate, T propertyValue)
        {
            if (!@this.IsEnabled(LogEventLevel.Debug))
            {
                return PerformanceBlock.Empty;
            }

            return new PerformanceBlock(@this, messageTemplate, new object[] { propertyValue });
        }

        public static PerformanceBlock Performance<T0, T1>(this ILogger @this, string messageTemplate, T0 propertyValue0, T1 propertyValue1)
        {
            if (!@this.IsEnabled(LogEventLevel.Debug))
            {
                return PerformanceBlock.Empty;
            }

            return new PerformanceBlock(@this, messageTemplate, new object[] { propertyValue0, propertyValue1 });
        }

        public static PerformanceBlock Performance<T0, T1, T2>(this ILogger @this, Exception exception, string messageTemplate, T0 propertyValue0, T1 propertyValue1, T2 propertyValue2)
        {
            if (!@this.IsEnabled(LogEventLevel.Debug))
            {
                return PerformanceBlock.Empty;
            }

            return new PerformanceBlock(@this, messageTemplate, new object[] { propertyValue0, propertyValue1, propertyValue2 });
        }

        public static PerformanceBlock Performance(this ILogger @this, string messageTemplate, params object[] propertyValues)
        {
            if (!@this.IsEnabled(LogEventLevel.Debug))
            {
                return PerformanceBlock.Empty;
            }

            return new PerformanceBlock(@this, messageTemplate, propertyValues);
        }
    }
}
