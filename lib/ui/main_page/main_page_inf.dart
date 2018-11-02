
import 'package:flutter/material.dart';
import 'package:inf/ui/widgets/auth_state_listener_mixin.dart';

class MainPageInf extends StatefulWidget {
  @override
  _MainPageInfState createState() => _MainPageInfState();
}

class _MainPageInfState extends State<MainPageInf> with AuthStateListenerMixin<MainPageInf>{

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Influencer MainPage'),);
  }
}
