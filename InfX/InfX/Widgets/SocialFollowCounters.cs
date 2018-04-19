using System;
using System.Collections.Generic;
using System.Globalization;
using System.Text;

using Xamarin.Forms;

namespace InfX
{
	public class SocialFollowCounter : StackLayout
	{
		Label counter;

		int idx;

		long followers = 0;
		public long Followers
		{
			get
			{
				return followers;
			}
			set
			{
				followers = value;
				if (followers > 1000000000)
					counter.Text = "> 1T";
				else if (followers > 10000000000)
					counter.Text = (followers / 1000).ToString(CultureInfo.InvariantCulture) + "B";
				else if (followers > 1000000000)
					counter.Text = ((double)followers / 1000.0).ToString("0.0", CultureInfo.InvariantCulture) + "B";
				else if (followers > 10000000)
					counter.Text = (followers / 1000).ToString(CultureInfo.InvariantCulture) + "M";
				else if (followers > 1000000)
					counter.Text = ((double)followers / 1000.0).ToString("0.0", CultureInfo.InvariantCulture) + "M";
				else if (followers > 10000)
					counter.Text = (followers / 1000).ToString(CultureInfo.InvariantCulture) + "k";
				else if (followers > 1000)
					counter.Text = ((double)followers / 1000.0).ToString("0.0", CultureInfo.InvariantCulture) + "k";
				else
					counter.Text = followers.ToString(CultureInfo.InvariantCulture);
				IsVisible = SocialPlatformInfo.Static[idx].Enabled && followers > 100;
			}
		}

		public SocialFollowCounter(int idx)
		{
			HorizontalOptions = LayoutOptions.Center;
			VerticalOptions = LayoutOptions.Start;
			Margin = new Thickness(0.0);
			Padding = new Thickness(0.0);
			Spacing = Sizes.MarginText;

			WidthRequest = Sizes.AvatarMedium;
			MinimumWidthRequest = Sizes.AvatarMedium;

			this.idx = idx;
			IsVisible = SocialPlatformInfo.Static[idx].Enabled;
			
			Plugin.Iconize.IconLabel iconLabel = new Plugin.Iconize.IconLabel {
				Text = SocialPlatformInfo.Static[idx].Icon,
				TextColor = Palette.TextSecondary,
				FontSize = Sizes.Icon,
				// WidthRequest = Sizes.Icon,
				// HeightRequest = Sizes.Icon,
				HorizontalOptions = LayoutOptions.CenterAndExpand,
				VerticalOptions = LayoutOptions.Start,
				HorizontalTextAlignment = TextAlignment.Center,
				VerticalTextAlignment = TextAlignment.Center,
			};

			counter = new Label {
				Text = "...",
				HorizontalOptions = LayoutOptions.CenterAndExpand,
				VerticalOptions = LayoutOptions.Start,
				TextColor = Palette.TextPrimary,
			};
		}
	}

	public class SocialFollowCounters : StackLayout
    {
		public SocialFollowCounter[] Entries { get; private set; }

		public SocialFollowCounters()
		{
			HorizontalOptions = LayoutOptions.CenterAndExpand;
			VerticalOptions = LayoutOptions.Start;
			Margin = new Thickness(0.0);
			Padding = new Thickness(0.0);
			Spacing = Sizes.MarginText;

			Orientation = StackOrientation.Horizontal;

			Children.Add(new ContentView {
				HorizontalOptions = LayoutOptions.CenterAndExpand,
				VerticalOptions = LayoutOptions.CenterAndExpand,
			});

			Entries = new SocialFollowCounter[(int)SocialPlatform.Nb];
			for (int i = 0; i < (int)SocialPlatform.Nb; ++i)
			{
				SocialFollowCounter entry = new SocialFollowCounter(i);
				Entries[i] = entry;
				Children.Add(entry);
			}

			Children.Add(new ContentView {
				HorizontalOptions = LayoutOptions.CenterAndExpand,
				VerticalOptions = LayoutOptions.CenterAndExpand,
			});
		}
	}
}
