import 'package:flutter/material.dart';

class LocationSearch extends SearchDelegate<String> {
  // Actions for Appbar
  @override
  List<Widget> buildActions(BuildContext context) {
    // Implement Clear Search Query
    return <Widget>[
      new IconButton(
        icon: new Icon(Icons.clear),
        onPressed: () {
          // Clear the query as the user presses the clear button
          // NOTE: query is a property of the parent class
          query = "";
        },
      ),
    ];
  }

  // Icon on the left of the Appbar
  @override
  Widget buildLeading(BuildContext context) {
    // TODO: Implement Leading Back Icon
    return IconButton(
      icon: new AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {},
    );
  }

  // Action when a List item from search in selected
  @override
  Widget buildResults(BuildContext context) {
    // TODO: Implement callback when result is tapped
  }

  // List of items to be shown when typing a query
  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: Implement Location List
  }
}
