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
			Label deliverables;
			Label reward;
			Image image = null;

			public OfferCell()
			{
				title = new Label {
					Text = "...",
					TextColor = Palette.TextPrimary,
					FontSize = Device.GetNamedSize(NamedSize.Medium, typeof(Label)),
					// FontAttributes = FontAttributes.Bold,
					HorizontalOptions = LayoutOptions.StartAndExpand,
					VerticalOptions = LayoutOptions.StartAndExpand,
					LineBreakMode = LineBreakMode.TailTruncation,
				};
				business = new Label {
					Text = "...",
					// TextColor = Palette.Foreground,
					// FontSize = Device.GetNamedSize(NamedSize.Medium, typeof(Label)),
					// FontAttributes = FontAttributes.Bold,
					HorizontalOptions = LayoutOptions.FillAndExpand,
					VerticalOptions = LayoutOptions.FillAndExpand,
					LineBreakMode = LineBreakMode.TailTruncation,
				};
				deliverables = new Label {
					Text = "..."
				};
				reward = new Label {
					Text = "..."
				};
				image = new CircleImage {
					HorizontalOptions = LayoutOptions.Start,
					VerticalOptions = LayoutOptions.Center,
					HeightRequest = Device.GetNamedSize(NamedSize.Medium, typeof(Label)) * 3.0,
					WidthRequest = Device.GetNamedSize(NamedSize.Medium, typeof(Label)) * 3.0,
					Aspect = Aspect.AspectFill,
					// Margin = new Thickness(Device.GetNamedSize(NamedSize.Medium, typeof(Thickness))),
					BorderColor = new Color(
						Palette.Background.R * (1.0 - Palette.Secondary.A) + Palette.Secondary.R * Palette.Secondary.A,
						Palette.Background.G * (1.0 - Palette.Secondary.A) + Palette.Secondary.G * Palette.Secondary.A,
						Palette.Background.B * (1.0 - Palette.Secondary.A) + Palette.Secondary.B * Palette.Secondary.A),
					BorderThickness = 1.0f,
				};
				View = /* new CardView {
					Content = */ new StackLayout {
						 Margin = new Thickness(Device.GetNamedSize(NamedSize.Micro, typeof(Thickness))),
							//Device.GetNamedSize(NamedSize.Micro, typeof(Thickness)) * 0.5),
						HorizontalOptions = LayoutOptions.FillAndExpand,
						VerticalOptions = LayoutOptions.FillAndExpand,
						Children = {
							new StackLayout {
								// Margin = new Thickness(0.0, Device.GetNamedSize(NamedSize.Micro, typeof(Thickness))),
								HorizontalOptions = LayoutOptions.StartAndExpand,
								VerticalOptions = LayoutOptions.Start,
								Orientation = StackOrientation.Horizontal,
								Children = {
									image,
									new StackLayout {
										Margin = new Thickness(Device.GetNamedSize(NamedSize.Micro, typeof(Thickness)), 0.0),
										HorizontalOptions = LayoutOptions.StartAndExpand,
										VerticalOptions = LayoutOptions.StartAndExpand,
										Children = {
											title,
											business,
										},
									},
								},
							},
							deliverables,
							reward,
						},
					/*},*/
				};
			}

			protected override void OnBindingContextChanged()
			{
				base.OnBindingContextChanged();

				InfluencerOfferData data = BindingContext as InfluencerOfferData;
				if (data != null)
				{
					title.Text = data.Title;
					business.Text = data.Business;
					deliverables.Text = data.Deliverables;
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

			Title = LanguageResources.OffersAppliedTitle;
			Content = new StackLayout {
				HorizontalOptions = LayoutOptions.FillAndExpand,
				VerticalOptions = LayoutOptions.FillAndExpand,
				Children = {
					listView
				}
			};

			List<InfluencerOfferData> data = new List<InfluencerOfferData>();
			data.Add(DummyData.Offers[0]);
			data.Add(DummyData.Offers[2]);
			data.Add(DummyData.Offers[3]);
			listView.ItemsSource = data;

			listView.ItemTapped += ShowOfferDetail;
            listView.ItemTapped += ResetListViewSelection;
			
		}

        private void ResetListViewSelection(object sender, ItemTappedEventArgs e)
        {
            (sender as ListView).SelectedItem = null;
        }

        private void ShowOfferDetail(object sender, ItemTappedEventArgs e)
		{
			InfluencerOfferData data = e.Item as InfluencerOfferData;
			Navigation.PushAsync(new InfluencerOfferDetail(data));
		}
	}
}