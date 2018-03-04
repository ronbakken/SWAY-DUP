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
		CustomMap map;

		public InfluencerMain ()
		{
			Title = "INF";
			NavigationPage.SetHasNavigationBar(this, false);

			Button profile = new OnboardingButton {
				Text = "PROFILE",
			};

			Button testButton = new Button {
				Text = "TEST",
			};

			RelativeLayout layout = new RelativeLayout();

			map = new CustomMap {
				MapType = MapType.Street
			};

			layout.Children.Add(map,
				Constraint.Constant(0),
				Constraint.Constant(0),
				Constraint.RelativeToParent((parent) => {
					return parent.Width;
				}), Constraint.RelativeToParent((parent) => {
					return parent.Height;
				}));

			layout.Children.Add(profile,
				Constraint.RelativeToView(map, (parent, sibling) => {
					return sibling.Width - 150;
				}),
				Constraint.RelativeToView(map, (parent, sibling) => {
					return sibling.Height - 150;
				}),
				Constraint.Constant(100),
				Constraint.Constant(100));
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

			Content = layout;
		}

		private void TestButton_Clicked(object sender, EventArgs e)
		{
			Device.BeginInvokeOnMainThread(() => {
				// Application.Current.OnboardingPage = new OnboardingPage();
				Navigation.PushAsync(new ContentPage());
			});
		}
	}
}