using Plugin.Media;
using Plugin.Media.Abstractions;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xamarin.Forms;

namespace InfX
{
	public class BusinessOfferCreate : ContentPage
	{
		Image image;

		public BusinessOfferCreate ()
		{
			Title = "Create Offer";

			Button selectImage = new Button {
				HorizontalOptions = LayoutOptions.FillAndExpand,
				VerticalOptions = LayoutOptions.Start,
				Text = "Select Photo",
				BackgroundColor = Palette.ButtonBackground,
				TextColor = Palette.TextPrimary,
			};

			image = new Image {
				HorizontalOptions = LayoutOptions.FillAndExpand,
				VerticalOptions = LayoutOptions.Start,
				HeightRequest = Sizes.ElementLarge,
				Aspect = Aspect.AspectFill,
				Source = "placeholder.png",
			};

			Content = new StackLayout {
				Margin = new Thickness(0.0),
				Padding = new Thickness(Sizes.MarginEdge),
				Spacing = Sizes.MarginText,
				Children = {
					image,
					selectImage,
				}
			};

			selectImage.Clicked += SelectImage;
		}

		private void SelectImage(object sender, EventArgs e)
		{
			Task<MediaFile> file = CrossMedia.Current.PickPhotoAsync(new PickMediaOptions { });
			// await file;
			/*µùù
			if (!CrossMedia.Current.IsCameraAvailable || !CrossMedia.Current.IsPickPhotoSupported)
			{
				DisplayAlert("No Camera", ":( No camera avaialble.", "OK");
				return;
			}

			var file = await CrossMedia.Current.TakePhotoAsync(new StoreCameraMediaOptions {
				Directory = "Sample",
				Name = "test.jpg"
			});

			if (file == null)
				return;

			DisplayAlert("File Location", file.Path, "OK");
			*/
			/*image.Source = ImageSource.FromStream(() =>
			{
				var stream = file.GetStream();
				file.Dispose();
				return stream;
			});*/
		}
	}
}