using System;
using System.Collections.Generic;
using System.Text;

using Xamarin.Forms;

namespace InfX
{
    class TagChip : ContentView
	{
		public TagChip()
		{
			HorizontalOptions = LayoutOptions.Start;
			VerticalOptions = LayoutOptions.Start;

			HeightRequest = Sizes.ChipHeight;
			MinimumHeightRequest = Sizes.ChipHeight;

			MinimumWidthRequest = MinimumHeightRequest;

			Margin = new Thickness(0.0);
			Padding = new Thickness(0.0);
			// Spacing = Sizes.MarginEdge;

			text = new Label {
				TextColor = Palette.TextPrimary,
				HorizontalOptions = LayoutOptions.CenterAndExpand,
				VerticalOptions = LayoutOptions.CenterAndExpand,
				HorizontalTextAlignment = TextAlignment.Center,
				VerticalTextAlignment = TextAlignment.Center,
			};

			removable = new Plugin.Iconize.IconButton {
				Text = "fa-times-circle",
				TextColor = Palette.TextSecondary,
				FontSize = Sizes.Icon,
				WidthRequest = Sizes.Icon,
				HeightRequest = Sizes.Icon,
				HorizontalOptions = LayoutOptions.EndAndExpand,
				VerticalOptions = LayoutOptions.CenterAndExpand,
			};

			RoundedBoxView.Forms.Plugin.Abstractions.RoundedBoxView boxView = new RoundedBoxView.Forms.Plugin.Abstractions.RoundedBoxView {
				CornerRadius = Sizes.ChipHeight * 0.5,
				BackgroundColor = Palette.ButtonBackground,
				HeightRequest = Sizes.ChipHeight,
				HorizontalOptions = LayoutOptions.Fill,
				VerticalOptions = LayoutOptions.Start,
			};

			layout = new StackLayout {
				HorizontalOptions = LayoutOptions.FillAndExpand,
				VerticalOptions = LayoutOptions.StartAndExpand,
				HeightRequest = Sizes.ChipHeight,
				Margin = new Thickness(0.0),
				Padding = new Thickness(0.0),
				Spacing = Sizes.MarginText,
				Children = { text, removable },
			};

			StackLayout overlayer = new StackLayout {
				HorizontalOptions = LayoutOptions.FillAndExpand,
				VerticalOptions = LayoutOptions.FillAndExpand,
				HeightRequest = Sizes.ChipHeight,
				Margin = new Thickness(0.0),
				Padding = new Thickness(0.0),
				Spacing = -Sizes.ChipHeight,
				Children = { boxView, layout },
			};

			recalculate();

			// Content = ...;

			removable.Clicked += Removable_Clicked;
		}

		private void Removable_Clicked(object sender, EventArgs e)
		{
			RemoveClicked(this, e);
		}

		public event EventHandler RemoveClicked;

		StackLayout layout;

		void recalculate()
		{
			layout.Padding = removable.IsVisible
				? new Thickness(12.0, 0.0, 4.0, 0.0)
				: new Thickness(12.0, 0.0, 12.0, 0.0);
		}

		Plugin.Iconize.IconButton removable;
		public bool Removable { get { return removable.IsVisible; } set { if (removable.IsVisible != value) { removable.IsVisible = value; recalculate(); } } }

		Label text;
		public string Text { get { return text.Text; } set { text.Text = value; } }
	}
}
