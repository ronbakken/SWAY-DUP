namespace Utility.Sql
{
    public sealed class Join
    {
        public Join(string alias, string path)
        {
            this.Alias = alias;
            this.Path = path;
        }

        public string Alias { get; }

        public string Path { get; }
    }
}
