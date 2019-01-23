using System;
using Users.Interfaces;

namespace Users
{
    public static class SocialNetworkProviderTypeEntityExtensions
    {
        public static SocialNetworkProviderType ToServiceObject(this SocialNetworkProviderTypeEntity @this)
        {
            switch (@this)
            {
                case SocialNetworkProviderTypeEntity.Custom:
                    return SocialNetworkProviderType.Custom;
                case SocialNetworkProviderTypeEntity.Facebook:
                    return SocialNetworkProviderType.Facebook;
                case SocialNetworkProviderTypeEntity.Instagram:
                    return SocialNetworkProviderType.Instagram;
                case SocialNetworkProviderTypeEntity.Snapchat:
                    return SocialNetworkProviderType.Snapchat;
                case SocialNetworkProviderTypeEntity.Twitter:
                    return SocialNetworkProviderType.Twitter;
                case SocialNetworkProviderTypeEntity.YouTube:
                    return SocialNetworkProviderType.YouTube;
                default:
                    throw new NotSupportedException();
            }
        }

        public static SocialNetworkProviderTypeEntity ToEntity(this SocialNetworkProviderType @this)
        {
            switch (@this)
            {
                case SocialNetworkProviderType.Custom:
                    return SocialNetworkProviderTypeEntity.Custom;
                case SocialNetworkProviderType.Facebook:
                    return SocialNetworkProviderTypeEntity.Facebook;
                case SocialNetworkProviderType.Instagram:
                    return SocialNetworkProviderTypeEntity.Instagram;
                case SocialNetworkProviderType.Snapchat:
                    return SocialNetworkProviderTypeEntity.Snapchat;
                case SocialNetworkProviderType.Twitter:
                    return SocialNetworkProviderTypeEntity.Twitter;
                case SocialNetworkProviderType.YouTube:
                    return SocialNetworkProviderTypeEntity.YouTube;
                default:
                    throw new NotSupportedException();
            }
        }
    }
}
