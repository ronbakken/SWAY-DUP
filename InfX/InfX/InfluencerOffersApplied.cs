using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using Xamarin.Forms;
using ImageCircle.Forms.Plugin.Abstractions;

namespace InfX
{
	public class InfluencerOffersApplied : ContentPage
	{
		class OfferCell : ViewCell
		{
			Label title;
			Label business;
			Label reward;
			Image image = null;

			public OfferCell()
			{
				title = new Label {
					Text = "Hello world",
					TextColor = Palette.Foreground,
					FontSize = Device.GetNamedSize(NamedSize.Large, typeof(Label)),
					FontAttributes = FontAttributes.Bold,
					HorizontalOptions = LayoutOptions.StartAndExpand,
					VerticalOptions = LayoutOptions.Start,
				};
				business = new Label {
					Text = "Hello world",
					// TextColor = Palette.Foreground,
					FontSize = Device.GetNamedSize(NamedSize.Medium, typeof(Label)),
					FontAttributes = FontAttributes.Bold,
					HorizontalOptions = LayoutOptions.StartAndExpand,
				};
				reward = new Label {
					Text = "Hello world"
				};
				image = new CircleImage {
					HorizontalOptions = LayoutOptions.Start,
					VerticalOptions = LayoutOptions.Center,
					HeightRequest = 93,
					WidthRequest = 93,
					Aspect = Aspect.AspectFill,
					// Margin = new Thickness(Device.GetNamedSize(NamedSize.Medium, typeof(Thickness))),
				};
				View = new StackLayout {
					Margin = new Thickness(Device.GetNamedSize(NamedSize.Micro, typeof(Thickness)), 0.0),
					HorizontalOptions = LayoutOptions.FillAndExpand,
					VerticalOptions = LayoutOptions.FillAndExpand,
					Children = {
						title,
						new StackLayout {
							// Margin = new Thickness(0.0, Device.GetNamedSize(NamedSize.Micro, typeof(Thickness))),
							HorizontalOptions = LayoutOptions.FillAndExpand,
							VerticalOptions = LayoutOptions.StartAndExpand,
							Orientation = StackOrientation.Horizontal,
							Children = {
								image,
								new StackLayout {
									Margin = new Thickness(Device.GetNamedSize(NamedSize.Micro, typeof(Thickness)), 0.0),
									HorizontalOptions = LayoutOptions.StartAndExpand,
									VerticalOptions = LayoutOptions.FillAndExpand,
									Children = {
										business,
										reward,
									},
								},
							},
						},
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
					business.Text = data.Business;
					reward.Text = data.Reward;
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
			data.Add(DummyData.Offers[0]);
			data.Add(DummyData.Offers[2]);
			data.Add(DummyData.Offers[4]);
			listView.ItemsSource = data;

			listView.ItemTapped += ListView_ItemTapped;
            listView.ItemTapped += ResetListViewSelection;
			
		}

        private void ResetListViewSelection(object sender, ItemTappedEventArgs e)
        {
            (sender as ListView).SelectedItem = null;
        }

        private void ListView_ItemTapped(object sender, ItemTappedEventArgs e)
		{
			OfferData data = e.Item as OfferData;
			Navigation.PushAsync(new ContentPage { Title = data.Title + " @ " + data.Business });
		}
	}
}