using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;
using System.Globalization;

using IniParser;
using IniParser.Model;

namespace InfBuildConfig
{
	class Program
	{
		static void Main(string[] args)
		{
			string folder = @"C:\source\infclient\InfBuildConfig\Data\";
			string categoriesFile = folder + "categories.ini";
			string binFile = folder + "config.bin";

			FileStream fs = new FileStream(binFile, FileMode.Create, FileAccess.Write, FileShare.Read);
			BinaryWriter bw = new BinaryWriter(fs);

			FileIniDataParser parser = new FileIniDataParser();
			IniData categoriesIni = parser.ReadFile(categoriesFile);

			uint magic = 0x00A000A0;
			uint barrier = 0x494E46A0;
			int version = 1;
			bw.Write(magic);
			bw.Write(version);

			int nbCategories = 0;
			Dictionary<int, SectionData> categoryMap = new Dictionary<int, SectionData>();
			foreach (SectionData section in categoriesIni.Sections)
			{
				string idStr = section.Keys["id"];
				int id = int.Parse(idStr, CultureInfo.InvariantCulture);
				if (id > nbCategories) nbCategories = id;
				categoryMap[id] = section;
			}
			++nbCategories;

			bw.Write((short)nbCategories);
			for (int i = 0; i < nbCategories; ++i)
			{
				if (!categoryMap.ContainsKey(i))
				{
					bw.Write((short)0);
					continue;
				}


				int nbSubCategories = 0;
				SectionData section = categoryMap[i];
				foreach (KeyData key in section.Keys)
				{
					string idStr = key.KeyName;
					if (idStr != "id")
					{
						int id = int.Parse(idStr, CultureInfo.InvariantCulture);
						if (id > nbSubCategories) nbSubCategories = id;
					}
				}
				++nbSubCategories;

				bw.Write((short)nbCategories);

				;
				{
					byte[] str = Encoding.UTF8.GetBytes(section.SectionName);
					bw.Write((short)str.Length);
					bw.Write(str, 0, str.Length);
				}

				for (int j = 0; j < nbSubCategories; ++j)
				{
					string idStr = j.ToString(CultureInfo.InvariantCulture);
					if (!section.Keys.ContainsKey(idStr))
					{
						bw.Write((short)0);
						continue;
					}
					byte[] str = Encoding.UTF8.GetBytes(section.Keys[idStr]);
					bw.Write((short)str.Length);
					bw.Write(str, 0, str.Length);
				}
			}

			bw.Write(barrier);

			bw.Flush();
			fs.Flush();
			bw.Close();
			fs.Close();
			bw.Dispose();
			fs.Dispose();
		}
	}
}
