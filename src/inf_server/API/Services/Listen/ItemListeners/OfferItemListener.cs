using System;
using System.Linq;
using System.Reactive.Linq;
using API.Interfaces;
using API.ObjectMapping;
using Offers.Interfaces;
using Serilog;
using Utility.Search;
using Money = Utility.Money;

namespace API.Services.Listen.ItemListeners
{
    public sealed class OfferItemListener : ItemListener<Offer>
    {
        public OfferItemListener(
            ILogger logger,
            string userId) : base(logger, userId)
        {
        }

        protected override bool IsMatch(Offer offer, SingleItemFilterDto filter)
        {
            this.Logger.Debug("Determining if offer {@Offer} matches single-item filter {Filter}", offer, filter);

            if (string.Equals(filter.Id, offer.Id, StringComparison.Ordinal))
            {
                this.Logger.Debug("Offer has ID {OfferId}, which matches filter", offer.Id);
                return true;
            }

            this.Logger.Debug("Offer has ID {OfferId}, which does not match filter's ID of {FilterId}", offer.Id, filter.Id);
            return false;
        }

        protected override bool IsMatch(Offer offer, ItemFilterDto filter)
        {
            this.Logger.Debug("Determining if offer {@Offer} matches item filter {@Filter}", offer, filter);

            var offerFilter = filter.OfferFilter;

            if (offerFilter == null)
            {
                this.Logger.Debug("No offer filter provided, so no match");
                return false;
            }

            if (offerFilter.MinimumRewardCash != null)
            {
                var cashValue = offer.Terms?.CashValue;

                if (cashValue == null)
                {
                    this.Logger.Debug("Filter has minimum reward cash {@MinimumRewardCash} but offer has no cash value, so it does not satisfy filter", offerFilter.MinimumRewardCash);
                    return false;
                }

                if (!string.Equals(offerFilter.MinimumRewardCash.CurrencyCode, cashValue.CurrencyCode, StringComparison.Ordinal))
                {
                    this.Logger.Debug("Filter has minimum reward cash {@MinimumRewardCash} but offer's cash value has differing currency code {CurrencyCode}, so it does not satisfy filter", offerFilter.MinimumRewardCash, cashValue.CurrencyCode);
                    return false;
                }

                var cashValueMoney = new Money(cashValue.CurrencyCode, cashValue.Units, cashValue.Nanos);
                var minimumRewardMoney = new Money(offerFilter.MinimumRewardCash.CurrencyCode, offerFilter.MinimumRewardCash.Units, offerFilter.MinimumRewardCash.Nanos);

                if (cashValueMoney < minimumRewardMoney)
                {
                    this.Logger.Debug("Filter has minimum reward cash {@MinimumRewardCash} but offer's cash value is {CashValue}, so it does not satisfy filter", offerFilter.MinimumRewardCash, cashValue);
                    return false;
                }
            }

            if (offerFilter.MinimumRewardService != null)
            {
                var serviceValue = offer.Terms?.ServiceValue;

                if (serviceValue == null)
                {
                    this.Logger.Debug("Filter has minimum reward service {@MinimumRewardService} but offer has no service value, so it does not satisfy filter", offerFilter.MinimumRewardService);
                    return false;
                }

                if (!string.Equals(offerFilter.MinimumRewardService.CurrencyCode, serviceValue.CurrencyCode, StringComparison.Ordinal))
                {
                    this.Logger.Debug("Filter has minimum reward service {@MinimumRewardService} but offer's service value has differing currency code {CurrencyCode}, so it does not satisfy filter", offerFilter.MinimumRewardService, serviceValue.CurrencyCode);
                    return false;
                }

                var serviceValueMoney = new Money(serviceValue.CurrencyCode, serviceValue.Units, serviceValue.Nanos);
                var minimumRewardMoney = new Money(offerFilter.MinimumRewardService.CurrencyCode, offerFilter.MinimumRewardService.Units, offerFilter.MinimumRewardService.Nanos);

                if (serviceValueMoney < minimumRewardMoney)
                {
                    this.Logger.Debug("Filter has minimum reward service {@MinimumRewardService} but offer's service value is {ServiceValue}, so it does not satisfy filter", offerFilter.MinimumRewardService, serviceValue);
                    return false;
                }
            }

            if (!string.IsNullOrWhiteSpace(offerFilter.BusinessAccountId))
            {
                if (!string.Equals(offer.BusinessAccountId, offerFilter.BusinessAccountId, StringComparison.Ordinal))
                {
                    this.Logger.Debug("Filter has business account ID {FilterBusinessAccountId} but offer has {OfferBusinessAccountId}, so it does not satisfy filter", offerFilter.BusinessAccountId, offer.BusinessAccountId);
                    return false;
                }
            }

            if (offerFilter.OfferStatuses.Count > 0)
            {
                var offerStatus = offer.Status.ToStatus();

                if (!offerFilter.OfferStatuses.Contains(offerStatus))
                {
                    this.Logger.Debug("Filter has offer statuses {OfferStatuses} but offer has status {OfferStatus}, so it does not satisfy filter", offerFilter.OfferStatuses, offerStatus);
                    return false;
                }
            }

            if (offerFilter.AcceptancePolicies.Count > 0)
            {
                var offerAcceptancePolicy = offer.AcceptancePolicy.ToAcceptancePolicy();

                if (!offerFilter.AcceptancePolicies.Contains(offerAcceptancePolicy))
                {
                    this.Logger.Debug("Filter has acceptance policies {AcceptancePolicies} but offer has acceptance policy {OfferAcceptancePolicy}, so it does not satisfy filter", offerFilter.AcceptancePolicies, offerAcceptancePolicy);
                    return false;
                }
            }

            if (offerFilter.DeliverableTypes.Count > 0)
            {
                var deliverableTypes = offer
                    .Terms
                    ?.Deliverable
                    ?.DeliverableTypes
                    ?.Select(x => x.ToDeliverableType())
                    ?.ToList();

                if (deliverableTypes == null)
                {
                    this.Logger.Debug("Filter has deliverable types {DeliverableTypes} but offer has no deliverable types, so it does not satisfy filter", offerFilter.DeliverableTypes);
                    return false;
                }

                if (!deliverableTypes.Intersect(offerFilter.DeliverableTypes).Any())
                {
                    this.Logger.Debug("Filter has deliverable types {DeliverableTypes} but offer has deliverable types {OfferDeliverableTypes}, so it does not satisfy filter", offerFilter.DeliverableTypes, deliverableTypes);
                    return false;
                }
            }

            if (offer.CategoryIds.Intersect(offerFilter.CategoryIds).Count() != offerFilter.CategoryIds.Count)
            {
                this.Logger.Debug("Filter has category IDs {CategoryIds} but offer has category IDs {OfferCategoryIds}, so it does not satisfy filter", offerFilter.CategoryIds, offer.CategoryIds);
                return false;
            }

            if (offerFilter.NorthWest != null && offerFilter.SouthEast != null)
            {
                var geoPoint = offer.Location?.GeoPoint;

                if (geoPoint == null)
                {
                    this.Logger.Debug("Filter has geopoints {@NorthWest}-{@SouthEast} but offer has no location, so it does not satisfy filter", offerFilter.NorthWest, offerFilter.SouthEast);
                    return false;
                }

                if (
                    geoPoint.Latitude > offerFilter.NorthWest.Latitude ||
                    geoPoint.Longitude < offerFilter.NorthWest.Longitude ||
                    geoPoint.Latitude < offerFilter.SouthEast.Latitude ||
                    geoPoint.Longitude > offerFilter.SouthEast.Longitude)
                {
                    this.Logger.Debug("Filter has geopoints {@NorthWest}-{@SouthEast} but offer has geopoint {@OfferGeoPoint}, so it does not satisfy filter", offerFilter.NorthWest, offerFilter.SouthEast, offer.Location.GeoPoint);
                    return false;
                }
            }

            if (!string.IsNullOrWhiteSpace(offerFilter.Phrase))
            {
                var phraseKeywords = Keywords
                    .Extract(offerFilter.Phrase)
                    .ToList();

                if (offer.Keywords.Intersect(phraseKeywords).Count() != phraseKeywords.Count)
                {
                    this.Logger.Debug("Filter has phrase {Phrase} equating to keywords {PhraseKeywords}, but offer has keywords {OfferKeywords}, so it does not satisfy filter", offerFilter.Phrase, phraseKeywords, offer.Keywords);
                    return false;
                }
            }

            this.Logger.Debug("Offer {@Offer} matches filter {@Filter}", offer, filter);
            return true;
        }
    }
}
