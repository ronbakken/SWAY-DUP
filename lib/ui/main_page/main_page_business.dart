
import 'package:flutter/material.dart';

import 'package:inf/ui/widgets/auth_state_listener_mixin.dart';


class MainPageBusiness extends StatefulWidget {
  @override
  _MainPageBusinessState createState() => _MainPageBusinessState();
}

class _MainPageBusinessState extends State<MainPageBusiness> with AuthStateListenerMixin<MainPageBusiness>{


  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Business MainPage'),);
  }
}