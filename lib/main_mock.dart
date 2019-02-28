import 'dart:async';

import 'package:inf/app/inf_app.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/utils/error_capture.dart';

Future<void> main() async {
  /// By passing a [testRefreshToken] the server returns one of two test users
  /// when 'loginWithToken' is called so that we can test without the need for a real user token
  /// token: 'INF' and influencer
  /// token: 'BUSINESS' a business user
  await setupBackend(mode: AppMode.mock, testRefreshToken: 'INF');

  runCapturedApp(SwayApp(), backend.get<ErrorReporter>());
}
