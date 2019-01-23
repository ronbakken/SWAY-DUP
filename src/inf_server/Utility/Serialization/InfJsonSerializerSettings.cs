using Newtonsoft.Json;
using NodaTime;
using NodaTime.Serialization.JsonNet;

namespace Utility.Serialization
{
    public sealed class InfJsonSerializerSettings : JsonSerializerSettings
    {
        public static readonly InfJsonSerializerSettings Instance = new InfJsonSerializerSettings();

        private InfJsonSerializerSettings()
        {
            this.ConfigureForNodaTime(DateTimeZoneProviders.Tzdb);
        }
    }
}
