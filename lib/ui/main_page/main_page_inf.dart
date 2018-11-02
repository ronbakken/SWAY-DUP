import 'package:flutter/material.dart';
import 'package:inf/ui/widgets/auth_state_listener_mixin.dart';
import 'package:inf/ui/widgets/routes.dart';

class MainPageInf extends StatefulWidget {
  static Route<dynamic> route() {
    return FadePageRoute(
      builder: (context) => MainPageInf(),
    );
  }

  @override
  _MainPageInfState createState() => _MainPageInfState();
}

class _MainPageInfState extends State<MainPageInf>
    with AuthStateListenerMixin<MainPageInf> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Influencer MainPage'),
    );
  }
}
