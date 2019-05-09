using System;
using System.Linq;
using System.Reactive.Linq;
using API.Interfaces;
using API.ObjectMapping;
using Serilog;
using Users.Interfaces;
using Utility.Search;

namespace API.Services.Listen.ItemListeners
{
    public sealed class UserItemListener : ItemListener<User>
    {
        public UserItemListener(
            ILogger logger,
            string userId) : base(logger, userId)
        {
        }

        protected override bool IsMatch(User user, SingleItemFilterDto filter)
        {
            this.Logger.Debug("Determining if user {@User} matches single-item filter {Filter}", user, filter);

            if (string.Equals(filter.Id, user.Id, StringComparison.Ordinal))
            {
                this.Logger.Debug("User has ID {UserId}, which matches filter", user.Id);
                return true;
            }

            this.Logger.Debug("User has ID {UserId}, which does not match filter's ID of {FilterId}", user.Id, filter.Id);
            return false;
        }

        protected override bool IsMatch(User user, ItemFilterDto filter)
        {
            this.Logger.Debug("Determining if user {@User} matches item filter {@Filter}", user, filter);

            var userFilter = filter.UserFilter;

            if (userFilter == null)
            {
                this.Logger.Debug("No user filter provided, so no match");
                return false;
            }

            var socialMediaNetworkIds = user
                .SocialMediaAccounts
                .Select(x => x.SocialNetworkProviderId)
                .ToList();

            if (socialMediaNetworkIds.Intersect(userFilter.SocialMediaNetworkIds).Count() != userFilter.SocialMediaNetworkIds.Count)
            {
                this.Logger.Debug("Filter has social media accounts {FilterSocialMediaNetworkIds} but user has {UserSocialMediaNetworkIds}, so it does not satisfy filter", userFilter.SocialMediaNetworkIds, socialMediaNetworkIds);
                return false;
            }

            if (userFilter.UserTypes.Count > 0)
            {
                var userType = user.Type.ToUserType();

                if (!userFilter.UserTypes.Contains(userType))
                {
                    this.Logger.Debug("Filter has user types {FilterUserTypes} but user has user type {UserType}, so it does not satisfy filter", userFilter.UserTypes, userType);
                    return false;
                }
            }

            if (user.CategoryIds.Intersect(userFilter.CategoryIds).Count() != userFilter.CategoryIds.Count)
            {
                this.Logger.Debug("Filter has category IDs {CategoryIds} but user has category IDs {UserCategoryIds}, so it does not satisfy filter", userFilter.CategoryIds, user.CategoryIds);
                return false;
            }

            if (userFilter.NorthWest != null && userFilter.SouthEast != null)
            {
                var geoPoint = user.Location?.GeoPoint;

                if (geoPoint == null)
                {
                    this.Logger.Debug("Filter has geopoints {@NorthWest}-{@SouthEast} but user has no location, so it does not satisfy filter", userFilter.NorthWest, userFilter.SouthEast);
                    return false;
                }

                if (
                    geoPoint.Latitude > userFilter.NorthWest.Latitude ||
                    geoPoint.Longitude < userFilter.NorthWest.Longitude ||
                    geoPoint.Latitude < userFilter.SouthEast.Latitude ||
                    geoPoint.Longitude > userFilter.SouthEast.Longitude)
                {
                    this.Logger.Debug("Filter has geopoints {@NorthWest}-{@SouthEast} but user has geopoint {@OfferGeoPoint}, so it does not satisfy filter", userFilter.NorthWest, userFilter.SouthEast, user.Location.GeoPoint);
                    return false;
                }
            }

            if (!string.IsNullOrWhiteSpace(userFilter.Phrase))
            {
                var phraseKeywords = Keywords
                    .Extract(userFilter.Phrase)
                    .ToList();

                if (user.Keywords.Intersect(phraseKeywords).Count() != phraseKeywords.Count)
                {
                    this.Logger.Debug("Filter has phrase {Phrase} equating to keywords {PhraseKeywords}, but user has keywords {UserKeywords}, so it does not satisfy filter", userFilter.Phrase, phraseKeywords, user.Keywords);
                    return false;
                }
            }

            this.Logger.Debug("User {@User} matches filter {@Filter}", user, filter);
            return true;
        }
    }
}