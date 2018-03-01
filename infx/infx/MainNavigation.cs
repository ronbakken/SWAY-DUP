using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using Xamarin.Forms;

namespace infx
{
	public class MainNavigation : NavigationPage
	{
		public MainNavigation()
		{
			PushAsync(new MainPage());
		}
	}
}