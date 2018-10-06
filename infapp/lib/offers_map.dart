/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';

import 'package:flutter/material.dart';

// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:transparent_image/transparent_image.dart';

import 'package:latlong/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

import 'search/search_page.dart';
import 'protobuf/inf_protobuf.dart';

import 'package:geolocator/geolocator.dart';

class OffersMap extends StatefulWidget {
  const OffersMap({
    Key key,
    @required this.filterState,
    @required this.onFilterPressed,
    @required this.onSearchPressed,
    @required this.mapboxUrlTemplate,
    @required this.mapboxToken,
    @required this.account,
    @required this.filterTooltip,
    @required this.searchTooltip,
  }) : super(key: key);

  final bool filterState;

  final Function() onFilterPressed;
  final Function() onSearchPressed;

  final String mapboxUrlTemplate;
  final String mapboxToken;

  final String filterTooltip;
  final String searchTooltip;

  final DataAccount account;

  @override
  _OffersMapState createState() => new _OffersMapState();
}

class _OffersMapState extends State<OffersMap> {
  MapController _mapController;
  LatLng _initialLatLng;
  LatLng _gpsLatLng;
  Geolocator _geolocator;
  StreamSubscription<Position> _positionSubscription;

  @override
  void initState() {
    super.initState();
    _mapController = new MapController();
    // Default location depending on whether GPS is available or not
    if (widget.account.detail.latitude != 0.0 &&
        widget.account.detail.longitude != 0.0) {
      _initialLatLng = new LatLng(
          widget.account.detail.latitude, widget.account.detail.longitude);
    } else {
      _initialLatLng = new LatLng(34.0207305, -118.6919159);
    }
    _geolocator = new Geolocator();
    () async {
      _positionSubscription =
          (await _geolocator.getPositionStream()).listen((position) {
        if (position != null &&
            position.latitude != null &&
            position.longitude != null &&
            position.latitude != 0.0 &&
            position.longitude != 0.0) {
          bool setInitial = _gpsLatLng == null;
          setState(() {
            _gpsLatLng = new LatLng(position.latitude, position.longitude);
          });
          if (setInitial) _mapController.move(_gpsLatLng, _mapController.zoom);
        }
      });
      if (!mounted) {
        _positionSubscription.cancel();
        _positionSubscription = null;
        return;
      }
      Position position = await _geolocator.getLastKnownPosition();
      if (!mounted) return;
      if (position != null &&
          position.latitude != null &&
          position.longitude != null &&
          position.latitude != 0.0 &&
          position.longitude != 0.0 &&
          _gpsLatLng == null) {
        setState(() {
          _gpsLatLng = new LatLng(position.latitude, position.longitude);
        });
        _mapController.move(_gpsLatLng, _mapController.zoom);
      }
    }();
  }

  @override
  void dispose() {
    if (_positionSubscription != null) {
      _positionSubscription.cancel();
    }
    super.dispose();
  }

  Widget _buildCurrentLocationMarker(BuildContext context) {
    return new Material(
      color: Theme.of(context).primaryColor.withAlpha(64),
      shape: new CircleBorder(),
      child: new Icon(Icons.gps_fixed,
          color: Theme.of(context).accentColor.withAlpha(192)),
    );
  }

  List<Marker> _buildPositionMarkers(BuildContext context) {
    List<Marker> markers = new List<Marker>();
    // Show a marker for each account location (business only)
    /*
    if (widget.account.detail.latitude != 0.0 &&
        widget.account.detail.longitude != 0.0) {
      markers.add(new Marker(
        width: 56.0,
        height: 56.0,
        point: new LatLng(widget.account.detail.latitude, widget.account.detail.longitude),
        builder: (ctx) =>
        new Container(
          child: new FlutterLogo(),
        ),
      ));
    }
    */
    // Show a marker for current location
    if (_gpsLatLng != null) {
      markers.add(new Marker(
        width: 56.0,
        height: 56.0,
        point: _gpsLatLng,
        builder: _buildCurrentLocationMarker,
      ));
    }
    return markers;
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: [
        new FlutterMap(
          mapController: _mapController,
          options: new MapOptions(
            center: _initialLatLng,
            zoom: 13.0,
          ),
          layers: [
            new TileLayerOptions(
              backgroundColor: Theme.of(context).brightness == Brightness.light
                  ? new Color.fromARGB(0xFF, 0xD1, 0xD1, 0xD1)
                  : new Color.fromARGB(0xFF, 0x1C, 0x1C, 0x1C),
              placeholderImage: new AssetImage(
                  'assets/placeholder_map_tile.png'), // new MemoryImage(kTransparentImage),
              /*
              urlTemplate: "https://api.tiles.mapbox.com/v4/"
                  "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
              additionalOptions: {
                'accessToken':
                    'pk.eyJ1IjoibmJzcG91IiwiYSI6ImNqaDBidjJkNjNsZmMyd21sbXlqN3k4ejQifQ.N0z3Tq8fg6LPPxOGVWI8VA',
                'id': 'mapbox.dark',
              },
              */
              urlTemplate: widget.mapboxUrlTemplate,
              additionalOptions: {'accessToken': widget.mapboxToken},
            ),
            new MarkerLayerOptions(
              markers: _buildPositionMarkers(context),
            ),
          ],
        ),
        new SafeArea(
          child: new Builder(
            builder: (context) {
              return new Stack(
                fit: StackFit.expand,
                children: [
                  new Align(
                    alignment: Alignment.topCenter,
                    child: new SizedBox(
                      height: kToolbarHeight * 1.5,
                      child: Image(
                          image: new AssetImage(
                              "assets/logo_appbar_ext_gray.png")),
                    ),
                  ),
                  new Align(
                    alignment: Alignment.topCenter,
                    child: new Row(
                      children: [
                        new ClipOval(
                          child: new Material(
                            type: MaterialType.circle,
                            color: Colors.transparent,
                            child: new IconButton(
                              // splashColor: Theme.of(context).accentColor,
                              // color: Theme.of(context).accentColor,
                              // highlightColor: Colors.transparent,
                              padding: new EdgeInsets.all(16.0),
                              icon: new Icon(Icons.menu),
                              onPressed: () =>
                                  Scaffold.of(context).openDrawer(),
                              tooltip: "Open navigation menu",
                            ),
                          ),
                        ),
                        new Flexible(
                          fit: FlexFit.tight,
                          child: new Padding(
                            padding: new EdgeInsets.all(0.0),
                            child: new SizedBox(),
                          ),
                        ),
                        new ClipOval(
                          child: new Material(
                            type: MaterialType.circle,
                            color: widget.filterState == true
                                ? Theme.of(context).primaryColor.withAlpha(128)
                                : Colors.transparent,
                            child: new IconButton(
                              color: widget.filterState == true
                                  ? Theme.of(context).accentColor
                                  : Theme.of(context).iconTheme.color,
                              padding: new EdgeInsets.all(16.0),
                              icon: new Icon(Icons.filter_list),
                              onPressed: () {
                                widget.onFilterPressed();
                              },
                              tooltip: widget.searchTooltip,
                            ),
                          ),
                        ),
                        new ClipOval(
                          child: new Material(
                            type: MaterialType.circle,
                            color: Colors.transparent,
                            child: new IconButton(
                              // highlightColor: Colors.transparent,
                              // splashColor: Theme.of(context).accentColor,
                              // color: Theme.of(context).accentColor,
                              padding: new EdgeInsets.all(16.0),
                              icon: new Icon(Icons.search),
                              onPressed: () {
                                widget.onSearchPressed();
                              },
                              tooltip: widget.searchTooltip,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
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
    );
  }
}

/* end of file */
