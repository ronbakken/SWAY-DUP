import 'package:flutter/material.dart';

class ProfilePicture extends StatelessWidget {

  ProfilePicture({
    Key key,
    this.imageUrl,
  }) : super(key: key);
	
  final String imageUrl;

	@override
  Widget build(BuildContext context) =>
    new Container(
      padding: const EdgeInsets.all(32.0),
       child: new CircleAvatar( 
        backgroundImage: new NetworkImage(imageUrl),
        radius: 75.0,
      ),
    );
    
}