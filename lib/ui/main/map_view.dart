import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/ui/widgets/inf_asset_image.dart';
import 'package:latlong/latlong.dart';

class MainMapView extends StatefulWidget {
  @override
  _MainMapViewState createState() => _MainMapViewState();
}

class _MainMapViewState extends State<MainMapView> {
  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        onPositionChanged: onMapPositionChanged,
        center: LatLng(51.5, -0.09),
        zoom: 12.0,
      ),
      layers: [
        // TODO move the API key and URL at some other place
        TileLayerOptions(
          urlTemplate:
              "https://api.tiles.mapbox.com/v4/mapbox.dark/{z}/{x}/{y}@2x.png"
              "?access_token={accessToken}",
          additionalOptions: {
            'accessToken':
                'pk.eyJ1IjoibmJzcG91IiwiYSI6ImNqa2pkOThmdzFha2IzcG16aHl4M3drNTcifQ.jtaEoGuiomNgllDjUMCwNQ',
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

  void onMapPositionChanged(MapPosition position, bool hasGesture) {}
}
