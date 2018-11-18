/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';

import 'package:latlong/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';

import 'package:inf/widgets/blurred_network_image.dart';
import 'package:inf_common/inf_common.dart';

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
    this.mapController,
    this.bottomSpace = 0.0,
    @required this.offers,
    @required this.onOfferPressed,
    @required this.highlightOffer,
  }) : super(key: key);

  final bool filterState;

  final Function() onFilterPressed;
  final Function() onSearchPressed;

  final String mapboxUrlTemplate;
  final String mapboxToken;

  final String filterTooltip;
  final String searchTooltip;

  final DataAccount account;

  final MapController mapController;
  final double bottomSpace;

  /// Temporary
  final List<DataOffer> offers;

  // TODO: final Function(S2CellId cellId) getOffer;
  final Function(Int64 offerId) onOfferPressed;
  final DataOffer highlightOffer;

  @override
  _OffersMapState createState() => new _OffersMapState();
}

class _OffersMapState extends State<OffersMap> {
  MapController _mapController;
  LatLng _initialLatLng;
  LatLng _gpsLatLng;
  Geolocator _geolocator;
  StreamSubscription<Position> _positionSubscription;
  List<DataOffer> _offers;

  @override
  void initState() {
    super.initState();
    _mapController = widget.mapController ?? new MapController();
    _updateOfferList();
    bool initGps = false;
    try {
      if (_mapController.center == null) {
        initGps = true;
      } else {
        _initialLatLng = _mapController.center;
      }
    } catch (error) {
      print("[INF] Need to center map");
      initGps = true;
    }
    // Default location depending on whether GPS is available or not
    if (_initialLatLng == null) {
      if (widget.account.detail.latitude != 0.0 &&
          widget.account.detail.longitude != 0.0) {
        _initialLatLng = new LatLng(
            widget.account.detail.latitude, widget.account.detail.longitude);
      } else {
        _initialLatLng = new LatLng(34.0207305, -118.6919159);
      }
    }
    _geolocator = new Geolocator();
    () async {
      Position position = await _geolocator.getLastKnownPosition();
      if (!mounted) return;
      _positionSubscription =
          _geolocator.getPositionStream().listen((position) {
        if (position != null &&
            position.latitude != null &&
            position.longitude != null &&
            position.latitude != 0.0 &&
            position.longitude != 0.0) {
          bool setInitial = _gpsLatLng == null;
          setState(() {
            _gpsLatLng = new LatLng(position.latitude, position.longitude);
          });
          if (setInitial && initGps)
            _mapController.move(_gpsLatLng, _mapController.zoom);
        }
      });
      if (!mounted) {
        _positionSubscription.cancel();
        _positionSubscription = null;
        return;
      }
      if (position != null &&
          position.latitude != null &&
          position.longitude != null &&
          position.latitude != 0.0 &&
          position.longitude != 0.0 &&
          _gpsLatLng == null) {
        setState(() {
          _gpsLatLng = new LatLng(position.latitude, position.longitude);
        });
        if (initGps) {
          _mapController.move(_gpsLatLng, _mapController.zoom);
        }
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

  @override
  void didUpdateWidget(OffersMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_mapController == oldWidget.mapController ||
        widget.mapController != null) {
      _mapController = widget.mapController;
    }
    _mapController ??= new MapController();
    _updateOfferList();
  }

  void _updateOfferList() {
    _offers = widget.offers ?? <DataOffer>[];
    if (widget.highlightOffer != null) {
      _offers.insert(0, widget.highlightOffer);
    }
  }

  Widget _buildOfferMarker(BuildContext context, DataOffer offer) {
    List<Widget> stack = new List<Widget>();
    if (offer.locationOfferCount > 2) {
      stack.add(new Padding(
        padding: EdgeInsets.fromLTRB(16.0, 16.0, 0.0, 0.0),
        child: new Material(
          elevation: 4.0,
          color: Theme.of(context).iconTheme.color.withAlpha(192),
          shape: new CircleBorder(),
        ),
      ));
    }
    if (offer.locationOfferCount > 1) {
      stack.add(new Padding(
        padding: EdgeInsets.fromLTRB(12.0, 12.0, 4.0, 4.0),
        child: new Material(
          elevation: 4.0,
          color: Theme.of(context).iconTheme.color.withAlpha(192),
          shape: new CircleBorder(),
        ),
      ));
    }
    stack.add(new Padding(
      padding: EdgeInsets.all(8.0),
      child: new Material(
        elevation: 4.0,
        color: Theme.of(context).iconTheme.color.withAlpha(192),
        shape: new CircleBorder(),
        child: new ClipOval(
          child: new Stack(
            fit: StackFit.expand,
            children: <Widget>[
              new Padding(
                padding: new EdgeInsets.all(4.0),
                child: new Material(
                  elevation: 2.0,
                  shape: new CircleBorder(),
                  child: new ClipOval(
                    child: new Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        new BlurredNetworkImage(
                            url: offer.thumbnailUrl,
                            blurredUrl: offer.blurredThumbnailUrl),
                      ],
                    ),
                  ),
                ),
              ),
              new Material(
                color: Colors.transparent,
                child: new InkWell(
                  onTap: () {
                    widget.onOfferPressed(offer.offerId);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    ));
    return new Stack(
      key: Key('OfferMarker${offer.offerId}'),
      fit: StackFit.expand,
      children: stack,
    );
  }

  List<Marker> _buildOfferMarkers(BuildContext context) {
    List<Marker> markers = new List<Marker>();
    Set<Int64> locations = new Set<Int64>();
    for (DataOffer offer in _offers) {
      if (locations.contains(offer.locationId)) {
        continue;
      }
      locations.add(offer.locationId);
      markers.add(new Marker(
        width: 56.0 + 8.0, // + 16.0,
        height: 56.0 + 8.0, // + 16.0,
        point: new LatLng(offer.latitude, offer.longitude),
        builder: (BuildContext context) {
          return _buildOfferMarker(context, offer);
        },
      ));
    }
    return markers;
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
              urlTemplate: widget.mapboxUrlTemplate,
              additionalOptions: {'accessToken': widget.mapboxToken},
            ),
            new MarkerLayerOptions(
              markers: _buildPositionMarkers(context),
            ),
            new MarkerLayerOptions(
              markers: _buildOfferMarkers(context),
            ),
          ],
        ),
        new SafeArea(
          child: new Builder(
            builder: (context) {
              return new Stack(
                fit: StackFit.expand,
                children: [
                  new IgnorePointer(
                    child: new Align(
                      alignment: Alignment.topCenter,
                      child: new SizedBox(
                        height: kToolbarHeight * 1.5,
                        child: Image(
                            image: new AssetImage(
                                "assets/logo_appbar_ext_gray.png")),
                      ),
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
                        // TEMPORARiLY HIDDEN
                        widget.onFilterPressed != null
                            ? new ClipOval(
                                child: new Material(
                                  type: MaterialType.circle,
                                  color: widget.filterState == true
                                      ? Theme.of(context)
                                          .primaryColor
                                          .withAlpha(128)
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
                                    tooltip: widget.filterTooltip,
                                  ),
                                ),
                              )
                            : null,
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
                      ].where((w) => w != null).toList(),
                    ),
                  ),
                  new Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      new ClipOval(
                        child: new Material(
                          type: MaterialType.circle,
                          color: Colors.transparent,
                          child: new IconButton(
                            padding: new EdgeInsets.all(16.0),
                            icon: _gpsLatLng == null
                                ? new Icon(Icons.gps_off)
                                : new Icon(Icons.gps_fixed),
                            color: Theme.of(context)
                                .iconTheme
                                .color
                                .withAlpha(192),
                            onPressed: _gpsLatLng == null
                                ? null
                                : () {
                                    _mapController.move(
                                        _gpsLatLng, _mapController.zoom);
                                  },
                            tooltip: "Center map to your position",
                          ),
                        ),
                      ),
                      new SizedBox(height: widget.bottomSpace),
                    ],
                  ),
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
