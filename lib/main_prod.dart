import 'package:flutter/material.dart';
import 'package:inf/app/inf_app.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/utils/error_capture.dart';

import 'package:flutter/services.dart' show rootBundle;

void main() {
  setupBackend(mode: AppMode.prod, assetLoader: rootBundle.load);

  /// Replace Red/Yellow ErrorWidget with custom one for production releases.
  ErrorWidget.builder = (FlutterErrorDetails details) => const Center(child: Text('An error occurred'));

  /// runCapturedApp ensures that exceptions will be reported to Sentry in release mode
  runCapturedApp(const SwayApp(), backend<ErrorReporter>());
}
