import 'package:flutter/material.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/ui/widgets/routes.dart';

class NoNetworkPage extends StatefulWidget {

  static Route<dynamic> route() {
    return FadePageRoute(
      builder: (BuildContext context) =>
          NoNetworkPage(),
    );
  }


  @override
  _NoNetworkPageState createState() => _NoNetworkPageState();
}

class _NoNetworkPageState extends State<NoNetworkPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      backend.get<SystemService>().connectionStateChanges.listen((state) {
        if (state != NetworkConnectionState.none) {
          Navigator.of(context).pop();
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: () async => false,
          child: Material(
        child: Center(child: Text('Sorry no network')),
      ),
    );
  }
}
