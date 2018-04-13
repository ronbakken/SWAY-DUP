using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using Xamarin.Forms;

namespace InfX
{
	public class InfluencerOffers : TabbedPage
	{
		public InfluencerOffers ()
		{
			Title = AppResources.OffersTitle;
			Children.Add(new InfluencerOffersApplied());
			Children.Add(new InfluencerOffersDirect());
			Children.Add(new InfluencerOffersActive());
			Children.Add(new InfluencerOffersHistory());
		}
	}
}