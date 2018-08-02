import 'package:flutter/material.dart';

// Widget for editing a page
class SearchButton extends StatelessWidget {

  // Constructor
  SearchButton({
    Key key,
    this.onSearchPressed,
  }) : super(key: key);
	
  final VoidCallback onSearchPressed;

  @override
  Widget build(BuildContext context) {
    return new IconButton(
      icon: new Icon(Icons.search),
      onPressed: onSearchPressed,
    );
  }
}
