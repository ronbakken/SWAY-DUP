/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';
import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';

import 'package:latlong/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';

import 'package:sway_mobile_app/widgets/blurred_network_image.dart';
import 'package:sway_common/inf_common.dart';

class OffersMapOnly extends StatefulWidget {
  const OffersMapOnly({
    Key key,
    @required this.mapboxUrlTemplate,
    @required this.mapboxToken,
    @required this.account,
    this.mapController,
    this.bottomSpace = 0.0,
    @required this.offers,
    @required this.getOffer,
    @required this.onOfferPressed,
    @required this.highlightOffer,
  }) : super(key: key);

  final String mapboxUrlTemplate;
  final String mapboxToken;

  final DataAccount account;

  final MapController mapController;
  final double bottomSpace;

  /// Temporary
  final List<Int64> offers;
  final DataOffer Function(BuildContext context, Int64 offerId) getOffer;

  final Function(Int64 offerId) onOfferPressed;
  final Int64 highlightOffer;

  @override
  _OffersMapOnlyState createState() => _OffersMapOnlyState();
}

class _OffersMapOnlyState extends State<OffersMapOnly> {
  MapController _mapController;
  LatLng _initialLatLng;
  LatLng _gpsLatLng;
  Geolocator _geolocator;
  StreamSubscription<Position> _positionSubscription;
  List<Int64> _offers;

  @override
  void initState() {
    super.initState();
    _mapController = widget.mapController ?? MapController();
    _updateOfferList();
    bool initGps = false;
    try {
      if (_mapController.center == null) {
        initGps = true;
      } else {
        _initialLatLng = _mapController.center;
      }
    } catch (error) {
      print('[INF] Need to center map');
      initGps = true;
    }
    // Default location depending on whether GPS is available or not
    if (_initialLatLng == null) {
      if (widget.account.latitude != 0.0 && widget.account.longitude != 0.0) {
        _initialLatLng =
            LatLng(widget.account.latitude, widget.account.longitude);
      } else {
        _initialLatLng = LatLng(34.0207305, -118.6919159);
      }
    }
    _geolocator = Geolocator();
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
            _gpsLatLng = LatLng(position.latitude, position.longitude);
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
          _gpsLatLng = LatLng(position.latitude, position.longitude);
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
  void didUpdateWidget(OffersMapOnly oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_mapController == oldWidget.mapController ||
        widget.mapController != null) {
      _mapController = widget.mapController;
    }
    _mapController ??= MapController();
    _updateOfferList();
  }

  void _updateOfferList() {
    _offers = widget.offers ?? <Int64>[];
    if (widget.highlightOffer != null) {
      _offers.insert(0, widget.highlightOffer);
    }
  }

  Widget _buildOfferMarker(BuildContext context, DataOffer offer) {
    List<Widget> stack = List<Widget>();
    /*
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
    */
    stack.add(Padding(
      padding: EdgeInsets.all(8.0),
      child: Material(
        elevation: 4.0,
        color: Theme.of(context).iconTheme.color.withAlpha(192),
        shape: CircleBorder(),
        child: ClipOval(
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(4.0),
                child: Material(
                  elevation: 2.0,
                  shape: CircleBorder(),
                  child: ClipOval(
                    child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        BlurredNetworkImage(
                            url: offer.thumbnailUrl,
                            blurredData:
                                Uint8List.fromList(offer.thumbnailBlurred)),
                      ],
                    ),
                  ),
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
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
    return Stack(
      key: Key('OfferMarker${offer.offerId}'),
      fit: StackFit.expand,
      children: stack,
    );
  }

  List<Marker> _buildOfferMarkers(BuildContext context) {
    List<Marker> markers = List<Marker>();
    Set<Int64> locations = Set<Int64>();
    for (Int64 offerId in _offers) {
      DataOffer offer = widget.getOffer(context, offerId);
      /*
      if (locations.contains(offer.locationId)) {
        continue;
      }
      locations.add(offer.locationId);
      */
      markers.add(Marker(
        width: 56.0 + 8.0, // + 16.0,
        height: 56.0 + 8.0, // + 16.0,
        point: LatLng(offer.latitude, offer.longitude),
        builder: (BuildContext context) {
          return _buildOfferMarker(context, offer);
        },
      ));
    }
    return markers;
  }

  Widget _buildCurrentLocationMarker(BuildContext context) {
    return Material(
      color: Theme.of(context).primaryColor.withAlpha(64),
      shape: CircleBorder(),
      child: Icon(Icons.gps_fixed,
          color: Theme.of(context).accentColor.withAlpha(192)),
    );
  }

  List<Marker> _buildPositionMarkers(BuildContext context) {
    List<Marker> markers = List<Marker>();
    // Show a marker for each account location (business only)
    /*
    if (widget.account.latitude != 0.0 &&
        widget.account.longitude != 0.0) {
      markers.add(new Marker(
        width: 56.0,
        height: 56.0,
        point: new LatLng(widget.account.latitude, widget.account.longitude),
        builder: (ctx) =>
        new Container(
          child: new FlutterLogo(),
        ),
      ));
    }
    */
    // Show a marker for current location
    if (_gpsLatLng != null) {
      markers.add(Marker(
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
    return Stack(
      children: <Widget>[
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            center: _initialLatLng,
            zoom: 13.0,
          ),
          layers: [
            TileLayerOptions(
              backgroundColor: Theme.of(context).brightness == Brightness.light
                  ? Color.fromARGB(0xFF, 0xD1, 0xD1, 0xD1)
                  : Color.fromARGB(0xFF, 0x1C, 0x1C, 0x1C),
              placeholderImage: AssetImage(
                  'assets/placeholder_map_tile.png'), // new MemoryImage(kTransparentImage),
              urlTemplate: widget.mapboxUrlTemplate,
              additionalOptions: {'accessToken': widget.mapboxToken},
            ),
            MarkerLayerOptions(
              markers: _buildPositionMarkers(context),
            ),
            MarkerLayerOptions(
              markers: _buildOfferMarkers(context),
            ),
          ],
        ),
        SafeArea(
          child: Builder(
            builder: (context) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  /*
                  IgnorePointer(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: SizedBox(
                        height: kToolbarHeight * 1.5,
                        child: Image(
                            image:
                                AssetImage("assets/logo_appbar_ext_gray.png")),
                      ),
                    ),
                  ),
                  */
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      ClipOval(
                        child: Material(
                          type: MaterialType.circle,
                          color: Colors.transparent,
                          child: IconButton(
                            padding: EdgeInsets.all(16.0),
                            icon: _gpsLatLng == null
                                ? Icon(Icons.gps_off)
                                : Icon(Icons.gps_fixed),
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
                      SizedBox(height: widget.bottomSpace),
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
