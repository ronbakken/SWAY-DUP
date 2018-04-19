using System;
using System.Collections.Generic;
using System.Text;

namespace InfX
{
    /*class SocialMediaEnums
    {
    }*/

	enum SocialPlatform
	{
		None      = 0,

		Twitter   = 1,
		Facebook  = 2,
		Instagram = 3,
		YouTube   = 4,
		Spotify   = 5,

		Nb,
		
	}

	class SocialPlatformInfo
	{
		public bool Enabled;
		public string Name;
		public string Icon;

		public static SocialPlatformInfo[] Static = new SocialPlatformInfo[(int)SocialPlatform.Nb] {
			new SocialPlatformInfo {
				Enabled = false,
				Name = "None",
				Icon = "fa-times",
			}, new SocialPlatformInfo {
				Enabled = true,
				Name = "Twitter",
				Icon = "fa-twitter",
			},new SocialPlatformInfo {
				Enabled = true,
				Name = "Facebook",
				Icon = "fa-facebook-f",
			},new SocialPlatformInfo {
				Enabled = true,
				Name = "Instagram",
				Icon = "fa-instagram",
			},new SocialPlatformInfo {
				Enabled = true,
				Name = "YouTube",
				Icon = "fa-youtube",
			},new SocialPlatformInfo {
				Enabled = true,
				Name = "Spotify",
				Icon = "fa-spotify",
			},
		};
	}
}
