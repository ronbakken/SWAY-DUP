import 'package:flutter/material.dart';

// Widget for editing a page
class EditButton extends StatelessWidget {
  // Constructor
  EditButton({
    Key key,
    this.onEditPressed,
  }) : super(key: key);

  final VoidCallback onEditPressed;

  @override
  Widget build(BuildContext context) {
    return new IconButton(
      icon: new Icon(Icons.edit),
      onPressed: onEditPressed,
    );
  }
}
