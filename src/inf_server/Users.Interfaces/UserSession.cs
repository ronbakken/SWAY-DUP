using System.Runtime.Serialization;
using Optional;

namespace Users.Interfaces
{
    [DataContract]
    public sealed class UserSession
    {
        public UserSession(
            string refreshToken,
            string deviceId)
        {
            this.RefreshToken = refreshToken;
            this.DeviceId = deviceId;
        }

        [DataMember]
        public string RefreshToken { get; private set; }

        [DataMember]
        public string DeviceId { get; private set; }

        public UserSession With(
            Option<string> refreshToken = default,
            Option<string> deviceId = default) =>
            new UserSession(
                refreshToken.ValueOr(RefreshToken),
                deviceId.ValueOr(DeviceId));
    }
}
