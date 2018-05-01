using System;
using System.Collections.Generic;
using System.Text;

using System.IO;

namespace InfX
{
	struct CategoryId
	{
		public int Id { get; set; }

		public CategoryInfo Info
		{
			get
			{
				int a = Id & 0xFF;
				int b = (Id >> 8) & 0xFF;
				if (a < CommonData.Categories.Length && b < CommonData.Categories[a].Length)
					return CommonData.Categories[a][b];
				return CommonData.EmptyCategory;
			}
		}

		public bool Valid { get { return !string.IsNullOrWhiteSpace(Info.Label); } }
		public bool Root { get { return (Id & 0xFF) == 0; } }
		public string Label { get { return Info.Label; } }
	}

	class CategoryInfo
	{
		public CategoryInfo(string label)
		{
			Label = label;
		}

		public string Label { get; private set; }
	}

	static class CommonData
    {
		public static void LoadCategories(BinaryReader config)
		{
			Categories = new CategoryInfo[2][];
			Categories[0] = new CategoryInfo[] { EmptyCategory };
			Categories[1] = new CategoryInfo[] { new CategoryInfo("Fashion") };
			/*Categories = new CategoryInfo[config.ReadInt16()][];
			for (int i = 0; i < Categories.Length; ++i)
			{
				Categories[i] = new CategoryInfo[config.ReadInt16()];
				for (int j = 0; j < Categories[i].Length; ++j)
				{
					byte[] utf8 = config.ReadBytes(config.ReadInt16());
					string label = Encoding.UTF8.GetString(utf8);
					Categories[i][j] = new CategoryInfo(label);
				}
			}*/
		}

		public static readonly CategoryInfo EmptyCategory = new CategoryInfo("");
		public static CategoryInfo[][] Categories;

		/*
		static string[] Categories = new string[] {
			"",
			"News",
			"Music",
			"Fashion",
			"Car",
			"Real Estate",
			"Beauty",
			"Travel",
			"Design",
			"Food",
			"Wedding",
			"Movie",
			"Photography",
			"Law",
			"Health",
			"Green",
			"Technology",
			"History",
			"Marketing",
			"Lifestyle",
			"University",
			"Cat",
			"Dog",
			"Money",
			"Business",
			"Fitness",
			"Education",
			"Science",
			"Shopping",
			"Entertainment",
			"Sports",
			"Social Media",
			"Medical",
			"Wine",
			"Beer",
			"Celebrity Gossip",
			"DIY",
			"Nature",
			"Gaming",
			"Pet",
			"Finance",
			"Political",
			"Career",
			"Parenting",
			"Economics",
			"Concert",
			"Blog",
			"Gadgets",
			"Collecting",
			"Motorcycle",
			"People",
			"Pokemon",
			"Airplane",
			"Electronics",
			"Computer",
			"Smartphone",
		};
		*/
    }
}

/* end of file */