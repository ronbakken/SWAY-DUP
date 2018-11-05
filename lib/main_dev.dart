
import 'package:inf/app/inf_app.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/utils/error_capture.dart';

void main() {
  setupBackend(AppEnvironment.mock);
  
  runCapturedApp(InfApp(), backend.get<ErrorReporter>());
}



