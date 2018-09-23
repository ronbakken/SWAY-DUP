import 'package:flutter/material.dart';
import 'experiment_files/forward_geocoding.dart';

class LocationSearch extends SearchDelegate<String> {

  List<String> placeNameList = new List<String>();

  void _updatePlaceNameList() async
  {
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
    // Forward Geocode as user types
    _updatePlaceNameList();
    
    List<String> recentSearches = <String> [
      "Recent 01",
      "Recent 02",
      "Recent 03",
      "Recent 04",
      "Recent 05",
    ];
    List<String> searchList = query == "" ? recentSearches : placeNameList;

    // Return a list of items
    return new ListView.builder(
      itemBuilder: (context, index) => new ListTile(
            onTap: () {
              close(context, searchList[index] + " " + index.toString());
            },
            leading: new Icon(Icons.location_city),
            title: new Text(searchList[index] + " " + index.toString()),
          ),
      itemCount: searchList.length,
    );
  }
}
