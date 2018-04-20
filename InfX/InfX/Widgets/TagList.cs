using System;
using System.Collections.Generic;
using System.Text;

using Xamarin.Forms;

namespace InfX
{
	class TagList : ContentView
	{
		public TagList()
		{
			HorizontalOptions = LayoutOptions.StartAndExpand;
			VerticalOptions = LayoutOptions.Start;

			Margin = new Thickness(0.0);
			Padding = new Thickness(0.0);

			layout = new WrapLayout {
				HorizontalOptions = LayoutOptions.StartAndExpand,
				VerticalOptions = LayoutOptions.Start,
				Margin = new Thickness(0.0),
				Padding = new Thickness(0.0),
				RowSpacing = Sizes.MarginElement,
				ColumnSpacing = Sizes.MarginElement,
			};
		}

		WrapLayout layout;

		HashSet<string> tags;
		string[] Tags
		{
			get
			{
				string[] r = new string[tags.Count];
				int i = 0;
				foreach (string s in tags)
				{
					r[i] = s;
					++i;
				}
				return r;
			}
			set
			{
				tags.Clear();
				layout.Children.Clear();
				foreach (string s in value)
				{
					Add(s);
				}
			}
		}

		private void Tc_RemoveClicked(object sender, EventArgs e)
		{
			TagChip tc = sender as TagChip;
			Remove(tc.Text);
		}

		bool readOnly = true;
		bool ReadOnly
		{
			get
			{
				return readOnly;
			}
			set
			{
				readOnly = value;
				foreach (View v in layout.Children)
				{
					TagChip tc = v as TagChip;
					if (tc != null)
						tc.Removable = !value;
				}
			}
		}

		public void Add(string tag)
		{
			tags.Add(tag);
			TagChip tc = new TagChip {
				Removable = !readOnly,
				Text = tag,
			};
			tc.RemoveClicked += Tc_RemoveClicked;
			layout.Children.Add(tc);
		}

		public void Remove(string tag)
		{
			List<TagChip> removable = new List<TagChip>();
			foreach (View v in layout.Children)
			{
				TagChip tc = v as TagChip;
				if (tc != null)
				{
					if (tc.Text == tag)
						removable.Add(tc);
				}
			}
			foreach (TagChip tc in removable)
				layout.Children.Remove(tc);
			tags.Remove(tag);
		}
	}
}
