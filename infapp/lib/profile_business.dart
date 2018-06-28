import 'package:flutter/material.dart';
import 'follower_count.dart';

class BusinessProfileView extends StatelessWidget {

  // Constructor
  BusinessProfileView({
    Key key,
    this.self,
    this.businessTitle,
    this.businessImageUrls,
    this.businessLocation,
    this.businessDescription,
  }) : super(key: key);

  // boolean to check if the profile being viewed is self
  final bool self;

  // Information of the business to be shown on the page
  final String businessTitle;
  final List<String> businessImageUrls;
  final String businessLocation;
  final String businessDescription;


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
      body: null,
    );
  }
}

