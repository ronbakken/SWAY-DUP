using System.Collections.Immutable;
using API.Interfaces;
using User.Interfaces;

namespace API.Services
{
    public static class AvatarExtensions
    {
        public static Avatar ToService(this UserDto @this)
        {
            if (@this == null)
            {
                return null;
            }

            return new Avatar(
                @this.AvatarUrl,
                @this.AvatarThumbnailUrl,
                @this.AvatarLowRes.ToImmutableList(),
                @this.AvatarThumbnailLowRes.ToImmutableList());
        }
    }
}
