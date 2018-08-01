// import 'dart:async';
// import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart'; 
import 'package:flutter/cupertino.dart'; 

// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:transparent_image/transparent_image.dart';

import 'package:latlong/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

import 'network/inf.pb.dart';

// import 'network/inf.pb.dart';

// pk.eyJ1IjoibmJzcG91IiwiYSI6ImNqaDBidjJkNjNsZmMyd21sbXlqN3k4ejQifQ.N0z3Tq8fg6LPPxOGVWI8VA

class DashboardBusiness extends StatefulWidget {
  const DashboardBusiness({
    Key key,
    @required this.account,
    @required this.onMakeAnOffer,
  }) : super(key: key);

  final DataAccount account;
  final VoidCallback onMakeAnOffer;

  @override
  _DashboardBusinessState createState() => new _DashboardBusinessState();
}

class _DashboardBusinessState extends State<DashboardBusiness> {
  int _currentTab;

  @override
  void initState() {
    super.initState();
    _currentTab = 0;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Stack(
        children: [
          new FlutterMap(
            options: new MapOptions(
              center: new LatLng(51.5, -0.09),
              zoom: 13.0,
            ),
            layers: [
              new TileLayerOptions(
                backgroundColor: new Color.fromARGB(0xFF, 0x1C, 0x1C, 0x1C),
                placeholderImage: new MemoryImage(kTransparentImage),
                urlTemplate: "https://api.tiles.mapbox.com/v4/"
                  "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
                additionalOptions: {
                  'accessToken': 'pk.eyJ1IjoibmJzcG91IiwiYSI6ImNqaDBidjJkNjNsZmMyd21sbXlqN3k4ejQifQ.N0z3Tq8fg6LPPxOGVWI8VA',
                  'id': 'mapbox.dark',
                },
              ),
              new MarkerLayerOptions(
                markers: [
                  /*new Marker(
                    width: 80.0,
                    height: 80.0,
                    point: new LatLng(51.5, -0.09),
                    builder: (ctx) =>
                    new Container(
                      child: new FlutterLogo(),
                    ),
                  ),*/
                ],
              ),
            ],
          ),
          new SafeArea(
            child: new Builder(
              builder: (context) {
                return new Stack(
                  children: [
                    new Align(
                      alignment: Alignment.topCenter,
                      child: new Row(
                        children: [
                          new Material(
                            type: MaterialType.circle,
                            color: Colors.transparent,
                            child: new IconButton(
                              // splashColor: Theme.of(context).accentColor,
                              // color: Theme.of(context).accentColor,
                              padding: new EdgeInsets.all(16.0),
                              icon: new Icon(Icons.menu),
                              onPressed: () => Scaffold.of(context).openDrawer(),
                              tooltip: "Open navigation menu",
                            ),
                          ),
                          new Flexible(
                            fit: FlexFit.tight,
                            child: new Padding(
                              padding: new EdgeInsets.all(0.0),
                              child: new TextField(
                                decoration: new InputDecoration(
                                  // TODO: Better track focus of this input!!! (remove focus when keyboard is closed)
                                  hintText: 'Find nearby influencers...'
                                ),
                              ),
                            ),
                          ),
                          new Material(
                            type: MaterialType.circle,
                            color: Colors.transparent,
                            child: new IconButton(
                              // splashColor: Theme.of(context).accentColor,
                              // color: Theme.of(context).accentColor,
                              padding: new EdgeInsets.all(16.0),
                              icon: new Icon(Icons.search),
                              onPressed: () { },
                              tooltip: "Search for nearby influencers",
                            ),
                          ),
                        ],
                      ),
                    )
                  ]
                );
              },
            ),
          ),
          /*new Text("AYYY"),
          new SafeArea(
            child: new Text("Owyea"),
          ),
          new Align(
            alignment: Alignment.bottomCenter,
            child: new Text("Bottom Baby")
          )*/
        ],
      ),
      floatingActionButton: _currentTab == 2 ? null : new FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        tooltip: 'Make an offer',
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            new Icon(Icons.add),
          ]
        ),
        onPressed: widget.onMakeAnOffer,
      ),
      drawer: new Drawer(
        child: new Column(
          children: [
            new Material(
              elevation: 4.0, // TODO: Verify this matches AppBar
              color: Theme.of(context).primaryColor,
              child: new AspectRatio(
                aspectRatio: 16.0 / 9.0,
                child: new Stack(
                  children: [
                    widget.account.detail.coverUrls.length > 0 ? new FadeInImage.assetNetwork(
                      placeholder: 'assets/placeholder_photo.png',
                      image: widget.account.detail.coverUrls[0],
                      fit: BoxFit.cover
                    ) : new Image(image: new AssetImage('assets/placeholder_photo.png')),
                    new SafeArea(
                      child: new Text("Hello world")
                    )
                  ]
                )
              )
            ),
          ]
        ),
      ),
      appBar: _currentTab != 0 ? new AppBar(
        title: new Text(_currentTab == 1 ? "Offers" : "Applicants"),
      ) : null,
      bottomNavigationBar: new BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentTab,
        onTap: (int index) {
          setState(() {
            _currentTab = index;
          });
        },
        items: [
          new BottomNavigationBarItem(
            icon: new Icon(Icons.map),
            title: new Text("Map"),
          ),
          new BottomNavigationBarItem(
            icon: new Icon(Icons.list),
            title: new Text("Offers"),
          ),
          new BottomNavigationBarItem(
            icon: new Icon(Icons.inbox),
            title: new Text("Applicants"),
          ),
          /*new BottomNavigationBarItem(
            icon: new Icon(Icons.account_circle),
            title: new Text("Profile"),
          ),*/
        ]
      ),
    );
  }
}

/* end of file */
