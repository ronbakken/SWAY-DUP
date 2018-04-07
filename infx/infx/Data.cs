using System;
using System.Collections.Generic;
using System.Text;

namespace InfX
{
	public class OfferData
	{
		public int Id;
		public string Category;
		public string Title;
		public string Business;
		public string ImageUrl;
		public Xamarin.Forms.Maps.Position Position;
		public string Description;
		public string[] Tags;
		public string Deliverables;
		public string Reward;
		public int Applicants;
	}

	public class OfferDataDetail : OfferData
	{
		public string Address;
		public string AvatarUrl;
	}

	public static class DummyData
	{
		public static OfferDataDetail[] Offers = {
			new OfferDataDetail {
				Id = 0,
				Category = "Food",
				Title = "Finest Burger Weekend",
				Business = "Big Kahuna",
				ImageUrl = "https://inf-dev.nyc3.digitaloceanspaces.com/demo/burger.jpg",
				Description = "We'd like to expose the finest foods in our very busy restaurant to a wide audience.",
				Tags = new string[] { "Burgers", "Gourmet", "Vegetarian", "Health" },
				Reward = "Free dinner + $150",
				Deliverables = "Posts with photography across social media.",
				Applicants = 3,

				Address = "1100 Glendon Avenue, 17th Floor, Los Angeles CA 90024",
				AvatarUrl = "https://inf-dev.nyc3.digitaloceanspaces.com/demo/kahuna.jpg",
			},
			new OfferDataDetail {
				Id = 1,
				Category = "Food",
				Title = "Burger Weekend Fries",
				Business = "Big Kahuna",
				ImageUrl = "https://inf-dev.nyc3.digitaloceanspaces.com/demo/fries.jpg",
				Description = "We need some table fillers to make our restaurant look very busy this weekend.",
				Tags = new string[] { "Burgers", "Gourmet", "Vegetarian", "Health" },
				Reward = "Free Poke Fries",
				Deliverables = "Posts with photography across social media.",
				Applicants = 12,

				Address = "1100 Glendon Avenue, 17th Floor, Los Angeles CA 90024",
				AvatarUrl = "https://inf-dev.nyc3.digitaloceanspaces.com/demo/kahuna.jpg",
			},
			new OfferDataDetail {
				Id = 2,
				Category = "Food",
				Title = "Fishing Season",
				Business = "Fried Willy",
				ImageUrl = "https://inf-dev.nyc3.digitaloceanspaces.com/demo/friedfish.jpg",
				Description = "Looking to catch more customers during the fishing season.",
				Tags = new string[] { "Fish", "Dolphin", "Crab" },
				Reward = "Free dinner",
				Deliverables = "Posts with photography across social media.",
				Applicants = 12,

				Address = "1100 Glendon Avenue, 17th Floor, Los Angeles CA 90024",
				AvatarUrl = "https://inf-dev.nyc3.digitaloceanspaces.com/demo/kahuna.jpg",
			},
			new OfferDataDetail {
				Id = 3,
				Category = "Politics",
				Title = "Make America Great Again",
				Business = "Honest Campaigns Inc.",
				ImageUrl = "https://inf-dev.nyc3.digitaloceanspaces.com/demo/rally.jpg",
				Description = "Join our political rally in favour of reducing emission taxes on coal mining.",
				Tags = new string[] { "America", "Tax Reduction" },
				Reward = "$3.50",
				Deliverables = "Post on Facebook and share posts of other participants.",
				Applicants = 510,

				Address = "1100 Glendon Avenue, 17th Floor, Los Angeles CA 90024",
				AvatarUrl = "https://inf-dev.nyc3.digitaloceanspaces.com/demo/kahuna.jpg",
			},
			new OfferDataDetail {
				Id = 4,
				Category = "Fashion",
				Title = "Photography Contest",
				Business = "The Pink Panty",
				ImageUrl = "https://inf-dev.nyc3.digitaloceanspaces.com/demo/pinkpanty.jpg",
				Description = "Join the photography contest at our stores. Blog about your participation. Pique girl's interests. Get inside those panties.",
				Tags = new string[] { "Underwear", "Photography", "Girls" },
				Reward = "Pack of 12 striped pink panties",
				Deliverables = "Series of blog posts and photography albums on social media.",
				Applicants = 9,

				Address = "1100 Glendon Avenue, 17th Floor, Los Angeles CA 90024",
				AvatarUrl = "https://inf-dev.nyc3.digitaloceanspaces.com/demo/kahuna.jpg",
			},
		};
	}
}
