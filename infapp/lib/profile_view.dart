import 'package:flutter/material.dart';

import 'widgets/follower_count.dart';
import 'widgets/follower_tray.dart';
import 'widgets/carousel_app_bar.dart';
import 'widgets/dark_container.dart';
import 'network/config_manager.dart';

class ProfileView extends StatelessWidget {

  // Constructor
  ProfileView({
    Key key,
    this.self,
    this.profileName,
    this.profileImageUrls = const [
      'https://inf-dev.nyc3.digitaloceanspaces.com/demo/kahuna.jpg',
    ], 
    this.profileLocation,
    this.profileDescription,
    this.followers,
  }) : super(key: key);

  // boolean to check if the profile being viewed is self
  final bool self;

  // Information of the profile to be shown on the page
  final String profileName;
  final List<String> profileImageUrls;
  final String profileLocation;
  final String profileDescription;
  final List<FollowerWidget> followers;
	final String profileAvatarUrl = 'https://inf-dev.nyc3.digitaloceanspaces.com/demo/kahuna.jpg';
  
	
	@override
  Widget build(BuildContext context) {
    return new Scaffold(

      /// Set the body to the profile itself.
      /// Similar styling to Offer View
			body: new CustomScrollView(
				slivers: <Widget>[

					// Carousel Appbar as the Appbar
					// TODO: Add edit icon
					new CarouselAppBar(
						context: context,

						 // Set the title of the page to the name of the business
            title: new Text(profileName),

            // Check whether to display the edit button Edit button
            // TODO: Refactor
            actions: <Widget>[ 
              self ? 
              // If profile is self, Display the Edit button
              new IconButton(
                icon: new  Icon(Icons.edit),
                onPressed: () => print("Edit Profile"),
              ) :

              // if not, display an empty container
              new Container(),
            ],

						// Header Pictures of the
						imageUrls: profileImageUrls,
					),

					// Silvers List as the Content
					new SliverList(
						delegate: new SliverChildListDelegate([
							// Use a Dark container to hold main information like the 
							// business name, location and display picture
							new DarkContainer(
                child: new ListTile(
                  leading: new CircleAvatar( backgroundImage: new NetworkImage(profileAvatarUrl) ),
                  title: new Text(profileName),
                  subtitle: new Text(profileLocation),
                ),
              ),

							// Follower Count Tray
              new FollowerTray(
                followerWidgets: followers
              ),
							new Divider(),

							// Description
							new Text(
								profileDescription.toUpperCase(), 
								style: Theme.of(context).textTheme.body1, 
								textAlign: TextAlign.center,
								softWrap: true, 
							),
              new Divider(),

							// TODO: Website URL
							

						]),
					),
				],
			),
    );
  }
}