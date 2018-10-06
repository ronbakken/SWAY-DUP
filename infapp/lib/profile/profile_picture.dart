import 'package:flutter/material.dart';

class ProfilePicture extends StatelessWidget {
  ProfilePicture({
    Key key,
    this.imageUrl,
  }) : super(key: key);

  final String imageUrl;

  // TODO: Use default pictures

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: const EdgeInsets.all(32.0),
      child: new CircleAvatar(
        backgroundImage: new NetworkImage(imageUrl),
        radius: 75.0,
      ),
    );
  }
}
