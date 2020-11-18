using System.Threading.Tasks;

namespace IntegrationTests
{
    public delegate Task<ExecutionContext> TestLogic(ExecutionContext context);

    public sealed class Test
    {
        public Test(string name, TestLogic logic)
        {
            this.Name = name;
            this.Logic = logic;
        }

        public string Name { get; }

        public TestLogic Logic { get; }
    }
}
