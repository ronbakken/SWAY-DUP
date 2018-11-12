import 'package:get_it/get_it.dart';
import 'package:inf/backend/api_keys.dart';
import 'package:inf/backend/managers/app_manager_.dart';
import 'package:inf/backend/managers/app_manager_impl.dart';
import 'package:inf/backend/managers/offer_manager_impl.dart';
import 'package:inf/backend/managers/user_manager_impl.dart';

import 'package:inf/backend/services/auth_service_.dart';
import 'package:inf/backend/services/auth_service_impl.dart';
import 'package:inf/backend/services/auth_service_mock.dart';
import 'package:inf/backend/managers/user_manager_.dart';
import 'package:inf/backend/services/network_service_impl.dart';
import 'package:inf/backend/services/network_service_mock.dart';
import 'package:inf/backend/services/resource_service_.dart';
import 'package:inf/backend/services/resource_service_impl.dart';
import 'package:inf/backend/services/resource_service_mock.dart';
import 'package:inf/backend/services/system_service_.dart';
import 'package:inf/backend/services/system_service_impl.dart';
import 'package:inf/backend/services/system_service_mock.dart';
import 'package:inf/backend/services/network_service_.dart';
import 'package:inf/backend/managers/offer_manager_.dart';

import 'package:inf/utils/error_capture.dart';

export 'package:inf/backend/managers/app_manager_.dart';
export 'package:inf/backend/services/auth_service_.dart';
export 'package:inf/backend/managers/user_manager_.dart';
export 'package:inf/backend/services/resource_service_.dart';
export 'package:inf/backend/services/system_service_.dart';
export 'package:inf/backend/services/network_service_.dart';
export 'package:inf/backend/managers/offer_manager_.dart';

enum AppEnvironment { dev, prod, mock }

GetIt backend = GetIt();

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
  backend.registerSingleton<ErrorReporter>(ErrorReporter(ApiKeys.sentry));

  // Services
  backend.registerLazySingleton<AuthenticationService>(() => AuthenticationServiceImplementation());
  backend.registerLazySingleton<ResourceService>(() => ResourceServiceImplementation());
  backend.registerLazySingleton<SystemService>(() => SystemServiceImplementation());
  backend.registerLazySingleton<NetWorkService>(() => NetworkServiceImplementation());

  // Managers
  backend.registerLazySingleton<AppManager>(() => AppManagerImplementation());
  backend.registerLazySingleton<UserManager>(() => UserManagerImplementation());
  backend.registerLazySingleton<OfferManager>(() => OfferManagerImplementation());
}

void registerMocks() {
  backend.registerSingleton<ErrorReporter>(ErrorReporter(ApiKeys.sentry));
  // Services
  backend.registerLazySingleton<AuthenticationService>(
    () => AuthenticationServiceMock(
          isLoggedIn: false,
          currentUser: 0,
        ),
  );
  backend.registerLazySingleton<ResourceService>(() => ResourceServiceMock());
  backend.registerLazySingleton<SystemService>(() => SystemServiceMock(NetworkConnectionState.connected));
  backend.registerLazySingleton<NetWorkService>(() => NetworkServiceMock());

  // Managers
  backend.registerLazySingleton<AppManager>(() => AppManagerImplementation());
  backend.registerLazySingleton<UserManager>(() => UserManagerImplementation());
  backend.registerLazySingleton<OfferManager>(() => OfferManagerImplementation());
}
