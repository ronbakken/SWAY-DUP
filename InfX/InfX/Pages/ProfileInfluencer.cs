using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using Xamarin.Forms;
using ImageCircle.Forms.Plugin.Abstractions;
using Xamarin.Forms.PlatformConfiguration.AndroidSpecific;

namespace InfX
{
	// TODO: Edit button when 'me'

    class ProfileInfluencer : ContentPage
	{
		ProfileInfluencerData data;
		bool me;
		bool edit;

		Image image;

		ActivityIndicator activityIndicator;

		Label fullName;
		Label location;
		Image avatar;

		Label description;
		SocialFollowCounters followers;
		TagList tags;
		
		public ProfileInfluencer(ProfileInfluencerData data, bool me)
		{
			this.data = data;
			this.me = me;

			Title = me ? "My Profile" : data.FullName;

			image = new Image {
				HorizontalOptions = LayoutOptions.FillAndExpand,
				VerticalOptions = LayoutOptions.Start,
				HeightRequest = Sizes.ElementLarge,
				Aspect = Aspect.AspectFill,
				Source = "placeholder.png",
			};
			image.PropertyChanged += imageLoadingChanged;

			activityIndicator = new ActivityIndicator {
				HorizontalOptions = LayoutOptions.End,
				VerticalOptions = LayoutOptions.Center,
				HeightRequest = Sizes.AvatarSmall,
				WidthRequest = Sizes.AvatarSmall,
				Color = Palette.Secondary,
				IsRunning = true,
			};

			fullName = new Label {
				Text = data.FullName,
				TextColor = Palette.PrimaryText,
				FontSize = Device.GetNamedSize(NamedSize.Medium, typeof(Label)),
				HorizontalOptions = LayoutOptions.StartAndExpand,
				VerticalOptions = LayoutOptions.Start,
			};
			location = new Label {
				Text = data.Location,
				TextColor = Palette.PrimaryText,
				FontSize = Device.GetNamedSize(NamedSize.Micro, typeof(Label)),
				HorizontalOptions = LayoutOptions.StartAndExpand,
				VerticalOptions = LayoutOptions.StartAndExpand,
			};

			avatar = new CircleImage {
				HorizontalOptions = LayoutOptions.Start,
				VerticalOptions = LayoutOptions.Center,
				HeightRequest = Sizes.AvatarLarge,
				WidthRequest = Sizes.AvatarLarge,
				Aspect = Aspect.AspectFill,
				BorderColor = new Color(
						Palette.Primary.R * (1.0 - Palette.PrimaryText.A) + Palette.PrimaryText.R * Palette.PrimaryText.A,
						Palette.Primary.G * (1.0 - Palette.PrimaryText.A) + Palette.PrimaryText.G * Palette.PrimaryText.A,
						Palette.Primary.B * (1.0 - Palette.PrimaryText.A) + Palette.PrimaryText.B * Palette.PrimaryText.A),
				BorderThickness = 1.0f,
				Source = "placeholder.png",
			};
			avatar.PropertyChanged += imageLoadingChanged;

			description = new Label {
				Text = data.Description,
				HorizontalOptions = LayoutOptions.StartAndExpand,
				VerticalOptions = LayoutOptions.Start,
				TextColor = Palette.TextPrimary,
			};

			followers = new SocialFollowCounters();
			tags = new TagList {
				ReadOnly = true
			};

			UpdateData();

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
										fullName,
										location,
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
								followers,
								tags
							},
						},
					},
				},
			};
		}

		public void UpdateData()
		{
			if (!me)
				Title = data.FullName;

			if (data.ImageUrls.Length > 0)
				image.Source = data.ImageUrls[0];

			fullName.Text = data.FullName;
			location.Text = data.Location;

			avatar.Source = data.AvatarUrl;

			description.Text = data.Description;

			followers.UpdateCounters(data.Followers);

			tags.Tags = data.Tags;
		}

		private void imageLoadingChanged(object sender, System.ComponentModel.PropertyChangedEventArgs e)
		{
			if (e.PropertyName == "IsLoading")
				updateActivity();
		}

		void updateActivity()
		{
			activityIndicator.IsRunning = image.IsLoading && avatar.IsLoading;
		}
	}
}

/* end of file */
