﻿using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;

using Foundation;
using UIKit;

using Xamarin.Forms;
using Xamarin.Forms.Platform.iOS;

[assembly: ExportRenderer(typeof(infx.RoundedButton), typeof(infx.iOS.RoundedButtonRenderer))]
namespace infx.iOS
{
	public class RoundedButtonRenderer : ButtonRenderer
	{
		protected override void OnElementChanged(ElementChangedEventArgs<Button> e)
		{
			base.OnElementChanged(e);

			if (Control != null)
			{
				var button = (RoundedButton)e.NewElement;

				button.SizeChanged += (s, args) => {
					var radius = Math.Min(button.Width, button.Height) / 2.0;
					button.BorderRadius = (int)(radius);
				};
			}
		}
	}
}
