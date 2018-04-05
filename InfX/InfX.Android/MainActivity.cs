using System;

using Android.App;
using Android.Content.PM;
using Android.Runtime;
using Android.Views;
using Android.Widget;
using Android.OS;
using Android.Support.V4.Content;

namespace InfX.Droid
{
	[Activity(Label = "INF", Icon = "@drawable/icon", Theme = "@style/MainTheme", ConfigurationChanges = ConfigChanges.ScreenSize | ConfigChanges.Orientation)]
	public class MainActivity : global::Xamarin.Forms.Platform.Android.FormsAppCompatActivity
	{
		protected override void OnCreate(Bundle bundle)
		{
			TabLayoutResource = Resource.Layout.Tabbar;
			ToolbarResource = Resource.Layout.Toolbar;

			base.OnCreate(bundle);

			global::Xamarin.FormsMaps.Init(this, bundle);
			global::Xamarin.Forms.Forms.Init(this, bundle);

			Plugin.Iconize.Iconize.Init(Resource.Id.toolbar, Resource.Id.sliding_tabs);

			Plugin.Iconize.Iconize.With(new Plugin.Iconize.Fonts.FontAwesomeModule());

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
			Palette.MapBackground = Xamarin.Forms.Color.FromUint((uint)ContextCompat.GetColor(this,
				Resource.Color.mapBackgroundColor));
			Palette.Foreground = Xamarin.Forms.Color.FromUint((uint)ContextCompat.GetColor(this,
				Resource.Color.foreground_material_light));
			Palette.ForegroundInverse = Xamarin.Forms.Color.FromUint((uint)ContextCompat.GetColor(this,
				Resource.Color.foreground_material_dark));
			Palette.Background = Xamarin.Forms.Color.FromUint((uint)ContextCompat.GetColor(this,
				Resource.Color.background_material_light));
			Palette.BackgroundInverse = Xamarin.Forms.Color.FromUint((uint)ContextCompat.GetColor(this,
				Resource.Color.background_material_dark));

			LoadApplication(new App());
		}
	}
}

