namespace Utility.Sql
{
    public struct FieldName
    {
        private FieldName(string name, bool isQualified)
        {
            this.Name = name;
            this.IsQualified = isQualified;
        }

        public string Name { get; }

        public bool IsQualified { get; }

        public string ToString(string tableAlias)
        {
            if (this.IsQualified)
            {
                return this.Name;
            }
            else
            {
                return $"{tableAlias}.{this.Name}";
            }
        }

        public static FieldName Unqualified(string unualifiedFieldName) =>
            new FieldName(unualifiedFieldName, isQualified: false);

        public static FieldName Qualified(string qualifiedFieldName) =>
            new FieldName(qualifiedFieldName, isQualified: true);

        public static implicit operator FieldName(string unqualifiedFieldName) =>
            new FieldName(unqualifiedFieldName, isQualified: false);

        public static FieldName operator +(FieldName left, string right) =>
            new FieldName(left.Name + "." + right, left.IsQualified);
    }
}
