using System;
using System.Diagnostics;
using System.Threading;
using Serilog.Events;

namespace Serilog
{
    // Lifted from https://github.com/kentcb/Genesis.Logging/blob/master/Src/Genesis.Logging/PerformanceBlock.cs.
    public struct PerformanceBlock : IDisposable
    {
        public static readonly PerformanceBlock Empty = new PerformanceBlock();

        private readonly ILogger owner;
        private readonly Stopwatch stopwatch;
        private string messageTemplate;
        private object[] propertyValues;
        private int disposed;

        public PerformanceBlock(ILogger owner, string messageTemplate, object[] propertyValues)
        {
            this.owner = owner;
            this.messageTemplate = messageTemplate;
            this.propertyValues = propertyValues;

            // NOTE: it's vital we use 0 to represent already disposed so that the Empty performance block does nothing
            this.disposed = 1;
            this.stopwatch = Stopwatch.StartNew();

            this.owner.Debug($"BEGIN: {this.messageTemplate}", this.propertyValues);
        }

        public void ReplaceMessage(string message)
        {
            if (!this.owner.IsEnabled(LogEventLevel.Debug))
            {
                return;
            }

            this.messageTemplate = message;
        }

        public void ReplaceMessage<T>(string messageTemplate, T propertyValue)
        {
            if (!this.owner.IsEnabled(LogEventLevel.Debug))
            {
                return;
            }

            this.messageTemplate = messageTemplate;
            this.propertyValues = new object[] { propertyValue };
        }

        public void ReplaceMessage<T0, T1>(string messageTemplate, T0 propertyValue0, T1 propertyValue1)
        {
            if (!this.owner.IsEnabled(LogEventLevel.Debug))
            {
                return;
            }

            this.messageTemplate = messageTemplate;
            this.propertyValues = new object[] { propertyValue0, propertyValue1 };
        }

        public void ReplaceMessage<T0, T1, T2>(string messageTemplate, T0 propertyValue0, T1 propertyValue1, T2 propertyValue2)
        {
            if (!this.owner.IsEnabled(LogEventLevel.Debug))
            {
                return;
            }

            this.messageTemplate = messageTemplate;
            this.propertyValues = new object[] { propertyValue0, propertyValue1, propertyValue2 };
        }

        public void ReplaceMessage(string messageTemplate, params object[] propertyValues)
        {
            if (!this.owner.IsEnabled(LogEventLevel.Debug))
            {
                return;
            }

            this.messageTemplate = messageTemplate;
            this.propertyValues = propertyValues;
        }

        public void Dispose()
        {
            if (Interlocked.CompareExchange(ref this.disposed, 0, 1) != 1)
            {
                return;
            }

            this.stopwatch.Stop();
            var amendedPropertyValues = new object[(this.propertyValues?.Length ?? 0) + 2];

            if (this.propertyValues != null)
            {
                Array.Copy(this.propertyValues, 0, amendedPropertyValues, 2, this.propertyValues.Length);
            }

            amendedPropertyValues[0] = this.stopwatch.Elapsed;
            amendedPropertyValues[1] = this.stopwatch.ElapsedMilliseconds;

            this.owner.Debug($"END [{{Elapsed}} ({{ElapsedMilliseconds}}ms)]: {this.messageTemplate}", amendedPropertyValues);
        }
    }
}
