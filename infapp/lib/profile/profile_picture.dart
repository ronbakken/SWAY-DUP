import 'package:flutter/material.dart';

class ProfilePicture extends StatefulWidget {
  ProfilePicture({
    Key key,
    this.imageUrl,
  }) : super(key: key);

  final String imageUrl;

  @override
  _ProfilePictureState createState() => new _ProfilePictureState();
}

// TODO: FadeInImage, use Pepijn's placeholders & default background color depending on name

class _ProfilePictureState extends State<ProfilePicture> {
  @override
  Widget build(BuildContext context) => new Container(
        padding: const EdgeInsets.all(32.0),
        child: new CircleAvatar(
          backgroundImage: new NetworkImage(widget.imageUrl),
          radius: 75.0,
        ),
      );
}
