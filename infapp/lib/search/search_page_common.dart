import 'dart:async';

import 'package:flutter/material.dart';
import '../network/inf.pb.dart';

class SearchPageCommon extends StatefulWidget {
  SearchPageCommon(
      {Key key,
      @required this.searchQueryController,
      @required this.onSearchRequest,
      @required this.searchResults})
      : super(key: key);

  // Initial search query, only used when the widget state is created
  final TextEditingController searchQueryController;

  // Called anytime the search query changes
  // final Function(TextEditingController searchQuery) onSearchChanged;

  // This is called when the search button is pressed, will tell the network to fetch new results. Returns asynchronously when new results are received
  final Future<void> Function(String searchQuery) onSearchRequest;

  // Search results for this query
  final List<Widget> searchResults;

  @override
  _SearchPageState createState() => new _SearchPageState();
}

class _SearchPageState extends State<SearchPageCommon> {
  // Search is in progress (awaiting network results)
  bool searchInProgress = false;

  @override
  void initState() {
    // Initialize the Parent
    super.initState();

    _search();
  }

  String lastSearchQuery = '';
  bool searchAgain = false;

  Future<void> _search() async {
    String searchQuery = widget.searchQueryController.text;
    // Can only have one search in progress, the stream doesn't seem to wait for this call to finish.....
    if (searchInProgress) {
      // Flag to re-run the search
      searchAgain = true;
      print("Search $searchQuery later");
      return;
    }
    if (searchQuery == lastSearchQuery) {
      // Ignore the event if we already searched with the latest query.
      print("Ignore duplicate $searchQuery search");
      return;
    }
    lastSearchQuery = searchQuery;
    if (searchQuery.isEmpty) {
      print("Ignore empty search");
      return;
    }
    // Initiate the search
    print("Searching $searchQuery");
    // Flag search in progress
    setState(() {
      searchInProgress = true;
    });
    // Wait for the search to complete asynchronously
    await widget.onSearchRequest(searchQuery);
    if (!mounted) {
      // Abort if already closed
      return;
    }
    setState(() {
      searchInProgress = false;
    });
    if (searchAgain != null) {
      searchAgain = false;
      print("Searching again");
      await _search();
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        // We want the appbar to change to a
        // search field whenever we press the Search Icon
        //appBar: searchBar.build(context),
        appBar: new AppBar(
          // automaticallyImplyLeading: false,
          titleSpacing: 0.0,
          title: new TextField(
            controller: widget.searchQueryController,
            decoration: new InputDecoration(
                // TODO: Better track focus of this input!!! (remove focus when keyboard is closed)
                hintText: 'Find nearby offers...'),
          ),
          actions: [
            new IconButton(
              // splashColor: Theme.of(context).accentColor,
              // color: Theme.of(context).accentColor,
              padding: new EdgeInsets.all(16.0),
              icon: new Icon(Icons.search),
              onPressed: _search,
              tooltip: "Search for nearby offers",
            )
          ],
        ),
        bottomNavigationBar: searchInProgress
            ? new Text("Search in progress '$lastSearchQuery'...")
            : null, // TODO: For testing purpose. Make it nice
        body: new ListView(
          children: widget.searchResults,
        ));
  }
}
