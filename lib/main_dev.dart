import 'package:inf/app/inf_app.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/utils/error_capture.dart';

Future<void> main() async {
  await setupBackend(AppMode.dev);

  runCapturedApp(InfApp(), backend.get<ErrorReporter>());
}
