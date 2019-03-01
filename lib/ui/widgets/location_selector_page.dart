import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/widgets/animated_curves.dart';
import 'package:inf/ui/widgets/inf_asset_image.dart';
import 'package:inf/ui/widgets/inf_icon.dart';
import 'package:inf/ui/widgets/inf_stadium_button.dart';
import 'package:latlong/latlong.dart';
import 'package:rx_command/rx_command.dart';

export 'package:inf/domain/location.dart';

class LocationSelectorPage extends StatefulWidget {
  const LocationSelectorPage({Key key, this.location}) : super(key: key);

  static Route<Location> route({Location location}) {
    return PageRouteBuilder(
      pageBuilder: (BuildContext context, _, __) {
        return LocationSelectorPage(
          location: location,
        );
      },
      transitionsBuilder: (BuildContext context, Animation<double> animation, _, Widget child) {
        final slide = Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset.zero).animate(animation);
        return SlideTransition(
          position: slide,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 650),
      opaque: true,
    );
  }

  final Location location;

  @override
  _LocationSelectorPageState createState() => _LocationSelectorPageState();
}

class _LocationSelectorPageState extends State<LocationSelectorPage> with SingleTickerProviderStateMixin {
  TabController _controller;

  final ValueNotifier<Coordinate> searchLocation = ValueNotifier<Coordinate>(null);
  final ValueNotifier<GeoCodingResult> selectedLocation = ValueNotifier<GeoCodingResult>(null);

  @override
  void initState() {
    _controller = TabController(length: 3, vsync: this);

    _controller.addListener(() => FocusScope.of(context).requestFocus(new FocusNode()));

    searchLocation.value = widget.location ?? backend<LocationService>().lastLocation;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: AppTheme.listViewAndMenuBackground,
      appBar: AppBar(
        title: Text('SELECT YOUR LOCATION'),
        backgroundColor: AppTheme.lightBlue,
        centerTitle: true,
      ),
      body: Container(
        child: Stack(
          fit: StackFit.passthrough,
          alignment: Alignment.bottomCenter,
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: CustomAnimatedCurves(),
            ),
            SafeArea(
              child: Column(
                children: [
                  TabBar(
                    controller: _controller,
                    indicatorColor: AppTheme.lightBlue,
                    isScrollable: false,
                    tabs: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Text('NEARBY'),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Text('SEARCH'),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Text('MAP'),
                      ),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _controller,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        _NearbyView(
                          searchLocation: searchLocation,
                          selectedLocation: selectedLocation,
                        ),
                        _SearchView(
                          searchLocation: searchLocation,
                          selectedLocation: selectedLocation,
                        ),
                        _MapView(
                          searchLocation: searchLocation,
                          selectedLocation: selectedLocation,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 32.0),
                    child: InfStadiumButton(
                      height: 56,
                      color: Colors.white,
                      text: 'DONE',
                      onPressed: onDone,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onDone() {
    var geoLocation = selectedLocation.value;
    Location location;
    if (geoLocation != null) {
      location = Location(
        name: geoLocation.name,
        latitude: geoLocation.coordinate.latitude,
        longitude: geoLocation.coordinate.longitude,
      );
    }
    Navigator.of(context).pop<Location>(location);
  }
}

class _NearbyView extends StatefulWidget {
  final ValueNotifier<Coordinate> searchLocation;
  final ValueNotifier<GeoCodingResult> selectedLocation;

  const _NearbyView({Key key, @required this.searchLocation, @required this.selectedLocation}) : super(key: key);

  @override
  __NearbyViewState createState() => __NearbyViewState();
}

class __NearbyViewState extends State<_NearbyView> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<GeoCodingResult>>(
      future: backend<LocationService>().lookUpCoordinates(position: widget.searchLocation.value),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          // TODO add Spinner
          return SizedBox();
        }
        if (snapshot.hasError || !snapshot.hasData) {
          // TODO handle Error
          return SizedBox();
        }

        return _LocationList(
          locations: snapshot.data,
          onLocationSelected: (loc) => widget.selectedLocation.value = loc,
        );
      },
    );
  }
}

class _SearchView extends StatefulWidget {
  final ValueNotifier<Coordinate> searchLocation;
  final ValueNotifier<GeoCodingResult> selectedLocation;

  const _SearchView({Key key, @required this.searchLocation, @required this.selectedLocation}) : super(key: key);

  @override
  __SearchViewState createState() => __SearchViewState();
}

class __SearchViewState extends State<_SearchView> {
  RxCommand<String, String> searchTextChangedCommand;

//  RxCommand<String, Observable<List<GeoCodingResult>>> searchPlaceCommand;
  RxCommand<String, List<GeoCodingResult>> searchPlaceCommand;

  // Observable<List<GeoCodingResult>> get searchResults =>
  //     Observable.switchLatest(searchPlaceCommand).asBroadcastStream();

  @override
  void initState() {
    searchTextChangedCommand = RxCommand.createSync((s) => s);

    searchPlaceCommand = RxCommand.createAsync((s) {
      return backend
          .get<LocationService>()
          .lookUpPlaces(nearby: backend<LocationService>().lastLocation, searchText: s);
    });

    searchTextChangedCommand
        .where((s) => s.isNotEmpty)
        .debounce(Duration(milliseconds: 500))
        .listen(searchPlaceCommand);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: const ShapeDecoration(shape: StadiumBorder(), color: AppTheme.white12),
            child: TextField(
              onChanged: searchTextChangedCommand,
              decoration: InputDecoration(
                border: InputBorder.none,
                icon: InfAssetImage(
                  AppIcons.search,
                  height: 24.0,
                ),
              ),
              keyboardAppearance: Brightness.dark,
            ),
          ),
          Expanded(
            child: _SearchResultListener(
              stream: searchPlaceCommand,
              onLocationSelected: (loc) {
                widget.searchLocation.value = loc.coordinate;
                return widget.selectedLocation.value = loc;
              },
            ),
          )
        ],
      ),
    );
  }
}

class _MapView extends StatefulWidget {
  final ValueNotifier<Coordinate> searchLocation;
  final ValueNotifier<GeoCodingResult> selectedLocation;

  const _MapView({Key key, @required this.searchLocation, @required this.selectedLocation}) : super(key: key);

  @override
  __MapViewState createState() => __MapViewState();
}

class __MapViewState extends State<_MapView> {
  String urlTemplate;
  String mapApiKey;
  MapController mapController;
  MapPosition mapPosition;

  RxCommand<MapPosition, Coordinate> positionChangedCommand;
  RxCommand<Coordinate, List<GeoCodingResult>> searchPlaceCommand;

  @override
  void initState() {
    urlTemplate = backend<ConfigService>().getMapUrlTemplate();
    mapApiKey = backend<ConfigService>().getMapApiKey();

    positionChangedCommand = RxCommand.createSync((pos) => Coordinate(pos.center.latitude, pos.center.longitude));

    searchPlaceCommand = RxCommand.createAsync((pos) {
      return backend<LocationService>().lookUpCoordinates(position: pos);
    }, emitLastResult: true);

    positionChangedCommand.debounce(Duration(milliseconds: 1000)).listen(searchPlaceCommand);

    mapController = new MapController();

    super.initState();
  }

  void onMapPositionChanged(MapPosition position, bool hasGesture) {
    mapPosition = position;
    positionChangedCommand(position);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1.0,
          child: Stack(
            children: [
              FlutterMap(
                mapController: mapController,
                options: MapOptions(
                  center: LatLng(widget.searchLocation.value.latitude, widget.searchLocation.value.longitude),
                  onPositionChanged: onMapPositionChanged,
                  zoom: 14,
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
                ],
              ),
              IgnorePointer(
                ignoring: true,
                child: CustomPaint(
                  child: Container(),
                  painter: _CrosshairPainter(),
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: _SearchResultListener(
            stream: searchPlaceCommand,
            onLocationSelected: (loc) => widget.selectedLocation.value = loc,
          ),
        ),
      ],
    );
  }
}

class _CrosshairPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = AppTheme.lightBlue
      ..strokeWidth = 0.75;
    canvas.drawLine(size.topCenter(Offset.zero), size.bottomCenter(Offset.zero), paint);
    canvas.drawLine(size.centerLeft(Offset.zero), size.centerRight(Offset.zero), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class _SearchResultListener extends StatelessWidget {
  final ValueChanged<GeoCodingResult> onLocationSelected;

  const _SearchResultListener({Key key, @required this.stream, @required this.onLocationSelected}) : super(key: key);

  final Stream<List<GeoCodingResult>> stream;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<GeoCodingResult>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          // TODO make beautiful
          return Center(child: Text('Sorry there is a problem with our location search service'));
        }
        if (!snapshot.hasData) {
          return SizedBox();
        }
        return _LocationList(
          locations: snapshot.data,
          onLocationSelected: onLocationSelected,
        );
      },
    );
  }
}

class _LocationList extends StatefulWidget {
  final List<GeoCodingResult> locations;
  final ValueChanged<GeoCodingResult> onLocationSelected;

  _LocationList({Key key, this.locations, this.onLocationSelected}) : super(key: key);

  @override
  _LocationListState createState() {
    return new _LocationListState();
  }
}

class _LocationListState extends State<_LocationList> {
  GeoCodingResult selectedResult;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: widget.locations.length,
      separatorBuilder: (BuildContext context, int index) {
        return Container(
          margin: const EdgeInsets.only(left: 64.0 + 16.0, right: 16.0),
          color: AppTheme.white30,
          height: 1.0,
        );
      },
      itemBuilder: (BuildContext context, int index) {
        var fullName = widget.locations[index].name;
        var firstCommaPos = fullName.indexOf(',');

        var textLines = <Widget>[];

        if (firstCommaPos > 0) {
          textLines
            ..add(
              Text(
                fullName.substring(0, firstCommaPos + 1),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white),
              ),
            )
            ..add(
              Text(
                fullName.substring(firstCommaPos + 2),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: AppTheme.white30),
              ),
            );
        } else {
          textLines.add(Text(
            fullName,
            overflow: TextOverflow.ellipsis,
          ));
        }
        return InkWell(
          onTap: () {
            setState(() {
              selectedResult = widget.locations[index];
            });
            widget.onLocationSelected(selectedResult);
          },
          child: Container(
            padding: const EdgeInsets.only(right: 16.0),
            height: 72.0,
            child: Row(
              children: [
                Container(
                  width: 64.0,
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.white12,
                    ),
                    child: InfAssetImage(
                      AppIcons.location,
                      color: Colors.white,
                      width: 24.0,
                      height: 24.0,
                    ),
                  ),
                ),
                SizedBox(
                  width: 16.0,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: textLines,
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                widget.locations[index] == selectedResult
                    ? Container(
                        width: 35.0,
                        padding: const EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.lightBlue,
                        ),
                        child: InfIcon(AppIcons.check),
                      )
                    : SizedBox(),
              ],
            ),
          ),
        );
      },
    );
  }
}
