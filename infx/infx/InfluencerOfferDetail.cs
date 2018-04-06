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

		Label business;
		Label address;
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
			
			business = new Label {
				Text = offerData.Business,
				// TextColor = Palette.TextPrimary,
				TextColor = Palette.PrimaryText,
				FontSize = Device.GetNamedSize(NamedSize.Medium, typeof(Label)),
				HorizontalOptions = LayoutOptions.FillAndExpand,
				VerticalOptions = LayoutOptions.Start,
			};
			address = new Label {
				Text = "...",
				TextColor = Palette.PrimaryText,
				FontSize = Device.GetNamedSize(NamedSize.Micro, typeof(Label)),
				HorizontalOptions = LayoutOptions.FillAndExpand,
				VerticalOptions = LayoutOptions.Start,
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
						Padding = new Thickness(Device.GetNamedSize(NamedSize.Small, typeof(Thickness))),
						Spacing = Device.GetNamedSize(NamedSize.Micro, typeof(Thickness)),
						Children = {
							// Plus circle image of business
							business,
							address,
						},
					},
					new StackLayout {
						HorizontalOptions = LayoutOptions.FillAndExpand,
						VerticalOptions = LayoutOptions.StartAndExpand,
						Margin = new Thickness(Device.GetNamedSize(NamedSize.Small, typeof(Thickness))),
						Children = {
							description,
							deliverables,
							reward
						},
					},
				},
			};
		}
	}
}