using System;
using System.Collections.Generic;
using System.Text;

using Xamarin.Forms;

namespace InfX
{
	static public class Palette
	{
		// Do not edit values here.
		// This is loaded from colors.xml and styles.xml on Android
		public static Color Primary = Color.FromRgb(0x59, 0x63, 0x56);
		public static Color PrimaryLight = Color.FromRgb(0x86, 0x90, 0x83);
		public static Color PrimaryDark = Color.FromRgb(0x30, 0x39, 0x2d);
		public static Color Secondary = Color.FromRgb(0xff, 0xc4, 0x00);
		public static Color SecondaryLight = Color.FromRgb(0xff, 0xf6, 0x4f);
		public static Color SecondaryDark = Color.FromRgb(0xc7, 0x94, 0x00);
		public static Color PrimaryText = Color.FromRgb(0xff, 0xff, 0xff);
		public static Color SecondaryText = Color.FromRgb(0x00, 0x00, 0x00);
		public static Color MapBackground = Color.FromRgb(0xEC, 0xE9, 0xE1);
		public static Color Foreground = Color.Black;
		public static Color ForegroundInverse = Color.White;
		public static Color Background = Color.White;
		public static Color BackgroundInverse = Color.Black;
		public static Color TextPrimary = Color.FromRgb(0x80, 0x80, 0x80);
		public static Color TextSecondary = Color.FromRgb(0x80, 0x80, 0x80);
		public static Color ButtonBackground = Color.FromRgb(0xD6, 0xD6, 0xD6);
	}

	static public class Sizes
	{
		// Material
		// https://material.io/guidelines/layout/metrics-keylines.html
		public static double MarginEdge = 16;
		public static double MarginElement = 8;
		public static double MarginText = 4;
		public static double AvatarSmall = 32;
		public static double AvatarMedium = 40;
		public static double AvatarLarge = 64;
		public static double ElementLarge = 160;
		public static double Icon = 24;
		public static double IconTarget = 48;
		public static double ChipHeight = 32;
	}
}
