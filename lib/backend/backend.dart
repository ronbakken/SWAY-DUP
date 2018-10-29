import 'package:get_it/get_it.dart';
import 'package:inf/backend/api_keys.dart';
import 'package:inf/utils/error_capture.dart';

enum AppEnvironment {
	dev,
	prod,
}


GetIt backend = new GetIt();

setupBackend(AppEnvironment env)
{
    backend.registerSingleton<ErrorReporter>(new ErrorReporter(ApiKeys.sentry));

}