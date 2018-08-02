import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:rxdart/rxdart.dart';

class SearchScreen extends StatefulWidget 
{

  @override
  _SearchPageState createState() => new _SearchPageState();
}

class _SearchPageState extends State<SearchScreen> 
{
  // The Search bar that will be shown on the appbar
  SearchBar searchBar;

  // Subject that will contain the Search String and Stream
  // the results 
  // TODO: Find an efficient way to do this
  PublishSubject<String> subject = new PublishSubject<String>();
  
  // Search Bar Controller
  TextEditingController textController = new TextEditingController();


  String sampleText = "";

  @override
  void initState() {
    // Initialize the Parent
    super.initState();

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

  void _setResults(String textSearch) {
    setState(() {
      sampleText = textSearch;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      // We want the appbar to change to a 
      // search field whenever we press the Search Icon
      appBar: searchBar.build(context),
      body: new Text(sampleText),
    );
  }

  // The default AppBar displayed before searching
  AppBar _buildAppBar(BuildContext context) {
    return new AppBar(
      title: Text('Search Profile'),
      actions: [searchBar.getSearchAction(context)]
    );
  } 
}