import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/offer_views/offer_details_page.dart';
import 'package:inf/ui/widgets/inf_memory_image.dart';
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
    urlTemplate = backend<ConfigService>().getMapUrlTemplate();
    mapApiKey = backend<ConfigService>().getMapApiKey();

    mapController = new MapController();

    backend<LocationService>().onLocationChanged.listen((newPos) {
      mapController.move(LatLng(newPos.latitude, newPos.longitude), mapController.zoom);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<InfItem>>(
      stream: backend<ListManager>().filteredListItems,
      builder: (context, snapshot) {
        List<Marker> markers;
        if (snapshot.hasData) {
          markers = buildMarkers(snapshot.data);
        }
        var initialCenter = backend<LocationService>().lastLocation;
        return FlutterMap(
          mapController: mapController,
          options: MapOptions(
            center: LatLng(initialCenter.latitude, initialCenter.longitude),
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
    return items.where((item) => item.type == InfItemType.offer).map<Marker>((item) {
      return Marker(
        width: 38.0,
        height: 38.0,
        point: LatLng(item.latitude, item.longitude),
        builder: (BuildContext context) {
          Uint8List iconData;
          if (item.offer.categories?.isNotEmpty ?? false) {
            if (item.offer.categories[0].parentId.isEmpty) {
              iconData = item.offer.categories[0].iconData;
            } else {
              // fixme: link top categories directly to subcategories at startup in ConfigService
              var topLevelCategory = backend
                  .get<ConfigService>()
                  .topLevelCategories
                  .firstWhere((x) => x.id == item.offer.categories[0].parentId, orElse: null);
              if (topLevelCategory != null) {
                iconData = topLevelCategory.iconData;
              }
            }
          }
          return Material(
            type: MaterialType.canvas,
            color: AppTheme.lightBlue,
            shape: const CircleBorder(
              side: BorderSide(color: Colors.white),
            ),
            clipBehavior: Clip.antiAlias,
            child: InkResponse(
              onTap: () => onMarkerClicked(item),
              child: Center(
                child: iconData != null
                    ? InfMemoryImage(
                        iconData,
                        width: 16,
                        height: 16,
                      )
                    : const Icon(Icons.close),
              ),
            ),
          );
        },
      );
    }).toList();
  }

  void onMarkerClicked(InfItem item) {
    Navigator.of(context)
        .push(OfferDetailsPage.route(Stream.fromFuture(backend<OfferManager>().getFullOffer(item.id))));
  }

  void onMapPositionChanged(MapPosition pos, bool hasGesture) {
    mapPosition = pos;
    backend<ListManager>().setMapBoundary(pos.bounds.northWest.latitude, pos.bounds.northWest.longitude,
        pos.bounds.southEast.latitude, pos.bounds.southEast.longitude, pos.zoom);
  }
}
