import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/offer_views/offer_details_page.dart';
import 'package:inf/ui/user_profile/view_profile_page.dart';
import 'package:inf/ui/widgets/inf_asset_image.dart';
import 'package:latlong/latlong.dart';

class MainMapView extends StatefulWidget {
  @override
  _MainMapViewState createState() => _MainMapViewState();
}

class _MainMapViewState extends State<MainMapView> {
  ListManager _listManager;
  MapController _mapController;
  StreamSubscription _subLocation;
  Timer _mapPosDebounce;

  @override
  void initState() {
    super.initState();
    _listManager = backend<ListManager>();
    _mapController = MapController();
    _subLocation = backend<LocationService>().onLocationChanged.listen((newPos) {
      _mapController.move(LatLng(newPos.latitude, newPos.longitude), _mapController.zoom);
    });
  }

  @override
  void dispose() {
    _subLocation?.cancel();
    _mapPosDebounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<InfItem>>(
      stream: _listManager.listItems,
      builder: (context, snapshot) {
        List<Marker> markers;
        if (snapshot.hasData) {
          markers = buildMarkers(snapshot.data);
        }
        var initialCenter = backend<LocationService>().lastLocation;
        return FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            center: LatLng(initialCenter.latitude, initialCenter.longitude),
            onPositionChanged: onMapPositionChanged,
            zoom: 11.0,
          ),
          layers: [
            TileLayerOptions(
              urlTemplate: backend<ConfigService>().mapUrlTemplate,
              additionalOptions: {
                'accessToken': backend<ConfigService>().mapApiKey,
              },
              backgroundColor: AppTheme.grey,
              placeholderImage: AssetImage(AppImages.mapPlaceHolder.path),
            ),
            MarkerLayerOptions(
              markers: markers ?? <Marker>[],
            ),
          ],
        );
      },
    );
  }

  List<Marker> buildMarkers(List<InfItem> items) {
    return items
        .map<Marker>((item) {
          assert(item.latitude != null && item.longitude != null);
          switch (item.type) {
            case InfItemType.offer:
              return Marker(
                width: 38.0,
                height: 38.0,
                point: LatLng(item.latitude, item.longitude),
                builder: (BuildContext context) {
                  return _OfferMarker(
                    offer: item.offer,
                    onPressed: () => onOfferClicked(item.offer),
                  );
                },
              );
            case InfItemType.user:
              return Marker(
                width: 38.0,
                height: 38.0,
                point: LatLng(item.latitude, item.longitude),
                builder: (BuildContext context) {
                  return _UserMarker(
                    user: item.user,
                    onPressed: () => onUserClicked(item.user),
                  );
                },
              );
            case InfItemType.map:
              return Marker(
                width: 38.0,
                height: 38.0,
                point: LatLng(item.latitude, item.longitude),
                builder: (BuildContext context) {
                  if (item.user != null) {
                    return _UserMarker(
                      user: item.user,
                      onPressed: () => onUserClicked(item.user),
                    );
                  } else if (item.offer != null) {
                    return _OfferMarker(
                      offer: item.offer,
                      onPressed: () => onOfferClicked(item.offer),
                    );
                  }
                },
              );
            default:
              return null;
          }
        })
        .where((marker) => marker != null)
        .toList();
  }

  void onOfferClicked(BusinessOffer offer) {
    final offerStream = Stream.fromFuture(backend<OfferManager>().getFullOffer(offer.id));
    Navigator.of(context).push(OfferDetailsPage.route(offerStream));
  }

  void onUserClicked(User user) {
    Navigator.of(context).push(ViewProfilePage.route(user));
  }

  void onMapPositionChanged(MapPosition pos, bool hasGesture, bool isUserGesture) {
    _mapPosDebounce?.cancel();
    _mapPosDebounce = Timer(const Duration(milliseconds: 500), () {
      _listManager.setMapBoundary(
        pos.bounds.northWest.latitude,
        pos.bounds.northWest.longitude,
        pos.bounds.southEast.latitude,
        pos.bounds.southEast.longitude,
        pos.zoom.toInt(),
      );
    });
  }
}

class _OfferMarker extends StatelessWidget {
  const _OfferMarker({
    Key key,
    @required this.offer,
    this.onPressed,
  }) : super(key: key);

  final BusinessOffer offer;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final iconAsset = offer.categoryIconAsset;
    return Material(
      type: MaterialType.canvas,
      color: AppTheme.lightBlue,
      shape: const CircleBorder(
        side: BorderSide(color: Colors.white),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkResponse(
        onTap: onPressed,
        child: Center(
          child: iconAsset != null
              ? InfAssetImage(
                  iconAsset,
                  width: 16,
                  height: 16,
                )
              : const Icon(Icons.not_listed_location),
        ),
      ),
    );
  }
}

class _UserMarker extends StatelessWidget {
  const _UserMarker({
    Key key,
    @required this.user,
    this.onPressed,
  }) : super(key: key);

  final User user;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.canvas,
      color: AppTheme.lightBlue,
      shape: const CircleBorder(
        side: BorderSide(color: Colors.white),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkResponse(
        onTap: onPressed,
        child: const Center(
          child: Icon(Icons.person),
        ),
      ),
    );
  }
}
