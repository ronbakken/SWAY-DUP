import 'package:inf/app/inf_app.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/utils/error_capture.dart';

void main() {
  setupBackend(AppMode.prod);

  /// runCapturedApp ensures that exceptions will be reported to Sentry in release mode
  runCapturedApp(SwayApp(), backend.get<ErrorReporter>());
}
