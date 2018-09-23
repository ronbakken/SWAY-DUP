import 'package:flutter/material.dart';

class LocationSearch extends SearchDelegate<String> {
  // Override AppbarTheme to match with context
  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme.copyWith(
      primaryColor: theme.primaryColor,
      primaryIconTheme: theme.primaryIconTheme,
      primaryColorBrightness: theme.primaryColorBrightness,
      primaryTextTheme: theme.primaryTextTheme,
    );
  }

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
      onPressed: () {
        close(context, null);
      },
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
    // Plceholder data for search List
    List<String> placeholderData = <String>[
      "String",
      "String",
      "String",
      "String",
      "String",
      "String",
      "String",
      "String",
    ];

    // Return a list of items
    return new ListView.builder(
      itemBuilder: (context, index) => new ListTile(
            leading: new Icon(Icons.location_city),
            title: new Text(placeholderData[index] + " " + index.toString()),
          ),
      itemCount: placeholderData.length,
    );
  }
}
