using System;
using System.Collections.Generic;
using System.Text;

namespace InfX
{
	/* Data for an imfluencer profile */

    class ProfileInfluencerData
    {
		public string Id;

		public string Name;
		public string Location;

		public string[] ImageUrls;
		public string AvatarUrl;

		public string Description;
		public int[] Followers = new int[(int)SocialPlatform.Nb];

		public string[] Tags;
	}
}

/* end of file */
