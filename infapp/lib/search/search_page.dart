import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
// import 'package:rxdart/rxdart.dart';
import '../network/inf.pb.dart';
import 'search_item.dart';

typedef Future<List<DataAccount>> SearchRequestCallback(String searchQuery);

class SearchScreen extends StatefulWidget 
{
  SearchScreen({Key key, this.initialSearchQuery, this.onSearchRequest}) : super(key: key);

  // Initial search query, only used when the widget state is created
  final String initialSearchQuery;

  // This is called when the search button is pressed, will tell the network to fetch new results. Returns asynchronously when new results are received
  final SearchRequestCallback onSearchRequest;

  @override
  _SearchPageState createState() => new _SearchPageState();
}

class _SearchPageState extends State<SearchScreen> 
{
  // The Search bar that will be shown on the appbar
  SearchBar searchBar;

  // Search is in progress (awaiting network results)
  bool searchInProgress = false;

  // Subject that will contain the Search String and Stream
  // the results 
  // TODO: Find an efficient way to do this
  //PublishSubject<String> subject = new PublishSubject<String>();
  
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
        // onSubmitted: _beginSearch
    );
    
    // We want to Start the search as soon as the user
    // is typing. The search results will update based
    // on the text controller
    textController.addListener(_beginSearch);
    /*textController.addListener(() {
      subject.add(textController.text);
    });
    subject.stream.listen(_setResults);*/
  }

  String lastSearchQuery = '';
  bool searchAgain = false;

  // TODO: PRIORITIZE REFACTOR 
  // Currently O(n^2)
  Future<Null> _beginSearch() async {
    String searchQuery = textController.text;
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
    // Initiate the search
    print("Searching $searchQuery");
    Future<List<DataAccount>> searchResReq = widget.onSearchRequest(searchQuery);
    // Flag search in progress
    setState(() {
      searchInProgress = true;
      // Filter results locally
      // TODO: May skip this if it's too harsh compared to the natural search result from the server
      /*searchResults.removeWhere((DataAccount data) {
        return !data.summary.name.toLowerCase().contains(textSearch.toLowerCase());
      });*/
    });
    // Wait for the search results asynchronously
    List<DataAccount> searchRes = await searchResReq;
    if (!mounted) {
      // Abort if already closed
      return;
    }
    setState(() {
      searchInProgress = false;
      searchResults = searchRes;
    });
    if (searchAgain != null) {
      searchAgain = false;
      print("Searching again");
      await _beginSearch();
    }

    /*
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

    // TODO: widget.accountResults has changed OR will change after searchInProgress
    */
  }
  
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      // We want the appbar to change to a 
      // search field whenever we press the Search Icon
      appBar: searchBar.build(context),
      bottomNavigationBar: searchInProgress ? new Text("Search in progress '$lastSearchQuery'...") : null, // TODO: For testing purpose. Make it nice
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