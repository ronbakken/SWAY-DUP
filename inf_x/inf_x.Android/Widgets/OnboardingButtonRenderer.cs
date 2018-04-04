using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;

using Android.App;
using Android.Content;
using Android.Graphics.Drawables;
using Android.OS;
using Android.Runtime;
using Android.Util;
using Android.Views;

using Xamarin.Forms;
using Xamarin.Forms.Platform.Android;

[assembly: ExportRenderer(typeof(infx.OnboardingButton), typeof(infx.Droid.OnboardingButtonRenderer))]
namespace infx.Droid
{
	public class OnboardingButtonRenderer : ButtonRenderer
	{
		public OnboardingButtonRenderer(Context context) : base(context)
		{

		}

		private GradientDrawable _normal, _pressed;

		protected override void OnElementChanged(ElementChangedEventArgs<Xamarin.Forms.Button> e)
		{
			base.OnElementChanged(e);

			if (Control != null)
			{
				var button = (OnboardingButton)e.NewElement;

				button.SizeChanged += (s, args) => {
					var radius = (float)Math.Min(button.Width, button.Height);

					// Create a drawable for the button's normal state
					_normal = new Android.Graphics.Drawables.GradientDrawable();
					if (button.BackgroundColor != Color.Default)
						_normal.SetColor(button.BackgroundColor.ToAndroid());
					_normal.SetCornerRadius(radius);
					if (button.BorderColor != Color.Default)
						_normal.SetStroke((int)button.BorderWidth, button.BorderColor.ToAndroid());

					// Create a drawable for the button's pressed state
					_pressed = new Android.Graphics.Drawables.GradientDrawable();
					// var highlight = Context.ObtainStyledAttributes(new int[] { Android.Resource.Attribute.ColorActivatedHighlight }).GetColor(0, Android.Graphics.Color.Gray);
					//if (button.TextColor != Color.Default)
					//	_pressed.SetColor(button.TextColor.MultiplyAlpha(0.5).ToAndroid());
					//_pressed.SetColor(Palette.SecondaryDark.ToAndroid());
					_pressed.SetColor(Palette.PrimaryLight.ToAndroid());
					_pressed.SetCornerRadius(radius);
					if (button.BorderColor != Color.Default)
						_pressed.SetStroke((int)button.BorderWidth, button.BorderColor.ToAndroid());

					// Add the drawables to a state list and assign the state list to the button
					var sld = new StateListDrawable();
					sld.AddState(new int[] { Android.Resource.Attribute.StatePressed }, _pressed);
					sld.AddState(new int[] { }, _normal);
					Control.SetBackground(sld);
				};
			}
		}
	}
}
