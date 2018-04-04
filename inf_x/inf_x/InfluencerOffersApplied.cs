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
			Label text;
			Image image = null;

			public OfferCell()
			{
				title = new Label {
					Text = "Hello world",
					TextColor = Palette.Foreground,
					FontSize = Device.GetNamedSize(NamedSize.Medium, typeof(Label)),
					FontAttributes = FontAttributes.Bold,
				};
				text = new Label {
					Text = "Hello world"
				};
				image = new Image();
				View = new StackLayout {
					HorizontalOptions = LayoutOptions.FillAndExpand,
					VerticalOptions = LayoutOptions.FillAndExpand,
					Children = {
						title,
						image,
						text,
					},
				};
			}

			protected override void OnBindingContextChanged()
			{
				base.OnBindingContextChanged();

				OfferData data = BindingContext as OfferData;
				if (data != null)
				{
					title.Text = data.Title + " @ " + data.Business;
					image.Source = data.ImageUrl;
				}
			}
		}

		public InfluencerOffersApplied ()
		{
			ListView listView = new ListView {
				HorizontalOptions = LayoutOptions.FillAndExpand,
				VerticalOptions = LayoutOptions.FillAndExpand,
				RowHeight = 150,
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
				ImageUrl = "https://avatars3.githubusercontent.com/u/28218293?s=72&v=4",
				Title = "Free Dinner",
			});
			data.Add(new OfferData {
				Business = "Flying Steak",
				ImageUrl = "https://avatars3.githubusercontent.com/u/28218293?s=72&v=4",
				Title = "Also Free Dinner",
			});
			listView.ItemsSource = data;

			listView.ItemTapped += ListView_ItemTapped;
			
		}

		private void ListView_ItemTapped(object sender, ItemTappedEventArgs e)
		{
			OfferData data = e.Item as OfferData;
			Navigation.PushAsync(new ContentPage { Title = data.Title + " @ " + data.Business });
		}
	}
}