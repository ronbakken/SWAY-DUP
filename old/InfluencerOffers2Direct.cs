using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using Xamarin.Forms;
using ImageCircle.Forms.Plugin.Abstractions;

namespace InfX
{
	public class InfluencerOffersDirect : ContentPage
	{
		public InfluencerOffersDirect()
		{
			Title = LanguageResources.OffersDirectTitle;
			Content = new StackLayout {
				HorizontalOptions = LayoutOptions.FillAndExpand,
				VerticalOptions = LayoutOptions.FillAndExpand,
				Children = {
				}
			};
		}
	}
}