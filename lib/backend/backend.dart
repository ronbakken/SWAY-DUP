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
import 'package:inf/backend/services/image_service_.dart';
import 'package:inf/backend/services/image_service_impl.dart';
import 'package:inf/backend/services/image_service_mock.dart';
import 'package:inf/backend/services/inf_api_service_mock.dart';
import 'package:inf/backend/services/location_service_impl.dart';
import 'package:inf/backend/services/location_service_mock.dart';
import 'package:inf/backend/services/config_service_.dart';
import 'package:inf/backend/services/config_service_mock.dart';
import 'package:inf/backend/services/system_service_.dart';
import 'package:inf/backend/services/system_service_impl.dart';
import 'package:inf/backend/services/system_service_mock.dart';
import 'package:inf/backend/services/inf_api_service_.dart';
import 'package:inf/backend/services/location_service_.dart';
import 'package:inf/backend/managers/offer_manager_.dart';
import 'package:inf/utils/build_config.dart';

import 'package:inf/utils/error_capture.dart';
import 'package:logging/logging.dart';

export 'package:inf/backend/managers/app_manager_.dart';
export 'package:inf/backend/services/auth_service_.dart';
export 'package:inf/backend/managers/user_manager_.dart';
export 'package:inf/backend/services/config_service_.dart';
export 'package:inf/backend/services/system_service_.dart';
export 'package:inf/backend/services/inf_api_service_.dart';
export 'package:inf/backend/services/location_service_.dart';
export 'package:inf/backend/managers/offer_manager_.dart';
export 'package:inf/backend/services/image_service_.dart';

enum AppEnvironment { dev, prod, mock }

GetIt backend = GetIt();

Future<void> setupBackend(AppEnvironment env) async {
  switch (env) {
    case AppEnvironment.dev:
      configureDevLogger();
      registerImplementations();
      await initInfApiService();
      break;
    case AppEnvironment.prod:
      registerImplementations();
      await initInfApiService();
      break;
    case AppEnvironment.mock:
      registerMocks();
      await initInfApiService();
      break;
    default:
      throw new Exception('Unknown backend selected.');
  }
}

void configureDevLogger() {
  // Set up logging options
  hierarchicalLoggingEnabled = true;
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.loggerName}: ${rec.level.name}: ${rec.time}: ${rec.message}');
  });
  new Logger('Inf').level = Level.ALL;
  new Logger('Inf.Network').level = Level.ALL;
  new Logger('Inf.Config').level = Level.ALL;
  new Logger('Switchboard').level = Level.ALL;
  new Logger('Switchboard.Mux').level = Level.ALL;
  new Logger('Switchboard.Talk').level = Level.ALL;
  new Logger('Switchboard.Router').level = Level.ALL;
}

Future<void> initInfApiService() async {
  await backend.get<ConfigService>().init();
  await backend.get<AuthenticationService>().init();
}

void registerImplementations() {
  backend.registerSingleton<ErrorReporter>(ErrorReporter(ApiKeys.sentry));

  // Services
  backend.registerLazySingleton<LocationService>(() => LocationServiceImplementation());
  //backend.registerLazySingleton<AuthenticationService>(
      //() => AuthenticationServiceImplementation(_networkStreaming));
  backend.registerLazySingleton<ConfigService>(() => ResourceServiceMock());
  backend.registerLazySingleton<SystemService>(() => SystemServiceImplementation());
  backend.registerLazySingleton<InfApiService>(() => InfApiServiceMock());
  backend.registerLazySingleton<ImageService>(() => ImageServiceImplementation());

  // Managers
  backend.registerLazySingleton<AppManager>(() => AppManagerImplementation());
  backend.registerLazySingleton<UserManager>(() => UserManagerImplementation());
  backend.registerLazySingleton<OfferManager>(() => OfferManagerImplementation());
}

void registerMocks() {
  backend.registerSingleton<ErrorReporter>(ErrorReporter(ApiKeys.sentry));

  // Services
  backend.registerLazySingleton<LocationService>(() => LocationServiceMock());
  backend.registerLazySingleton<AuthenticationService>(
    /*
    * currentUserIndex
    *   0 = Business
    *   1 = Influencer
    */
    () => AuthenticationServiceMock(
          isLoggedIn: true,
          currentUserIndex: 0,
        ),
  );
  backend.registerLazySingleton<ConfigService>(() => ResourceServiceMock());
  backend.registerLazySingleton<ImageService>(() => ImageServiceMock());
  backend.registerLazySingleton<SystemService>(() => SystemServiceMock(NetworkConnectionState.connected));
  backend.registerLazySingleton<InfApiService>(() => InfApiServiceMock());

  // Managers
  backend.registerLazySingleton<AppManager>(() => AppManagerImplementation());
  backend.registerLazySingleton<UserManager>(() => UserManagerImplementation());
  backend.registerLazySingleton<OfferManager>(() => OfferManagerImplementation());
}
