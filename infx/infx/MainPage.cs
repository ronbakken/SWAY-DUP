using System;
using System.Collections.Generic;
using System.Linq;
using System.Resources;
using System.Text;
using System.Threading.Tasks;
using Xamarin.Forms;

namespace infx
{
	public class MainPage : ContentPage
	{
		Label title;
		Label step1;
		Label hi;
		Label selectType;
		Button selectInfluencer;
		Button selectBusiness;

		public MainPage()
		{
			title = new Label {
				Text = AppResources.OnboardingTitle.ToUpper(),
				TextColor = Palette.AccentColor,
				HorizontalOptions = LayoutOptions.Center,
				FontSize = Device.GetNamedSize(NamedSize.Medium, typeof(Label)) * 1.0,
				FontAttributes = FontAttributes.Bold,
			};
			step1 = new Label {
				Text = AppResources.OnboardingStep1,
				TextColor = Palette.AccentColor,
				HorizontalOptions = LayoutOptions.Center,
				FontSize = Device.GetNamedSize(NamedSize.Medium, typeof(Label)) * 2.0
			};
			hi = new Label {
				Text = AppResources.OnboardingHi,
				Opacity = .0,
				TextColor = Palette.AccentColor,
				HorizontalOptions = LayoutOptions.Center,
				FontSize = Device.GetNamedSize(NamedSize.Medium, typeof(Label)) * 1.25,
			};
			selectType = new Label {
				Text = AppResources.OnboardingSelectType,
				Opacity = .0,
				TextColor = Palette.AccentColor,
				HorizontalOptions = LayoutOptions.Center,
				FontSize = Device.GetNamedSize(NamedSize.Medium, typeof(Label)) * 1.25,
			};
			selectInfluencer = new Button {
				Text = AppResources.OnboardingSelectInfluencer.ToUpper(),
				Opacity = .0,
			};
			selectBusiness = new Button {
				Text = AppResources.OnboardingSelectBusiness.ToUpper(),
				Opacity = .0,
			};
			Content = new StackLayout {
				VerticalOptions = LayoutOptions.FillAndExpand,
				HorizontalOptions = LayoutOptions.FillAndExpand,
				Margin = new Thickness(Device.GetNamedSize(NamedSize.Medium, typeof(Thickness))),
				Children = {
					new StackLayout {
						VerticalOptions = LayoutOptions.Start,
						HorizontalOptions = LayoutOptions.FillAndExpand,
						Children = {
							title,
							step1,
						}
					},
					new StackLayout {
						VerticalOptions = LayoutOptions.CenterAndExpand,
						HorizontalOptions = LayoutOptions.FillAndExpand,
						Children = {
							hi,
							selectType
						}
					},
					new StackLayout {
						VerticalOptions = LayoutOptions.CenterAndExpand,
						HorizontalOptions = LayoutOptions.FillAndExpand,
						Children = {
							selectInfluencer,
							selectBusiness,
						}
					},
					new StackLayout {
						VerticalOptions = LayoutOptions.End,
						HorizontalOptions = LayoutOptions.FillAndExpand,
						Children = {
							new Label { Text = "...", HorizontalOptions = LayoutOptions.Center }
						}
					},
				}
			};
			Appearing += MainPage_Appearing;
			
		}

		private void MainPage_Appearing(object sender, EventArgs e)
		{
			Appearing -= MainPage_Appearing;
			Device.BeginInvokeOnMainThread(async () => {
				await hi.FadeTo(1.0, 2000);
				await selectType.FadeTo(1.0, 2000);
				await selectInfluencer.FadeTo(1.0, 250);
				await selectBusiness.FadeTo(1.0, 250);
			});
		}
	}
}