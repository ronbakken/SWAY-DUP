using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xamarin.Forms;

namespace InfX
{
	public partial class App : Application
	{
		public App ()
		{
			InitializeComponent();
			MainPage = PrepareOnboarding();
		}

		protected override void OnStart ()
		{
			// Handle when your app starts
		}

		protected override void OnSleep ()
		{
			// Handle when your app sleeps
		}

		protected override void OnResume ()
		{
			// Handle when your app resumes
		}

		public Page PrepareOnboarding()
		{
			return new OnboardingPage();
		}

		public Page PrepareInfluencerMain()
		{
			InfluencerMain main = new InfluencerMain();
			NavigationPage next = new NavigationPage(main) {
				BackgroundColor = Palette.MapBackground,
			};
			Device.BeginInvokeOnMainThread(async () => {
				await Task.Delay(5000);
				next.BackgroundColor = Color.Default;
			});
			return next;
		}
	}
}
