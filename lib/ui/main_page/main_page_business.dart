
import 'package:flutter/material.dart';

import 'package:inf/ui/widgets/auth_state_listener_mixin.dart';
import 'package:inf/ui/widgets/routes.dart';


class MainPageBusiness extends StatefulWidget {
  static Route<dynamic> route() {
    return FadePageRoute(
      builder: (context) => MainPageBusiness(),
    );
  }
  
  @override
  _MainPageBusinessState createState() => _MainPageBusinessState();
}

class _MainPageBusinessState extends State<MainPageBusiness> with AuthStateListenerMixin<MainPageBusiness>{


  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Business MainPage'),);
  }
}