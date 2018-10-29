import 'package:inf/app/app.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/utils/error_capture.dart';

void main() {
  setupBackend(AppEnvironment.dev);
  
  runCapturedApp(InfApp(), backend<ErrorReporter>());
}



