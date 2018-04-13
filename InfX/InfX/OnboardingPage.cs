using System;
using System.Collections.Generic;
using System.Linq;
using System.Resources;
using System.Text;
using System.Threading.Tasks;
using Xamarin.Forms;

namespace InfX
{
	public class OnboardingLabel : Label
	{
		public OnboardingLabel()
		{
			TextColor = Palette.PrimaryText;
			HorizontalOptions = LayoutOptions.Center;
		}
	}

	public class OnboardingPage : ContentPage
	{
		Label title;
		Label step;
		Label hi;
		Label selectType;
		Button selectInfluencer;
		Button selectBusiness;

		public OnboardingPage()
		{
			Title = AppResources.OnboardingTitle;
			// BackgroundColor = Palette.BackgroundInverse;
			
			title = new OnboardingLabel {
				Text = AppResources.OnboardingTitle.ToUpper(),
				Opacity = .0,
				FontSize = Device.GetNamedSize(NamedSize.Medium, typeof(Label)) * 1.0,
				FontAttributes = FontAttributes.Bold,
			};
			step = new OnboardingLabel {
				Text = AppResources.OnboardingStep1,
				Opacity = .0,
				FontSize = Device.GetNamedSize(NamedSize.Medium, typeof(Label)) * 2.0
			};
			hi = new OnboardingLabel {
				Text = AppResources.OnboardingHi,
				Opacity = .0,
				FontSize = Device.GetNamedSize(NamedSize.Medium, typeof(Label)) * 1.25,
			};
			selectType = new OnboardingLabel {
				Text = AppResources.OnboardingSelectType,
				Opacity = .0,
				FontSize = Device.GetNamedSize(NamedSize.Medium, typeof(Label)) * 1.25,
			};
			selectInfluencer = new OnboardingButton {
				Text = AppResources.OnboardingSelectInfluencer.ToUpper(),
				Opacity = .0,
			};
			selectBusiness = new OnboardingButton {
				Text = AppResources.OnboardingSelectBusiness.ToUpper(),
				Opacity = .0,
			};
			Content = new StackLayout {
				// Opacity = .0,
				BackgroundColor = Palette.Primary,
				VerticalOptions = LayoutOptions.FillAndExpand,
				HorizontalOptions = LayoutOptions.FillAndExpand,
				// Margin = new Thickness(Device.GetNamedSize(NamedSize.Medium, typeof(Thickness))),
				Padding = new Thickness(Device.GetNamedSize(NamedSize.Medium, typeof(Thickness))),
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
			Appearing += OnboardingPage_Appearing;
			selectInfluencer.Clicked += SelectInfluencer_Clicked;
			selectBusiness.Clicked += SelectBusiness_Clicked;
		}

		private void SelectBusiness_Clicked(object sender, EventArgs e)
		{
			/*Application.Current.OnboardingPage.?*/
			// Navigation.PushAsync(new OnboardingPage());
		}

		private void SelectInfluencer_Clicked(object sender, EventArgs e)
		{
			Device.BeginInvokeOnMainThread(async () => {
				InputTransparent = true;
				BackgroundColor = Palette.MapBackground;
				Page next = (Application.Current as App).PrepareInfluencerMain();
				await Content.FadeTo(0.0, 1500);
				Application.Current.MainPage = next;
			});
		}

		private void OnboardingPage_Appearing(object sender, EventArgs e)
		{
			Appearing -= OnboardingPage_Appearing;
			Device.BeginInvokeOnMainThread(async () => {
				InputTransparent = true;
                await hi.FadeTo(1.0, 2000);
                await selectType.FadeTo(1.0, 2000);
				var titleFade = title.FadeTo(1.0, 1000);
				var stepFade = step.FadeTo(1.0, 1000);
				await selectInfluencer.FadeTo(1.0, 250);
				await selectBusiness.FadeTo(1.0, 250);
				InputTransparent = false;
				await titleFade;
				await stepFade;
			});
		}
	}
}
 