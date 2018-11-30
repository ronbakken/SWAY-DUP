import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/widgets/inf_asset_image.dart';
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
    urlTemplate = backend.get<ResourceService>().getMapUrlTemplate();
    mapApiKey = backend.get<ResourceService>().getMapApiKey();

    mapController = new MapController();

    backend.get<LocationService>().onLocationChanged.listen((newPos) {
      mapController.move(
          LatLng(newPos.latitude, newPos.longitude), mapController.zoom);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<MapMarker>>(
      stream: backend.get<InfApiService>().getMapMarkers(),
      builder: (context, snapshot) {
        List<Marker> markers;
        if (snapshot.hasData) {
          markers = buildMarkers(snapshot.data);
        }
        return FlutterMap(
          mapController: mapController,
          options: MapOptions(
            onPositionChanged: onMapPositionChanged,
            zoom: 11.6,
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

  List<Marker> buildMarkers(List<MapMarker> mapMarkers) {
    // TODO implement fading of markers with Simon
    var markerList = <Marker>[];
    for (var mapMarker in mapMarkers) {
      AppAsset markerAsset;
      Widget markerWidget;
      if (mapMarker.type == MapMarkerType.cluster) {
        markerWidget = new _ClusterMarker(mapMarker: mapMarker);
      } else {
        if (mapMarker.isDirectOffer ?? false) {
          markerAsset = AppIcons.mapMarkerDirectOffer;
        } else if (mapMarker.userType != null &&
            mapMarker.userType == AccountType.business) {
          markerAsset = AppIcons.mapMarkerBusiness;
        } else {
          markerAsset = AppIcons.mapMarker;
        }
        markerWidget = InfAssetImage(
          markerAsset,
          width: 38.0,
          height: 38.0,
        );
      }
      markerList.add(
        Marker(
          width: 38.0,
          height: 38.0,
          point: LatLng(mapMarker.latitude, mapMarker.longitude),
          builder: (BuildContext context) {
            return markerWidget;
          },
        ),
      );
    }
    return markerList;
  }

  void onMapPositionChanged(MapPosition position, bool hasGesture) {
    mapPosition = position;
    backend.get<InfApiService>().setMapBoundery(
        position.bounds.northWest.latitude,
        position.bounds.northWest.longitude,
        position.bounds.southEast.latitude,
        position.bounds.southEast.longitude,
        position.zoom);
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
          margin: const EdgeInsets.only(
              right: 3.75, left: 3.75, top: 2.5, bottom: 2.5),
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
