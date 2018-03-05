using System;
using System.Collections.Generic;
using System.Text;

using Xamarin.Forms;
using Plugin.Iconize;

namespace infx
{
    class DashboardButton : IconButton
	{
		public DashboardButton()
		{
			TextColor = Palette.Primary;
			FontSize = Device.GetNamedSize(NamedSize.Large, typeof(Button));
		}
	}
}
