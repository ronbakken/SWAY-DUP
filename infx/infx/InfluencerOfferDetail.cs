using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using Xamarin.Forms;
using ImageCircle.Forms.Plugin.Abstractions;

namespace InfX
{
	public class InfluencerOfferDetail : ContentPage
	{
		Image image;

		ActivityIndicator activityIndicator;

		Label business;
		Label address;
		Image avatar;

		Label description;
		Label deliverables;
		Label reward;

		public InfluencerOfferDetail(OfferData offerData)
		{
			Title = offerData.Title;

			image = new Image {
				HorizontalOptions = LayoutOptions.FillAndExpand,
				VerticalOptions = LayoutOptions.Start,
				HeightRequest = Sizes.ElementLarge,
				Aspect = Aspect.AspectFill,
				Source = offerData.ImageUrl
			};

			activityIndicator = new ActivityIndicator {
				HorizontalOptions = LayoutOptions.End,
				VerticalOptions = LayoutOptions.Center,
				HeightRequest = Sizes.AvatarSmall,
				WidthRequest = Sizes.AvatarSmall,
				Color = Palette.Secondary,
				IsRunning = true,
			};

			business = new Label {
				Text = offerData.Business,
				// TextColor = Palette.TextPrimary,
				TextColor = Palette.PrimaryText, // .MultiplyAlpha(Palette.TextPrimary.A),
				FontSize = Device.GetNamedSize(NamedSize.Medium, typeof(Label)),
				HorizontalOptions = LayoutOptions.FillAndExpand,
				VerticalOptions = LayoutOptions.Start,
			};
			address = new Label {
				Text = "...",
				TextColor = Palette.PrimaryText, // .MultiplyAlpha(Palette.TextSecondary.A),
				FontSize = Device.GetNamedSize(NamedSize.Micro, typeof(Label)),
				HorizontalOptions = LayoutOptions.FillAndExpand,
				VerticalOptions = LayoutOptions.StartAndExpand,
			};

			avatar = new CircleImage {
				HorizontalOptions = LayoutOptions.Start,
				VerticalOptions = LayoutOptions.Center,
				HeightRequest = Sizes.AvatarMedium, // + 16.0,
				WidthRequest = Sizes.AvatarMedium, // + 16.0,
				Aspect = Aspect.AspectFill,
				BorderColor = new Color(
						Palette.Primary.R * (1.0 - Palette.PrimaryText.A) + Palette.PrimaryText.R * Palette.PrimaryText.A,
						Palette.Primary.G * (1.0 - Palette.PrimaryText.A) + Palette.PrimaryText.G * Palette.PrimaryText.A,
						Palette.Primary.B * (1.0 - Palette.PrimaryText.A) + Palette.PrimaryText.B * Palette.PrimaryText.A),
				BorderThickness = 0.5f,
				/* Margin = new Thickness(-8.0),
				BorderColor = Palette.Primary,
				BorderThickness = 8.0f, */
			};

			description = new Label {
				Text = offerData.Description,
				HorizontalOptions = LayoutOptions.FillAndExpand,
				VerticalOptions = LayoutOptions.Start,
			};
			deliverables = new Label {
				Text = offerData.Deliverables
			};
			reward = new Label {
				Text = offerData.Reward
			};

			Content = new ScrollView {
				HorizontalOptions = LayoutOptions.FillAndExpand,
				VerticalOptions = LayoutOptions.StartAndExpand,
				Content = new StackLayout {
					HorizontalOptions = LayoutOptions.FillAndExpand,
					VerticalOptions = LayoutOptions.StartAndExpand,
					Spacing = 0.0,
					Margin = new Thickness(0.0),
					Padding = new Thickness(0.0),
					Children = {
						image,
						new StackLayout {
							HorizontalOptions = LayoutOptions.FillAndExpand,
							VerticalOptions = LayoutOptions.StartAndExpand,
							BackgroundColor = Palette.PrimaryLight,
							Margin = new Thickness(0.0),
							Padding = new Thickness(Sizes.MarginEdge),
							Spacing = Sizes.MarginEdge,
							Orientation = StackOrientation.Horizontal,
							Children = {
								avatar,
								new StackLayout {
									HorizontalOptions = LayoutOptions.FillAndExpand,
									VerticalOptions = LayoutOptions.FillAndExpand,
									BackgroundColor = Palette.PrimaryLight,
									Margin = new Thickness(0.0),
									Padding = new Thickness(0.0),
									Spacing = Sizes.MarginText,
									Children = {
										business,
										address,
									},
								},
								activityIndicator,
							},
						},
						new StackLayout {
							HorizontalOptions = LayoutOptions.FillAndExpand,
							VerticalOptions = LayoutOptions.StartAndExpand,
							Margin = new Thickness(0.0),
							Padding = new Thickness(Sizes.MarginEdge),
							Spacing = Sizes.MarginText,
							Children = {
								description,
								deliverables,
								reward
							},
						},
					},
				},
			};

			SetOfferDataDetail(DummyData.Offers[offerData.Id]);
		}

		public void SetOfferDataDetail(OfferDataDetail offerDataDetail)
		{
			address.Text = offerDataDetail.Address;
			avatar.Source = offerDataDetail.AvatarUrl;
			activityIndicator.SetBinding(ActivityIndicator.IsRunningProperty, "IsLoading");
			activityIndicator.BindingContext = avatar;
		}
	}
}