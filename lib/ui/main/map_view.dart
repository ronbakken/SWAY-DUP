import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/ui/widgets/inf_asset_image.dart';
import 'package:latlong/latlong.dart';

class MainMapView extends StatefulWidget {
  @override
  _MainMapViewState createState() => _MainMapViewState();
}

class _MainMapViewState extends State<MainMapView> {

  String urlTemplate;
  String mapApiKey;

  @override
    void initState() {
      urlTemplate = backend.get<ResourceService>().getMapUrlTemplate();
      mapApiKey = backend.get<ResourceService>().getMapApiKey();
      super.initState();
    }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        onPositionChanged: onMapPositionChanged,
        center: LatLng(51.5, -0.09),
        zoom: 12.0,
      ),
      layers: [
        TileLayerOptions(
          urlTemplate:urlTemplate,
          additionalOptions: {
            'accessToken':
                mapApiKey,
          },
          backgroundColor: AppTheme.grey,
          placeholderImage: AssetImage(AppImages.mapPlaceHolder.path),
        ),
        MarkerLayerOptions(
          markers: [
            Marker(
              width: 38.0,
              height: 38.0,
              point: LatLng(51.5, -0.09),
              builder: (BuildContext context) {
                return InfAssetImage(
                  AppIcons.mapMarker,
                  width: 38.0,
                  height: 38.0,
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  void onMapPositionChanged(MapPosition position, bool hasGesture) {
    backend.get<InfApiService>().setMapBoundery(
      position.bounds.northWest.latitude, 
      position.bounds.northWest.longitude, 
      position.bounds.southEast.latitude, 
      position.bounds.southEast.longitude,
      position.zoom );
  }
}
