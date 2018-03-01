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
		Label step;
		Label hi;
		Label selectType;
		Button selectInfluencer;
		Button selectBusiness;

		public MainPage()
		{
			title = new Label {
				Text = AppResources.OnboardingTitle.ToUpper(),
				Opacity = .0,
				TextColor = Palette.AccentColor,
				HorizontalOptions = LayoutOptions.Center,
				FontSize = Device.GetNamedSize(NamedSize.Medium, typeof(Label)) * 1.0,
				FontAttributes = FontAttributes.Bold,
			};
			step = new Label {
				Text = AppResources.OnboardingStep1,
				Opacity = .0,
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
			selectInfluencer = new RoundedButton {
				Text = AppResources.OnboardingSelectInfluencer.ToUpper(),
				Opacity = .0,
			};
			selectBusiness = new RoundedButton {
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
							step,
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
				var titleFade = title.FadeTo(1.0, 1000);
				var stepFade = step.FadeTo(1.0, 1000);
				await selectInfluencer.FadeTo(1.0, 250);
				await selectBusiness.FadeTo(1.0, 250);
				await titleFade;
				await stepFade;
			});
		}
	}
}