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
				HeightRequest = 150,
				Aspect = Aspect.AspectFill,
				Source = offerData.ImageUrl
			};

			activityIndicator = new ActivityIndicator {
				HorizontalOptions = LayoutOptions.End,
				VerticalOptions = LayoutOptions.Center,
				HeightRequest = Device.GetNamedSize(NamedSize.Medium, typeof(Label)) * 2.0,
				WidthRequest = Device.GetNamedSize(NamedSize.Medium, typeof(Label)) * 2.0,
				Color = Palette.Secondary,
				IsRunning = true,
			};

			business = new Label {
				Text = offerData.Business,
				// TextColor = Palette.TextPrimary,
				TextColor = Palette.PrimaryText,
				FontSize = Device.GetNamedSize(NamedSize.Medium, typeof(Label)),
				HorizontalOptions = LayoutOptions.FillAndExpand,
				VerticalOptions = LayoutOptions.StartAndExpand,
			};
			address = new Label {
				Text = "...",
				TextColor = Palette.PrimaryText,
				FontSize = Device.GetNamedSize(NamedSize.Micro, typeof(Label)),
				HorizontalOptions = LayoutOptions.FillAndExpand,
				VerticalOptions = LayoutOptions.FillAndExpand,
			};

			avatar = new CircleImage {
				HorizontalOptions = LayoutOptions.Start,
				VerticalOptions = LayoutOptions.Center,
				HeightRequest = Device.GetNamedSize(NamedSize.Medium, typeof(Label)) * 3.0,
				WidthRequest = Device.GetNamedSize(NamedSize.Medium, typeof(Label)) * 3.0,
				Aspect = Aspect.AspectFill,
				BorderColor = new Color(
						Palette.Background.R * (1.0 - Palette.Secondary.A) + Palette.Secondary.R * Palette.Secondary.A,
						Palette.Background.G * (1.0 - Palette.Secondary.A) + Palette.Secondary.G * Palette.Secondary.A,
						Palette.Background.B * (1.0 - Palette.Secondary.A) + Palette.Secondary.B * Palette.Secondary.A),
				BorderThickness = 1.0f,
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
						Padding = new Thickness(Device.GetNamedSize(NamedSize.Small, typeof(Thickness))),
						Spacing = Device.GetNamedSize(NamedSize.Small, typeof(Thickness)),
						Orientation = StackOrientation.Horizontal,
						Children = {
							avatar,
							new StackLayout {
								HorizontalOptions = LayoutOptions.FillAndExpand,
								VerticalOptions = LayoutOptions.FillAndExpand,
								BackgroundColor = Palette.PrimaryLight,
								Margin = new Thickness(0.0),
								Padding = new Thickness(0.0),
								Spacing = 0.0,
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
						Padding = new Thickness(Device.GetNamedSize(NamedSize.Small, typeof(Thickness))),
						Spacing = Device.GetNamedSize(NamedSize.Micro, typeof(Thickness)) * 0.5,
						Children = {
							description,
							deliverables,
							reward
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