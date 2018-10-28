/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Kenneth Amiel Santos <kennethamiel.santos@gmail.com>
*/

import 'package:flutter/material.dart';
import 'package:inf/screens/experiment_files/forward_geocoding.dart';

class LocationSearch extends SearchDelegate<String> {
  List<String> placeNameList = new List<String>();

  void _updatePlaceNameList() async {
    placeNameList = await forwardGeocode(query);
  }

  // Override AppbarTheme to match with context
  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme;
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
        close(context, '');
      },
    );
  }

  // Action when a List item from search in selected
  @override
  Widget buildResults(BuildContext context) {
    // TODO: Implement callback when result is tapped
    return new Text("/* Placeholder */");
  }

  // List of items to be shown when typing a query
  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: Implement Location List
    // Forward Geocode as user types only if query is not empty
    if (query != "") _updatePlaceNameList();

    // Recently searched places
    List<String> recentSearches = <String>[
      "Recent 01",
      "Recent 02",
      "Recent 03",
      "Recent 04",
      "Recent 05",
    ];

    // Final list that will be shown in the list view
    // show recent searches when user entered epty query
    List<String> searchList = query == "" ? recentSearches : placeNameList;
    Icon leading = query == ""
        ? new Icon(Icons.recent_actors)
        : new Icon(Icons.location_city);

    // Return a list of items
    return new ListView.builder(
      itemBuilder: (context, index) => new ListTile(
            onTap: () {
              close(context, searchList[index]);
            },
            leading: leading,
            title: new Text(searchList[index]),
          ),
      itemCount: searchList.length,
    );
  }
}

/* end of file */
