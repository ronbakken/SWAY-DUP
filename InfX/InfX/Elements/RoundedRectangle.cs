/*

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Text;

using Xamarin.Forms;

using SkiaSharp;
using SkiaSharp.Views.Forms;
using System.Runtime.CompilerServices;

namespace InfX
{
	class RoundedRectangle : ContentView
	{
		SKCanvasView canvasView;
		SKPaint backgroundPaint;

		// SKPaint tapPaint;

		RoundedRectangle()
		{
			backgroundPaint = new SKPaint {
				Style = SKPaintStyle.Fill,
				Color = BackgroundColor.ToSKColor(),
			};

			/ *
			tapPaint = new SKPaint {
				Style = SKPaintStyle.Fill,
				Color = BackgroundColor.ToSKColor(),
			};
			* /

			canvasView = new SKCanvasView();
			canvasView.PaintSurface += CanvasView_PaintSurface;
			Content = canvasView;
		}

		/ *
		public Color TapColor
		{
			get
			{
				return tapPaint.Color.ToFormsColor();
			}
			set
			{
				tapPaint.Color = value.ToSKColor();
			}
		}
		* /

		private void CanvasView_PaintSurface(object sender, SKPaintSurfaceEventArgs e)
		{
			SKImageInfo info = e.Info;
			SKSurface surface = e.Surface;
			SKCanvas canvas = surface.Canvas;
			int h = info.Height, w = info.Width;

			// canvas.Clear();

			// double density = (double)info.Height / Height;
			// float fdensity = (float)density;

			// int dp24 = (int)(24 * density);

			canvas.Clear();
			canvas.DrawRoundRect(0, 0, w, h, h / 2, h / 2, backgroundPaint);
		}

		protected override void OnPropertyChanged([CallerMemberName] string propertyName = null)
		{
			base.OnPropertyChanged(propertyName);
			backgroundPaint.Color = BackgroundColor.ToSKColor();
			canvasView.InvalidateSurface();
		}
	}
}

/ * end of file */
