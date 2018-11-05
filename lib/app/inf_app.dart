import 'package:flutter/material.dart';
import 'package:inf/ui/system/startup_page.dart';

class InfApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'INF',
      theme: ThemeData(
        brightness: Brightness.dark,
        backgroundColor: const Color(0xFF073764),
        primarySwatch: Colors.blue,
      ),
      home: StartupPage(),
    );
  }
}
