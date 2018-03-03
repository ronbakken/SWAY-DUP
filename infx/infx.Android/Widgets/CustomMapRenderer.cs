using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;

using Android.App;
using Android.Content;
using Android.Gms.Maps;
using Android.Graphics.Drawables;
using Android.OS;
using Android.Runtime;
using Android.Util;
using Android.Views;

using Xamarin.Forms;
using Xamarin.Forms.Maps;
using Xamarin.Forms.Maps.Android;
using Xamarin.Forms.Platform.Android;

[assembly: ExportRenderer(typeof(infx.CustomMap), typeof(infx.Droid.CustomMapRenderer))]
namespace infx.Droid
{
	public class CustomMapRenderer : MapRenderer
	{
		public CustomMapRenderer(Context context) : base(context)
		{
			
		}

		protected override void OnMapReady(GoogleMap map)
		{
			map.UiSettings.ZoomControlsEnabled = false;
			map.UiSettings.MyLocationButtonEnabled = false;
			map.UiSettings.RotateGesturesEnabled = false;
		}
	}
}
