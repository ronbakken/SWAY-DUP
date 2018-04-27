using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;
using System.Diagnostics;

using Xamarin.Forms;

namespace InfX
{
	public partial class App : Application
	{
		const uint ConfigMagic = 0x00A000A0;
		const uint ConfigBarrier = 0x494E46A0;
		const int ConfigVersion = 1;

		public static string CacheDir;

		void assertBarrier(BinaryReader br)
		{
			uint barrier = br.ReadUInt32();
			Debug.Assert(barrier == ConfigBarrier);
		}

		void copyConfigResource(string configPath)
		{
			// Use embedded config. No network sync yet
			byte[] configData = ConfigResource.Config;
			FileStream configFS = new FileStream(configPath, FileMode.Create, FileAccess.Write, FileShare.Read);
			configFS.Write(configData, 0, configData.Length);
			configFS.Flush();
			configFS.Close();
			configFS.Dispose();
		}

		void loadConfig(string configPath)
		{
			FileStream fs = new FileStream(configPath, FileMode.Open, FileAccess.Read, FileShare.Read);
			BinaryReader br = new BinaryReader(fs);
			uint magic = br.ReadUInt32();
			Debug.Assert(magic == ConfigMagic);
			int version = br.ReadInt32();
			Debug.Assert(version == ConfigVersion);
			CommonData.LoadCategories(br);
			assertBarrier(br);
			br.Close();
			fs.Close();
			br.Dispose();
			fs.Dispose();
		}

		public App()
		{
			string configName = "config." + ConfigVersion + ".bin"; // Increment of version forces re-sync on any update
			string configPath = Path.Combine(CacheDir, "static", configName);
			copyConfigResource(configPath);
			loadConfig(configPath);

			// Environment.GetFolderPath(Environment.SpecialFolder.)
			MainPage = PrepareOnboarding();
			// MainPage = PrepareInfluencerMain();
			// MainPage = new BusinessOfferCreate();
		}

		protected override void OnStart()
		{
			// Handle when your app starts
		}

		protected override void OnSleep()
		{
			// Handle when your app sleeps
		}

		protected override void OnResume()
		{
			// Handle when your app resumes
		}

		public Page PrepareOnboarding()
		{
			return new OnboardingPage();
		}

		public Page PrepareInfluencerMain()
		{
			InfluencerMain main = new InfluencerMain();
			NavigationPage next = new NavigationPage(main) {
				BackgroundColor = Palette.MapBackground,
			};
			Device.BeginInvokeOnMainThread(async () => {
				await Task.Delay(5000);
				next.BackgroundColor = Color.Default;
			});
			return next;
		}
	}
}
