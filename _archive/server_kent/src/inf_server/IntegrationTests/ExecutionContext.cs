using System.Collections.Immutable;
using AutoFixture;
using Serilog;

namespace IntegrationTests
{
    public sealed class ExecutionContext
    {
        public ExecutionContext(ILogger logger, IFixture fixture)
            : this(logger, fixture, ImmutableDictionary<string, object>.Empty)
        {
        }

        private ExecutionContext(ILogger logger, IFixture fixture, ImmutableDictionary<string, object> data)
        {
            this.Logger = logger;
            this.Fixture = fixture;
            this.Data = data;
        }

        // Should be used by tests to perform any logging.
        public ILogger Logger { get; }

        // Can be used by tests to generate auto-populated objects.
        public IFixture Fixture { get; }

        // Can be used by tests to store arbitrary data for later tests. Note that extension methods should be used rather
        // then manipulating this directly. See existing examples.
        public ImmutableDictionary<string, object> Data { get; }

        public ExecutionContext WithDataValue(string key, object value) =>
            new ExecutionContext(this.Logger, this.Fixture, this.Data.Remove(key).Add(key, value));

        public ExecutionContext WithoutDataValue(string key) =>
            new ExecutionContext(this.Logger, this.Fixture, this.Data.Remove(key));
    }
}
