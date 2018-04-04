using System;

using Android.App;
using Android.Content.PM;
using Android.Runtime;
using Android.Views;
using Android.Widget;
using Android.OS;
using Android.Support.V4.Content;
using Android.Support.V7.App;
using Android.Util;
using System.Threading.Tasks;
using Android.Content;

namespace infx.Droid
{
	[Activity(Theme = "@style/MainTheme.Splash", MainLauncher = true, NoHistory = true)]
	public class SplashActivity : AppCompatActivity
	{
		static readonly string TAG = "X:" + typeof(SplashActivity).Name;

		public override void OnCreate(Bundle savedInstanceState, PersistableBundle persistentState)
		{
			base.OnCreate(savedInstanceState, persistentState);
		}
		
		protected override void OnResume()
		{
			base.OnResume();
			Task startupWork = new Task(() => { Startup(); });
			startupWork.Start();
		}
		
		void Startup()
		{
			StartActivity(new Intent(Application.Context, typeof(MainActivity)));
		}
	}
}