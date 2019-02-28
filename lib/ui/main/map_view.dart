import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/offer_views/offer_details_page.dart';
import 'package:inf/ui/widgets/inf_asset_image.dart';
import 'package:inf_api_client/inf_api_client.dart';
import 'package:latlong/latlong.dart';

class MainMapView extends StatefulWidget {
  @override
  _MainMapViewState createState() => _MainMapViewState();
}

class _MainMapViewState extends State<MainMapView> {
  String urlTemplate;
  String mapApiKey;
  MapController mapController;
  MapPosition mapPosition;

  @override
  void initState() {
    urlTemplate = backend.get<ConfigService>().getMapUrlTemplate();
    mapApiKey = backend.get<ConfigService>().getMapApiKey();

    mapController = new MapController();

    backend.get<LocationService>().onLocationChanged.listen((newPos) {
      mapController.move(LatLng(newPos.latitude, newPos.longitude), mapController.zoom);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<InfItem>>(
      stream: backend.get<ListManager>().filteredListItems,
      builder: (context, snapshot) {
        List<Marker> markers;
        if (snapshot.hasData) {
          markers = buildMarkers(snapshot.data);
        }
        return FlutterMap(
          mapController: mapController,
          options: MapOptions(
            onPositionChanged: onMapPositionChanged,
            zoom: 12.0,
          ),
          layers: [
            TileLayerOptions(
              urlTemplate: urlTemplate,
              additionalOptions: {
                'accessToken': mapApiKey,
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
    // TODO implement fading of markers with Simon
    var markerList = <Marker>[];
    for (var item in items) {
      AppAsset markerAsset;
      Widget markerWidget;

      if (item.type == InfItemType.offer) {
        markerAsset = AppIcons.mapMarker;

        markerList.add(
          Marker(
            width: 38.0,
            height: 38.0,
            point: LatLng(item.latitude, item.longitude),
            builder: (BuildContext context) {
              return InkResponse(
                onTap: () => onMarkerClicked(item),
                child: InfAssetImage(
                  markerAsset,
                  width: 38.0,
                  height: 38.0,
                ),
              );
              ;
            },
          ),
        );
      }
    }
    return markerList;
  }

  void onMarkerClicked(InfItem item) {
    Navigator.of(context)
        .push(OfferDetailsPage.route(Stream.fromFuture(backend.get<OfferManager>().getFullOffer(item.id))));
  }

  void onMapPositionChanged(MapPosition position, bool hasGesture) {
    mapPosition = position;
    backend.get<InfApiService>().setMapBoundary(position.bounds.northWest.latitude, position.bounds.northWest.longitude,
        position.bounds.southEast.latitude, position.bounds.southEast.longitude, position.zoom);
  }
}

class _ClusterMarker extends StatelessWidget {
  const _ClusterMarker({
    Key key,
    @required this.mapMarker,
  }) : super(key: key);

  final MapMarker mapMarker;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(left: 7.5, top: 5.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 1.0),
            color: AppTheme.blue,
            shape: BoxShape.circle,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(right: 3.75, left: 3.75, top: 2.5, bottom: 2.5),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 1.0),
            color: AppTheme.blue,
            shape: BoxShape.circle,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(right: 7.5, bottom: 5.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 1.0),
            color: AppTheme.blue,
            shape: BoxShape.circle,
          ),
          child: ClipOval(
            child: Center(
              child: Text(
                mapMarker.clusterCount.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 18.0),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
