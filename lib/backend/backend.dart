import 'package:get_it/get_it.dart';
import 'package:inf/backend/api_keys.dart';
import 'package:inf/backend/managers/app_manager_.dart';
import 'package:inf/backend/managers/app_manager_impl.dart';
import 'package:inf/backend/managers/app_manager_mock.dart';
import 'package:inf/backend/services/auth_service_.dart';
import 'package:inf/backend/services/auth_service_impl.dart';
import 'package:inf/backend/services/auth_service_mock.dart';

import 'package:inf/utils/error_capture.dart';

export 'package:inf/backend/managers/app_manager_.dart';
export 'package:inf/backend/services/auth_service_.dart';


enum AppEnvironment { dev, prod, mock }

GetIt backend = new GetIt();

setupBackend(AppEnvironment env) {
  switch (env) {
    case AppEnvironment.dev:
    case AppEnvironment.prod:
      // JAN: This is for you
      //startNetWorkService(env);
      registerImplementations();
    break;
    case AppEnvironment.mock:
      registerMocks();
      break;
    default:
  }
}


void registerImplementations() {
  backend
      .registerSingleton<ErrorReporter>(new ErrorReporter(ApiKeys.sentry));
  
  // Services
  backend.registerLazySingleton<AuthenticationService>(
      () => new AuthenticationServiceImplementation());
  
  // Managers
  backend.registerSingleton<AppManager>(new AppManagerImplementation());
}


void registerMocks() {
  // Services
  backend.registerLazySingleton<AuthenticationService>(
      () => new AuthenticationServiceMock());
  
  // Managers
  backend.registerSingleton<AppManager>(new AppManagerMock());
}
