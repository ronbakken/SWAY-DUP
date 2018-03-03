using System;
using System.Collections.Generic;
using System.Text;

using Xamarin.Forms;

namespace infx
{
	public class RoundedButton : Button
	{
		public RoundedButton()
		{
			BackgroundColor = new Color(1.0, 1.0, 1.0, .0);
			BorderColor = Palette.Primary;
			TextColor = Palette.Primary;
			BorderWidth = 2.0;
		}
	}
}
