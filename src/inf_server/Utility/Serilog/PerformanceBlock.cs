using System;
using System.Diagnostics;
using System.Threading;

namespace Serilog
{
    // Lifted from https://github.com/kentcb/Genesis.Logging/blob/master/Src/Genesis.Logging/PerformanceBlock.cs.
    public struct PerformanceBlock : IDisposable
    {
        public static readonly PerformanceBlock Empty = new PerformanceBlock();

        private readonly ILogger owner;
        private readonly string messageTemplate;
        private readonly object[] propertyValues;
        private readonly Stopwatch stopwatch;
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
