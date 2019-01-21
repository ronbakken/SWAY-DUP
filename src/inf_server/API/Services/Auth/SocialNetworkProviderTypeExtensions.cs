using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using User.Interfaces;
using api = API.Interfaces;

namespace API.Services.Auth
{
    public static class SocialNetworkProviderTypeExtensions
    {
        public static api.SocialNetworkProviderType ToDto(this SocialNetworkProviderType @this)
        {
            switch (@this)
            {
                case SocialNetworkProviderType.Custom:
                    return api.SocialNetworkProviderType.CustomSocialnetWorkProvider;
                case SocialNetworkProviderType.Facebook:
                    return api.SocialNetworkProviderType.Facebook;
                case SocialNetworkProviderType.Instagram:
                    return api.SocialNetworkProviderType.Instagram;
                case SocialNetworkProviderType.Snapchat:
                    return api.SocialNetworkProviderType.Snapchat;
                case SocialNetworkProviderType.Twitter:
                    return api.SocialNetworkProviderType.Twitter;
                case SocialNetworkProviderType.YouTube:
                    return api.SocialNetworkProviderType.YouTube;
                default:
                    throw new NotSupportedException();
            }
        }

        public static SocialNetworkProviderType ToService(this api.SocialNetworkProviderType @this)
        {
            switch (@this)
            {
                case api.SocialNetworkProviderType.CustomSocialnetWorkProvider:
                    return SocialNetworkProviderType.Custom;
                case api.SocialNetworkProviderType.Facebook:
                    return SocialNetworkProviderType.Facebook;
                case api.SocialNetworkProviderType.Instagram:
                    return SocialNetworkProviderType.Instagram;
                case api.SocialNetworkProviderType.Snapchat:
                    return SocialNetworkProviderType.Snapchat;
                case api.SocialNetworkProviderType.Twitter:
                    return SocialNetworkProviderType.Twitter;
                case api.SocialNetworkProviderType.YouTube:
                    return SocialNetworkProviderType.YouTube;
                default:
                    throw new NotSupportedException();
            }
        }
    }
}
