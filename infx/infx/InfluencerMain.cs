using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using Xamarin.Forms;
using Xamarin.Forms.Maps;

namespace infx
{
	public class InfluencerMain : ContentPage
	{
		public InfluencerMain ()
		{
			Title = "INF";
			NavigationPage.SetHasNavigationBar(this, false);

			Button testButton = new Button {
				Text = "Hello world",
			};

			RelativeLayout layout = new RelativeLayout();

			layout.Children.Add(new Map(),
				Constraint.Constant(0),
				Constraint.Constant(0),
				Constraint.RelativeToParent((parent) => {
					return parent.Width;
				}), Constraint.RelativeToParent((parent) => {
					return parent.Height;
				}));

			/*
			layout.Children.Add(new StackLayout {
				Children = {
					testButton,
				}
			}, Constraint.Constant(0),
				Constraint.Constant(0),
				Constraint.RelativeToParent((parent) => {
					return parent.Width;
				}), Constraint.RelativeToParent((parent) => {
					return parent.Height;
				}));*/

			testButton.Clicked += TestButton_Clicked;

			Content = layout;
		}

		private void TestButton_Clicked(object sender, EventArgs e)
		{
			Device.BeginInvokeOnMainThread(() => {
				// Application.Current.MainPage = new MainPage();
				Navigation.PushAsync(new ContentPage());
			});
		}
	}
}