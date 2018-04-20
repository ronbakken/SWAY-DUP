/*

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Text;

using Xamarin.Forms;

using SkiaSharp;
using SkiaSharp.Views.Forms;

namespace InfX
{
	class SkiaTagChip : ContentView
	{
		SkiaTagChip()
		{
			HeightRequest = Sizes.ChipHeight;
			MinimumHeightRequest = Sizes.ChipHeight;

			MinimumWidthRequest = MinimumHeightRequest;

			SKCanvasView canvasView = new SKCanvasView();
			canvasView.PaintSurface += CanvasView_PaintSurface; ;
			Content = canvasView;
		}

		SKPaint chipPaint = new SKPaint {
			Style = SKPaintStyle.Fill,
			Color = Palette.ButtonBackground.ToSKColor(),
		};

		SKPaint iconPaint = new SKPaint {
			Style = SKPaintStyle.Fill,
			Color = Palette.TextSecondary.ToSKColor(),
		};

		Label text = new Label {
			VerticalOptions = LayoutOptions.CenterAndExpand,
			VerticalTextAlignment = TextAlignment.Center,
			HorizontalOptions = LayoutOptions.CenterAndExpand,
			HorizontalTextAlignment = TextAlignment.Center,
			TextColor = Palette.TextPrimary
		};

		public Color TextColor
		{
			set
			{
				text.TextColor = value;
			}
			get
			{
				return text.TextColor;
			}
		}

		private void CanvasView_PaintSurface(object sender, SKPaintSurfaceEventArgs e)
		{
			SKImageInfo info = e.Info;
			SKSurface surface = e.Surface;
			SKCanvas canvas = surface.Canvas;
			int h = info.Height, w = info.Width;

			canvas.Clear();

			double density = (double)info.Height / Height;
			float fdensity = (float)density;

			int dp24 = (int)(24 * density);

			canvas.Clear();
			
			canvas.DrawRoundRect(0, 0, w, h, h / 2, h / 2, chipPaint);
			canvas.Scale((float)density, fdensity, w - dp24 - ((h - dp24) / 2), (h - dp24) / 2);
			canvas.DrawPath(SvgSkiaResources.RemoveCirle24, iconPaint);
		}
	}
}

/ * end of file */

