using System.Runtime.Serialization;
using Optional;

namespace User.Interfaces
{
    [DataContract]
    public sealed class UserData
    {
        public static readonly UserData Initial = new UserData(UserType.Unknown, UserStatus.Unknown, null, null, null);

        public UserData(
            UserType type,
            UserStatus status,
            string name,
            string description,
            string oneTimeAccessToken)
        {
            this.Type = type;
            this.Status = status;
            this.Name = name;
            this.Description = description;
            this.OneTimeAccessToken = oneTimeAccessToken;
        }

        [DataMember]
        public UserType Type { get; protected set; }

        [DataMember]
        public UserStatus Status { get; protected set; }

        [DataMember]
        public string Name { get; protected set; }

        [DataMember]
        public string Description { get; protected set; }

        [DataMember]
        public string OneTimeAccessToken { get; protected set; }

        public UserData With(
            Option<UserType> type = default,
            Option<UserStatus> status = default,
            Option<string> name = default,
            Option<string> description = default,
            Option<string> oneTimeAccessToken = default) =>
            new UserData(
                type.ValueOr(Type),
                status.ValueOr(Status),
                name.ValueOr(Name),
                description.ValueOr(Description),
                oneTimeAccessToken.ValueOr(OneTimeAccessToken));
    }
}
