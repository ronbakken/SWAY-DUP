using System.Collections.Immutable;
using System.Threading.Tasks;
using Serilog;

namespace IntegrationTests
{
    public sealed class ExecutionPlan
    {
        public static readonly ExecutionPlan Default = new ExecutionPlan(ImmutableList<Test>.Empty);

        private ExecutionPlan(ImmutableList<Test> tests)
        {
            this.Tests = tests;
        }

        public ImmutableList<Test> Tests { get; }

        public ExecutionPlan AddTest(Test test) =>
            new ExecutionPlan(this.Tests.Add(test));

        public async Task Execute(ILogger logger, ExecutionContext context)
        {
            foreach (var test in this.Tests)
            {
                logger.Information($"START: {test.Name}");

                context = await test.Logic(context);

                logger.Information($"END: {test.Name}");
            }
        }
    }
}
