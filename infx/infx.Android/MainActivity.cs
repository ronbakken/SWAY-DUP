using System;

using Android.App;
using Android.Content.PM;
using Android.Runtime;
using Android.Views;
using Android.Widget;
using Android.OS;
using Android.Support.V4.Content;

namespace infx.Droid
{
	[Activity(Label = "infx", Icon = "@drawable/icon", Theme = "@style/MainTheme", MainLauncher = true, ConfigurationChanges = ConfigChanges.ScreenSize | ConfigChanges.Orientation)]
	public class MainActivity : global::Xamarin.Forms.Platform.Android.FormsAppCompatActivity
	{
		protected override void OnCreate(Bundle bundle)
		{
			TabLayoutResource = Resource.Layout.Tabbar;
			ToolbarResource = Resource.Layout.Toolbar;

			base.OnCreate(bundle);

			Plugin.Iconize.Iconize.With(new Plugin.Iconize.Fonts.FontAwesomeModule());

			global::Xamarin.FormsMaps.Init(this, bundle);
			global::Xamarin.Forms.Forms.Init(this, bundle);

			FormsPlugin.Iconize.Droid.IconControls.Init(Resource.Id.toolbar); //, Resource.Id.tabs);

			Palette.Primary = Xamarin.Forms.Color.FromUint((uint)ContextCompat.GetColor(this,
				Resource.Color.primaryColor));
			Palette.PrimaryLight = Xamarin.Forms.Color.FromUint((uint)ContextCompat.GetColor(this,
				Resource.Color.primaryLightColor));
			Palette.PrimaryDark = Xamarin.Forms.Color.FromUint((uint)ContextCompat.GetColor(this,
				Resource.Color.primaryDarkColor));
			Palette.Secondary = Xamarin.Forms.Color.FromUint((uint)ContextCompat.GetColor(this,
				Resource.Color.secondaryColor));
			Palette.SecondaryLight = Xamarin.Forms.Color.FromUint((uint)ContextCompat.GetColor(this,
				Resource.Color.secondaryLightColor));
			Palette.SecondaryDark = Xamarin.Forms.Color.FromUint((uint)ContextCompat.GetColor(this,
				Resource.Color.secondaryDarkColor));
			Palette.PrimaryText = Xamarin.Forms.Color.FromUint((uint)ContextCompat.GetColor(this,
				Resource.Color.primaryTextColor));
			Palette.SecondaryText = Xamarin.Forms.Color.FromUint((uint)ContextCompat.GetColor(this,
				Resource.Color.secondaryTextColor));
			
			LoadApplication(new App());
		}
	}
}

