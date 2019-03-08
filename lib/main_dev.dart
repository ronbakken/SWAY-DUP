import 'dart:async';

import 'package:inf/app/inf_app.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/utils/error_capture.dart';

import 'package:flutter/services.dart' show rootBundle;

Future<void> main() async {
  await setupBackend(mode: AppMode.dev, assetLoader: rootBundle.load);

  runCapturedApp(SwayApp(), backend<ErrorReporter>());
}
