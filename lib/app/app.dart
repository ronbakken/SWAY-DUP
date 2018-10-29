import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class InfApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Firestore.instance.collection('test').getDocuments();
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
