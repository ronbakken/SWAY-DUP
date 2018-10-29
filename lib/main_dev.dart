import 'package:flutter/material.dart';

void main() => runApp(InfApp());

class InfApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'INF',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: Material(
        color: const Color(0xFF073764),
        child: Center(
          child: Image.asset('assets/images/splash_logo.png'),
        ),
      ),
    );
  }
}
