import 'package:flutter/material.dart';

// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:transparent_image/transparent_image.dart';

import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

import 'search/search_page.dart';

class NearbyOffers extends StatefulWidget {
  const NearbyOffers({
    Key key,
    @required this.onSearchPressed,
  }) : super(key: key);

  final Function(TextEditingController searchQuery) onSearchPressed;

  @override
  _NearbyOffersState createState() => new _NearbyOffersState();
}

class _NearbyOffersState extends State<NearbyOffers> {
  TextEditingController _searchTextController;

  @override
  void initState() {
    super.initState();
    _searchTextController = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(
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
                'accessToken':
                    'pk.eyJ1IjoibmJzcG91IiwiYSI6ImNqaDBidjJkNjNsZmMyd21sbXlqN3k4ejQifQ.N0z3Tq8fg6LPPxOGVWI8VA',
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
              return new Stack(children: [
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
                            controller: _searchTextController,
                            decoration: new InputDecoration(
                                // TODO: Better track focus of this input!!! (remove focus when keyboard is closed)
                                hintText: 'Find nearby offers...'),
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
                          onPressed: () {
                            widget.onSearchPressed(_searchTextController);
                          },
                          tooltip: "Search for nearby offers",
                        ),
                      ),
                    ],
                  ),
                )
              ]);
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
    );
  }
}
