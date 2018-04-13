using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xamarin.Forms;
using Xamarin.Forms.Maps;

namespace InfX
{
	public class InfluencerMain : ContentPage
	{
		CustomMap map;

		public InfluencerMain ()
		{
			Title = "INF";
			NavigationPage.SetHasNavigationBar(this, false);

			DashboardButton offers = new DashboardButton {
				Text = "fa-bullhorn",
			};

			DashboardButton profile = new DashboardButton {
				Text = "fa-user",
			};

			DashboardButton filter = new DashboardButton {
				Text = "fa-filter",
			};

			SearchBar searchBar = new SearchBar {
				Placeholder = AppResources.SearchPlaceholder,
			};

			RelativeLayout layout = new RelativeLayout {
			};

			map = new CustomMap {
				MapType = MapType.Street
			};

			layout.Children.Add(map,
				Constraint.Constant(0),
				Constraint.Constant(0),
				Constraint.RelativeToParent((parent) => {
					return parent.Width;
				}), Constraint.RelativeToParent((parent) => {
					return parent.Height;
				}));

			layout.Children.Add(offers,
				Constraint.RelativeToView(map, (parent, sibling) => {
					return sibling.X + 10;
				}),
				Constraint.RelativeToView(map, (parent, sibling) => {
					return sibling.Y + 10;
				}),
				Constraint.Constant(50),
				Constraint.Constant(50));

			layout.Children.Add(searchBar,
				Constraint.RelativeToView(map, (parent, sibling) => {
					return sibling.X + 50;
				}),
				Constraint.RelativeToView(map, (parent, sibling) => {
					return sibling.Y + 10;
				}),
				Constraint.RelativeToView(map, (parent, sibling) => {
					return sibling.Width - 160;
				}),
				Constraint.Constant(50));

			layout.Children.Add(filter,
				Constraint.RelativeToView(map, (parent, sibling) => {
					return sibling.X + sibling.Width - 110;
				}),
				Constraint.RelativeToView(map, (parent, sibling) => {
					return sibling.Y + 10;
				}),
				Constraint.Constant(50),
				Constraint.Constant(50));

			layout.Children.Add(profile,
				Constraint.RelativeToView(map, (parent, sibling) => {
					return sibling.X + sibling.Width - 60;
				}),
				Constraint.RelativeToView(map, (parent, sibling) => {
					return sibling.Y + 10;
				}),
				Constraint.Constant(50),
				Constraint.Constant(50));

			Content = layout;
			Appearing += InfluencerMain_Appearing;

			offers.Clicked += Offers_Clicked;
		}

		private void Offers_Clicked(object sender, EventArgs e)
		{
			Device.BeginInvokeOnMainThread(() => {
				Navigation.PushAsync(new InfluencerOffers());
			});
		}

		private void InfluencerMain_Appearing(object sender, EventArgs e)
		{
			Appearing -= InfluencerMain_Appearing;
		}
	}
}