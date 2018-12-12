import 'package:flutter/material.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/widgets/inf_asset_image.dart';
import 'package:inf/ui/widgets/inf_stadium_button.dart';
import 'package:rx_command/rx_command.dart';
import 'package:rxdart/rxdart.dart';

class LocationSelectorPage extends StatefulWidget {
  static Route<Location> route() {
    return PageRouteBuilder(
      pageBuilder: (BuildContext context, _, __) {
        return LocationSelectorPage();
      },
      transitionsBuilder:
          (BuildContext context, Animation<double> animation, _, Widget child) {
        final slide = Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset.zero)
            .animate(animation);
        return SlideTransition(
          position: slide,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 650),
      opaque: true,
    );
  }

  @override
  _LocationSelectorPageState createState() => _LocationSelectorPageState();
}

class _LocationSelectorPageState extends State<LocationSelectorPage>
    with SingleTickerProviderStateMixin {
  TabController _controller;

  @override
  void initState() {
    _controller = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.locationSelectorBackground,
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
            InfAssetImage(
              AppImages.mockCurves, // FIXME:
              alignment: Alignment.bottomCenter,
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
                      children: [_NearbyView(), _SearchView(), _MapView()],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32.0, vertical: 32.0),
                    child: InfStadiumButton(
                      height: 56,
                      color: Colors.white,
                      text: 'DONE',
                      onPressed: () {},
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
}

class _NearbyView extends StatefulWidget {
  @override
  __NearbyViewState createState() => __NearbyViewState();
}

class __NearbyViewState extends State<_NearbyView> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<GeoCodingResult>>(
      future: backend.get<LocationService>().lookUpCoordinates(
          position: backend.get<LocationService>().lastLocation),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          // TODO add Spinner
          return SizedBox();
        }
        if (snapshot.hasError || !snapshot.hasData) {
          // TODO handle Error
          return SizedBox();
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: new _LocationList(locations: snapshot.data),
        );
      },
    );
  }
}

class _SearchView extends StatefulWidget {
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

    searchPlaceCommand = RxCommand.createAsync((s)  {
      return backend.get<LocationService>().lookUpPlaces(
            nearby: backend.get<LocationService>().lastLocation, searchText: s);
    }, emitLastResult: true);

    searchTextChangedCommand
        .where((s) => s.isNotEmpty)
        .debounce(Duration(milliseconds: 500))
        .doOnData((s ) {
          print(s);
        })
        .listen(searchPlaceCommand);

    // searchTextChangedCommand = RxCommand.createSync((s) => s);

    // searchPlaceCommand = RxCommand.createAsync((s) async {
    //   return Observable.just(
    //     await backend.get<LocationService>().lookUpPlaces(
    //         nearby: backend.get<LocationService>().lastLocation, searchText: s),
    //   );
    // }, emitLastResult: true);

    // searchTextChangedCommand
    //     .where((s) => s.isNotEmpty)
    //     .debounce(Duration(milliseconds: 500))
    //     .listen(searchPlaceCommand);

    // searchResults.listen((s) {
    //   print(s);
    // });

    super.initState();
  }

  // void initState() {
  //   searchTextChangedCommand = RxCommand.createSync((s) => s);

  //   searchPlaceCommand = RxCommand.createAsync((s) async {
  //     return Observable.just(
  //       await backend.get<LocationService>().lookUpPlaces(
  //           nearby: backend.get<LocationService>().lastLocation, searchText: s),
  //     );
  //   }, emitLastResult: true);

  //   searchTextChangedCommand
  //       .where((s) => s.isNotEmpty)
  //       .debounce(Duration(milliseconds: 500))
  //       .listen(searchPlaceCommand);

  //   searchResults.listen((s) {
  //     print(s);
  //   });

  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        TextField(
          onChanged: searchTextChangedCommand,
        ),
        Expanded(
          child: StreamBuilder<List<GeoCodingResult>>(
            stream: searchPlaceCommand,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                // TODO make beautiful
                return Center(
                    child: Text(
                        'Sorry there is a problem with our location search service'));
              }
              if (!snapshot.hasData) {
                return SizedBox();
              }
              return _LocationList(
                locations: snapshot.data,
              );
            },
          ),
        )
      ],
    );
  }
}

class _MapView extends StatefulWidget {
  @override
  __MapViewState createState() => __MapViewState();
}

class __MapViewState extends State<_MapView> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class _LocationList extends StatelessWidget {
  final List<GeoCodingResult> locations;

  const _LocationList({Key key, this.locations}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: locations.length,
      separatorBuilder: (BuildContext context, int index) {
        return Container(
          margin: const EdgeInsets.only(left: 48.0, right: 48),
          color: AppTheme.white30,
          height: 1.0,
        );
      },
      itemBuilder: (BuildContext context, int index) {
        var fullName = locations[index].name;
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
        return Row(
          children: [
            Container(
              width: 35.0,
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.white12,
              ),
              child: InfAssetImage(
                AppIcons.location,
                color: Colors.white,
              ),
            ),
            SizedBox(
              width: 16.0,
            ),
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: textLines),
          ],
        );
      },
    );
  }
}
