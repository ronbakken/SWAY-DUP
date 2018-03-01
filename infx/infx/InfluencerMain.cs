using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using Xamarin.Forms;
// using Xamarin.FormsMaps;

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
			Content = new StackLayout {
				Children = {
					testButton,
				}
			};
			testButton.Clicked += TestButton_Clicked;
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