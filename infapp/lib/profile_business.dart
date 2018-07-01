import 'package:flutter/material.dart';
import 'follower_count.dart';
import 'carousel_app_bar.dart';
import 'dark_container.dart';
import 'config_manager.dart';

class BusinessProfileView extends StatelessWidget {

  // Constructor
  BusinessProfileView({
    Key key,
    this.self,
    this.businessTitle,
    this.businessImageUrl = const ['https://inf-dev.nyc3.digitaloceanspaces.com/demo/kahuna.jpg'], 
    this.businessLocation,
    this.businessDescription,
  }) : super(key: key);

  // boolean to check if the profile being viewed is self
  final bool self;

  // Information of the business to be shown on the page
  final String businessTitle;
  final List<String> businessImageUrl;
  final String businessLocation;
  final String businessDescription;

	final String businessAvatarUrl = 'https://inf-dev.nyc3.digitaloceanspaces.com/demo/kahuna.jpg';
  
	
	@override
  Widget build(BuildContext context) {
    return new Scaffold(

      /// Set the body to the business profile itself.
      /// Similar styling to Offer View
			body: new CustomScrollView(
				slivers: <Widget>[

					// Carousel Appbar as the Appbar
					// TODO: Add edit icon
					new CarouselAppBar(
						context: context,

						 // Set the title of the page to the name of the business
            title: new Text(businessTitle),

						// Header Pictures of the
						imageUrls: businessImageUrl,
					),

					// Silvers List as the Content
					new SliverList(
						delegate: new SliverChildListDelegate([
							// Use a Dark container to hold main information like the 
							// business name, location and display picture
							new DarkContainer(
                child: new ListTile(
                  leading: new CircleAvatar( backgroundImage: new NetworkImage(businessAvatarUrl) ),
                  title: new Text(businessTitle),
                  subtitle: new Text(businessLocation),
                ),
              ),

							// Follower Count Tray
							// TODO: Refactor
              new Row(
								mainAxisAlignment: MainAxisAlignment.center,
								children: <Widget>[
									new FollowerWidget(oAuthProvider: ConfigManager.of(context).oauthProviders.all[6] ,),
									new FollowerWidget(oAuthProvider: ConfigManager.of(context).oauthProviders.all[1]),
									new FollowerWidget(oAuthProvider: ConfigManager.of(context).oauthProviders.all[2]),
									new FollowerWidget(oAuthProvider: ConfigManager.of(context).oauthProviders.all[3]),
									new FollowerWidget(oAuthProvider: ConfigManager.of(context).oauthProviders.all[4]),
									new FollowerWidget(oAuthProvider: ConfigManager.of(context).oauthProviders.all[5]),
								],
							),
							new Divider(),

							// Description
							new Text(
								businessDescription.toUpperCase(), 
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

