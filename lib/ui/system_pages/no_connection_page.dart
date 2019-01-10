import 'dart:async';

import 'package:flutter/material.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/ui/widgets/routes.dart';
import 'package:rxdart/rxdart.dart';

// this page can be displayed if we loose connection to our server
// it checks periodically if we have a connection and pops itself if we get one
class NoConnectionPage extends StatefulWidget {
  static Route<dynamic> route() {
    return FadePageRoute(
      builder: (BuildContext context) => NoConnectionPage(),
    );
  }

  @override
  _NoConnectionPageState createState() => _NoConnectionPageState();
}

class _NoConnectionPageState extends State<NoConnectionPage> {
  StreamSubscription _networkStateSubscription;
  StreamSubscription _serverPeriodicCheckSubscription;

  String reason = 'Sorry no connection';

  @override
  void initState() {
    var systemService = backend.get<SystemService>();

    _networkStateSubscription = systemService.connectionStateChanges.listen((state) {
      // if we have a network connection check if the server is online
      if (state != NetworkConnectionState.none) {
        _serverPeriodicCheckSubscription?.cancel();
        _serverPeriodicCheckSubscription = Observable.periodic(Duration(seconds: 10)).startWith(0).listen((_) async {
          // try to reach the server
          if (await backend.get<InfApiClientsService>().isServerAlive()) {
            Navigator.of(context).pop();
          } else {
            setState(() {
              reason = 'There seems to be a problem with our server. Please try again later';
            });
          }
        });
      } else {
        setState(() {
          reason = 'Sorry no network';
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _networkStateSubscription?.cancel();
    _serverPeriodicCheckSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Material(
        child: Center(child: Text(reason)),
      ),
    );
  }
}
