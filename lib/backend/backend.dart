import 'package:get_it/get_it.dart';
import 'package:inf/backend/api_keys.dart';
import 'package:inf/backend/managers/app_manager_.dart';
import 'package:inf/backend/managers/app_manager_impl.dart';
import 'package:inf/backend/managers/user_manager_impl.dart';

import 'package:inf/backend/services/auth_service_.dart';
import 'package:inf/backend/services/auth_service_impl.dart';
import 'package:inf/backend/services/auth_service_mock.dart';
import 'package:inf/backend/managers/user_manager_.dart';
import 'package:inf/backend/services/resource_service_.dart';
import 'package:inf/backend/services/resource_service_impl.dart';
import 'package:inf/backend/services/resource_service_mock.dart';
import 'package:inf/backend/services/connection_service_.dart';
import 'package:inf/backend/services/connection_service_impl.dart';
import 'package:inf/backend/services/connection_service_mock.dart';


import 'package:inf/utils/error_capture.dart';

export 'package:inf/backend/managers/app_manager_.dart';
export 'package:inf/backend/services/auth_service_.dart';
export 'package:inf/backend/managers/user_manager_.dart';
export 'package:inf/backend/services/resource_service_.dart';
export 'package:inf/backend/services/connection_service_.dart';

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
  backend.registerSingleton<ErrorReporter>(new ErrorReporter(ApiKeys.sentry));

  // Services
  backend.registerLazySingleton<AuthenticationService>(
      () => new AuthenticationServiceImplementation());
  backend.registerLazySingleton<ResourceService>(
      () => new ResourceServiceImplementation());
  backend.registerLazySingleton<ConnectionService>(
      () => new ConnectionServiceImplementation());

  // Managers
  backend
      .registerLazySingleton<AppManager>(() => new AppManagerImplementation());
  backend.registerLazySingleton<UserManager>(
      () => new UserManagerImplementation());
}

void registerMocks() {
  backend.registerSingleton<ErrorReporter>(new ErrorReporter(ApiKeys.sentry));
  // Services
  backend.registerLazySingleton<AuthenticationService>(
      () => new AuthenticationServiceMock(
            isLoggedIn: false,
//            currentUser: 0
          ));
  backend
      .registerLazySingleton<ResourceService>(() => new ResourceServiceMock());
  backend
      .registerLazySingleton<ConnectionService>(() => new ConnectionServiceMock(NetWorkConnectionState.connected));

  // Managers
  backend
      .registerLazySingleton<AppManager>(() => new AppManagerImplementation());
  backend.registerLazySingleton<UserManager>(
      () => new UserManagerImplementation());
}
