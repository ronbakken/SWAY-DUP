import 'package:flutter/material.dart';
import 'follower_count.dart';
import 'carousel_app_bar.dart';
import 'dark_container.dart';

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
      appBar: new AppBar(
        // Set the title of the page to the name of the business
        title: new Text(businessTitle),

        // Check whether to place the edit icon or not
        actions: <Widget>
        [ 
          self ? 
          // If the business being viewed is it self, show the edit button
          new IconButton(
          icon: new Icon(Icons.edit), 
          onPressed: () => print('Edit Profile'),
          )
          // If not, show a blank container 
          // TODO: Efficient Solution for checking self
          :new Container() 
        ],
      ),

      /// Set the body to the business profile itself.
      /// Similar styling to Offer View
			body: new CustomScrollView(
				slivers: <Widget>[
					new CarouselAppBar(
						context: context,
            title: new Text(businessTitle),
						imageUrls: businessImageUrl,
					),
					new SliverList(
						delegate: new SliverChildListDelegate([
							new DarkContainer(
                child: new ListTile(
                  enabled: true,
                  leading: new CircleAvatar(
                    backgroundImage: new NetworkImage(businessAvatarUrl)
                  ),
                  title: new Text(businessTitle),
                  subtitle: new Text(businessLocation),
                ),
              ),
              new Row(
								mainAxisAlignment: MainAxisAlignment.center,
								children: <Widget>[
									new FollowerWidget(),
									new FollowerWidget(),
									new FollowerWidget(),
									new FollowerWidget(),
									new FollowerWidget(),
									new FollowerWidget(),
								],
							),
							new Divider(),
							new ListTile(
                title: new Text(businessDescription.toUpperCase(), style: Theme.of(context).textTheme.body1, textAlign: TextAlign.center, ),
              ),
						]),
					),
				],
			),
    );
  }
}

