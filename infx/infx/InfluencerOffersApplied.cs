using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using Xamarin.Forms;

namespace infx
{
	class OfferData
	{
		public string Business;
		public string ImageUrl;
		public Xamarin.Forms.Maps.Position Position;
		public string Title;
		public string Description;
		public string Reward;
	}

	public class InfluencerOffersApplied : ContentPage
	{
		public class OfferCell : ViewCell
		{
			Label title;
			Image image = null;

			public OfferCell()
			{
				title = new Label { Text = "Hello world" };
				image = new Image();
				View = new StackLayout {
					Children = {
						title,
						image,
					},
				};
			}

			protected override void OnBindingContextChanged()
			{
				base.OnBindingContextChanged();

				OfferData data = BindingContext as OfferData;
				if (data != null)
				{
					title.Text = data.Title;
					image.Source = data.ImageUrl;
				}
			}
		}

		public InfluencerOffersApplied ()
		{
			ListView listView = new ListView {
				HorizontalOptions = LayoutOptions.FillAndExpand,
				VerticalOptions = LayoutOptions.FillAndExpand,
				ItemTemplate = new DataTemplate(() => {
					return new OfferCell();
				}),
			};

			Title = AppResources.OffersAppliedTitle;
			Content = new StackLayout {
				HorizontalOptions = LayoutOptions.FillAndExpand,
				VerticalOptions = LayoutOptions.FillAndExpand,
				Children = {
					listView
				}
			};

			List<OfferData> data = new List<OfferData>();
			data.Add(new OfferData {
				Business = "Big Kahuna",
				Title = "Free Dinner",
			});
			data.Add(new OfferData {
				Business = "Flying Steak",
				Title = "Also Free Dinner",
			});
			listView.ItemsSource = data;
		}
	}
}