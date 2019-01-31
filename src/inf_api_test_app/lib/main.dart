import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:inf_api_test_app/api_tester.dart';
import 'package:inf_api_test_app/build_config.dart';

void main() async {
  final host = "inf-dev-cluster.australiaeast.cloudapp.azure.com";
  final port = 9026;
  runApp(MyApp(host: host, port: port));
}

class MyApp extends StatefulWidget {
  final String host;
  final int port;

  const MyApp({
    Key key,
    @required this.host,
    @required this.port,
  }) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  Uint8List svgData;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter Demo Home Page'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              svgData != null
                  ? SvgPicture.memory(
                      svgData,
                      width: 50,
                      height: 50,
                      color: Colors.blue,
                    )
                  : SizedBox(),
              RaisedButton(
                onPressed: () => apiTester.connectToServer(widget.host, widget.port),
                child: Center(
                  child: Text('Connect'),
                ),
              ),
              RaisedButton(
                onPressed: () async {
                  var imageData = await apiTester.getAppConfig();
                  setState(() {
                    svgData = imageData;
                  });
                },
                child: Center(
                  child: Text('Get Config'),
                ),
              ),
              RaisedButton(
                onPressed: () => apiTester.listenToWelcomeImages(),
                child: Center(
                  child: Text('Get WelcomeImages'),
                ),
              ),
              RaisedButton(
                onPressed: () => apiTester.stopWelcomeImages(),
                child: Center(
                  child: Text('Stop WelcomeImages'),
                ),
              ),
              RaisedButton(
                onPressed: () => apiTester.ping(),
                child: Center(
                  child: Text('Ping Server'),
                ),
              ),
              RaisedButton(
                onPressed: () => apiTester.loginWithToken(),
                child: Center(
                  child: Text('Login With Token'),
                ),
              ),
              RaisedButton(
                onPressed: () => apiTester.requestUploadLink(),
                child: Center(
                  child: Text('Request upload URL'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
