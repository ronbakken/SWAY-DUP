/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Kenneth Amiel Santos <kennethamiel.santos@gmail.com>
*/

import 'dart:async';

import 'package:flutter/material.dart';

import 'package:sway_mobile_app/widgets/network_status.dart';

class SearchPageCommon extends StatefulWidget {
  SearchPageCommon({
    Key key,
    @required this.searchQueryController,
    @required this.onSearchRequest,
    @required this.searchResults,
    @required this.searchHint,
    @required this.searchTooltip,
  }) : super(key: key);

  // Initial search query, only used when the widget state is created
  final TextEditingController searchQueryController;

  // Called anytime the search query changes
  // final Function(TextEditingController searchQuery) onSearchChanged;

  // This is called when the search button is pressed, will tell the network to fetch new results. Returns asynchronously when new results are received
  final Future<void> Function(String searchQuery) onSearchRequest;

  // Search results for this query
  final List<Widget> searchResults;

  final String searchHint;
  final String searchTooltip;

  @override
  _SearchPageState createState() => _SearchPageState();
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
      // print("Ignore duplicate $searchQuery search");
      // return;
      print("Not ignoring duplicate $searchQuery search");
    }
    lastSearchQuery = searchQuery;
    if (searchQuery.isEmpty) {
      // print("Ignore empty search");
      // return;
      print("Not ignoring empty search");
    }
    // Initiate the search
    print("Searching $searchQuery");
    // Flag search in progress
    setState(() {
      searchInProgress = true;
    });
    // Wait for the search to complete asynchronously
    try {
      await widget.onSearchRequest(searchQuery);
    } finally {
      if (mounted) {
        setState(() {
          searchInProgress = false;
        });
      }
    }
    if (!mounted) {
      // Abort if already closed
      return;
    }
    if (searchAgain == true) {
      searchAgain = false;
      print("Searching again");
      await _search();
    }
  }

  static final _progressIndicator = LinearProgressIndicator();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // We want the appbar to change to a
        // search field whenever we press the Search Icon
        //appBar: searchBar.build(context),
        appBar: AppBar(
          // automaticallyImplyLeading: false,
          titleSpacing: 0.0,
          title: TextField(
            controller: widget.searchQueryController,
            decoration: InputDecoration(
                // TODO: Better track focus of this input!!! (remove focus when keyboard is closed)
                hintText: widget.searchHint),
          ),
          actions: [
            IconButton(
              // splashColor: Theme.of(context).accentColor,
              // color: Theme.of(context).accentColor,
              padding: EdgeInsets.all(16.0),
              icon: Icon(Icons.search),
              onPressed: _search,
              tooltip: widget.searchTooltip,
            )
          ],
        ),
        bottomSheet: NetworkStatus.buildOptional(
          context,
          searchInProgress
              ? _progressIndicator // new Text("Search in progress '$lastSearchQuery'...")
              : null,
        ),
        body: ListView(
          children: widget.searchResults,
        ));
  }
}

/* end of file */
