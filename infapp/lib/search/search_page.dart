import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:rxdart/rxdart.dart';

class SearchScreen extends StatefulWidget {

  @override
  _SearchPageState createState() => new _SearchPageState();
}

class _SearchPageState extends State<SearchScreen> 
{
  SearchBar searchBar;
  PublishSubject<String> querySubject = new PublishSubject<String>();
  TextEditingController textController = new TextEditingController();
  String sampleText = "";

  _SearchPageState() {
    searchBar = new SearchBar(
        inBar: false,
        controller: textController,
        setState: setState,
        buildDefaultAppBar: _buildAppBar,
        onSubmitted: querySubject.add
    );
  }

  @override
  void initState() {
    super.initState();
    
    textController.addListener(() {
      querySubject.add(textController.text);
    });

    querySubject.stream
        .listen(_setResults);
  }

  void _setResults(String textSearch) {
    setState(() {
      sampleText = textSearch;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: searchBar.build(context),
      body: new Text(sampleText),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return new AppBar(
      title: Text('Search Profile'),
      actions: [searchBar.getSearchAction(context)]
    );
  } 
}