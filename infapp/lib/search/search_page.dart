import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:rxdart/rxdart.dart';
import '../network/inf.pb.dart';
import 'search_item.dart';

typedef Future SearchRequestCallback(String searchQuery);

class SearchScreen extends StatefulWidget 
{
  SearchScreen({Key key, this.initialSearchQuery, this.accountResults, this.onSearchRequest}) : super(key: key);

  // Initial search query, only used when the widget state is created
  final String initialSearchQuery;

  // Account search results, as returned by the server. Client may optimize further on the go
  final List<DataAccount> accountResults;

  // This is called when the search button is pressed, will tell the network to fetch new results
  final SearchRequestCallback onSearchRequest;

  @override
  _SearchPageState createState() => new _SearchPageState();
}

class _SearchPageState extends State<SearchScreen> 
{
  // The Search bar that will be shown on the appbar
  SearchBar searchBar;

  // Search is in progress (awaiting network results)
  bool searchInProgress;

  // Subject that will contain the Search String and Stream
  // the results 
  // TODO: Find an efficient way to do this
  PublishSubject<String> subject = new PublishSubject<String>();
  
  // Search Bar Controller
  TextEditingController textController = new TextEditingController();

  List<DataAccount> searchResults = new List<DataAccount>();
  
  @override
  void initState() {
    // Initialize the Parent
    super.initState();

    // Set initial search query
    textController.text = widget.initialSearchQuery;

    // Initialize Tne Search Barasad
    searchBar = new SearchBar(
        controller: textController,
        setState: setState,
        buildDefaultAppBar: _buildAppBar,
        onSubmitted: subject.add
    );
    
    // We want to Start the search as soon as the user
    // is typing. The search results will update based
    // on the text controller
    textController.addListener(() {
      subject.add(textController.text);
    });
    subject.stream.listen(_setResults);
  }

  // TODO: PRIORITIZE REFACTOR 
  // Currently O(n^2)
  void _setResults(String textSearch) async {
    bool rightAccount = true;

    // Search on server
    Future searchRequest = widget.onSearchRequest(textSearch);
    setState(() {
      // Flag server is in progress
      searchInProgress = true;

      searchResults.clear();

      for (int i = 1; i < widget.accountResults.length; i++) {
        rightAccount = true;
        for (int j = 0; j < textSearch.length; j++) {
          if (!(widget.accountResults[i].summary.name[j].toLowerCase() == textSearch[j].toLowerCase())) {
            rightAccount = false;
            break;
          }
        }
        if (rightAccount) searchResults.add(widget.accountResults[i]);
      }
    });

    // Wait for server
    await searchRequest;
    searchInProgress = true;
  }
  
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      // We want the appbar to change to a 
      // search field whenever we press the Search Icon
      appBar: searchBar.build(context),
      body: new ListView.builder(
        itemCount: searchResults.length,
        itemBuilder: (context, index) =>
          new SearchItemCard(item: searchResults[index]),
      )
    );
  }

  // The default AppBar displayed before searching
  AppBar _buildAppBar(BuildContext context) {
    return new AppBar(
      title: new Text('Search Profile'),
      actions: [searchBar.getSearchAction(context)]
    );
  } 
}