using System;
using System.Collections.Generic;
using System.Text;

using Xamarin.Forms;

namespace infx
{
	public class OnboardingButton : Button
	{
		public OnboardingButton()
		{
			BackgroundColor = Palette.PrimaryDark;
			BorderColor = Palette.Secondary;
			TextColor = Palette.PrimaryText;
			BorderWidth = 2.0; // remove to remove border :)
		}
	}
}
