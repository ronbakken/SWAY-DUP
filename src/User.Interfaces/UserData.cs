namespace User.Interfaces
{
    public sealed class UserData
    {
        public UserData(
            UserType type,
            string name,
            string description)
        {
            this.Type = type;
            this.Name = name;
            this.Description = description;
        }

        public UserType Type { get; }

        public string Name { get; }

        public string Description { get; }
    }
}
