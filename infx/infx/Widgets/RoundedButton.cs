using System;
using System.Collections.Generic;
using System.Text;

using Xamarin.Forms;
using Telerik.XamarinForms.Input;

namespace infx
{
	public class RoundedButton : RadButton
	{
		public RoundedButton()
		{
			BackgroundColor = new Color(1.0, 1.0, 1.0, 1.0);
			BorderColor = Palette.Primary;
			TextColor = Palette.Primary;
			SizeChanged += RoundedButton_SizeChanged;
			BorderWidth = Height * 0.05;
			CornerRadius = (int)(Height * 0.5);
			
		}

		private void RoundedButton_SizeChanged(object sender, EventArgs e)
		{
			BorderWidth = Height * 0.05;
			CornerRadius = (int)(Height * 0.5);
		}
	}
}
