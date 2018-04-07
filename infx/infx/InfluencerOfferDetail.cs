﻿using System;
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

		View IconizedLine(string icon, View content)
		{
			Plugin.Iconize.IconLabel iconLabel = new Plugin.Iconize.IconLabel {
				Text = icon,
				TextColor = Palette.Secondary,
				FontSize = Sizes.Icon,
				WidthRequest = Sizes.Icon,
				// HeightRequest = Sizes.Icon,
				HorizontalOptions = LayoutOptions.Center,
				VerticalOptions = LayoutOptions.CenterAndExpand,
				HorizontalTextAlignment = TextAlignment.Center,
				VerticalTextAlignment = TextAlignment.Center,
			};
			return new StackLayout {
				HorizontalOptions = LayoutOptions.FillAndExpand,
				VerticalOptions = LayoutOptions.Start,
				Margin = new Thickness(0.0),
				Padding = new Thickness(0.0),
				Spacing = Sizes.MarginEdge,
				Orientation = StackOrientation.Horizontal,
				Children = {
					new ContentView {
						HorizontalOptions = LayoutOptions.Start,
						VerticalOptions = LayoutOptions.CenterAndExpand,
						WidthRequest = Sizes.Icon,
						// HeightRequest = Sizes.Icon,
						MinimumWidthRequest = Sizes.Icon,
						MinimumHeightRequest = Sizes.Icon,
						Padding = new Thickness(0.0, 0.0, Sizes.AvatarMedium - Sizes.Icon, 0.0),
						Content = iconLabel,
					},
					content,
				},
			};
		}

		View HelpfulLine(string help, View content)
		{
			Label label = new Label {
				Text = help,
				TextColor = Palette.TextPrimary,
				WidthRequest = Sizes.AvatarMedium,
				MinimumWidthRequest = Sizes.AvatarMedium,
				HorizontalOptions = LayoutOptions.Start,
				VerticalOptions = LayoutOptions.Start,
			};
			return new StackLayout {
				HorizontalOptions = LayoutOptions.FillAndExpand,
				VerticalOptions = LayoutOptions.Start,
				Margin = new Thickness(0.0),
				Padding = new Thickness(0.0),
				Spacing = Sizes.MarginEdge,
				Orientation = StackOrientation.Horizontal,
				Children = {
					label,
					content,
				},
			};
		}

		public InfluencerOfferDetail(InfluencerOfferData offerData)
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
				HorizontalOptions = LayoutOptions.StartAndExpand,
				VerticalOptions = LayoutOptions.Start,
			};
			address = new Label {
				Text = "...",
				TextColor = Palette.PrimaryText, // .MultiplyAlpha(Palette.TextSecondary.A),
				FontSize = Device.GetNamedSize(NamedSize.Micro, typeof(Label)),
				HorizontalOptions = LayoutOptions.StartAndExpand,
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
				HorizontalOptions = LayoutOptions.StartAndExpand,
				VerticalOptions = LayoutOptions.Start,
				TextColor = Palette.TextPrimary,
			};
			deliverables = new Label {
				Text = offerData.Deliverables,
				HorizontalOptions = LayoutOptions.StartAndExpand,
				VerticalOptions = LayoutOptions.Start,
				TextColor = Palette.TextSecondary,
			};
			reward = new Label {
				Text = offerData.Reward,
				HorizontalOptions = LayoutOptions.StartAndExpand,
				VerticalOptions = LayoutOptions.Start,
				TextColor = Palette.TextSecondary,
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
							Spacing = Sizes.MarginEdge,
							Children = {
								description,
								// IconizedLine("fa-truck", deliverables),
								// IconizedLine("fa-gift", reward),
								HelpfulLine("Deliver", deliverables),
								HelpfulLine("Reward", reward),
							},
						},
					},
				},
			};

			SetOfferDataDetail(DummyData.Offers[offerData.Id]);
		}

		public void SetOfferDataDetail(InfluencerOfferDataDetail offerDataDetail)
		{
			address.Text = offerDataDetail.Address;
			avatar.Source = offerDataDetail.AvatarUrl;
			activityIndicator.SetBinding(ActivityIndicator.IsRunningProperty, "IsLoading");
			activityIndicator.BindingContext = avatar;
		}
	}
}