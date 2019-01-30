import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:inf/backend/api_keys.dart';
import 'package:inf/backend/managers/app_manager_.dart';
import 'package:inf/backend/managers/app_manager_impl.dart';
import 'package:inf/backend/managers/offer_manager_impl.dart';
import 'package:inf/backend/managers/user_manager_impl.dart';

import 'package:inf/backend/services/auth_service_.dart';
import 'package:inf/backend/services/auth_service_impl.dart';

import 'package:inf/backend/managers/user_manager_.dart';
import 'package:inf/backend/services/config_service_impl.dart';
import 'package:inf/backend/services/image_service_.dart';
import 'package:inf/backend/services/image_service_impl.dart';
import 'package:inf/backend/services/inf_api_clients_service_.dart';
import 'package:inf/backend/services/inf_api_clients_service_impl.dart';
import 'package:inf/backend/services/inf_api_service_mock.dart';
import 'package:inf/backend/services/location_service_mock.dart';
import 'package:inf/backend/services/config_service_.dart';
import 'package:inf/backend/services/system_service_.dart';
import 'package:inf/backend/services/system_service_impl.dart';

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
export 'package:inf/backend/services/inf_api_clients_service_.dart';
export 'package:inf/utils/error_capture.dart' show ErrorReporter;
export 'package:grpc/grpc.dart' show GrpcError, CallOptions;

enum AppMode { dev, prod, mock }

class AppEnvironment {
  final AppMode mode;
  final String host;
  final int port;

  AppEnvironment({this.mode, this.host, this.port});
}

GetIt backend = GetIt();
AppEnvironment appEnvironment;

Future<void> setupBackend(AppMode mode) async {
  switch (mode) {
    case AppMode.dev:
      appEnvironment = AppEnvironment(
        mode: AppMode.dev,
        host: 'inf-dev-cluster.australiaeast.cloudapp.azure.com',
        port: 9026,
      );
      configureDevLogger();
      registerImplementations();
      break;
    case AppMode.prod:
      appEnvironment = AppEnvironment(
        mode: AppMode.prod,
        host: 'api.staging.infdev.net',
        port: -1,
      );
      registerImplementations();
      break;
    case AppMode.mock:
      appEnvironment = AppEnvironment(
        mode: AppMode.mock,
        host: await BuildConfig.instance['API_HOST'],
        port: 8080,
      );
      configureDevLogger();
      registerImplementations();
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

Future<void> initBackend() async {
  backend.get<InfApiClientsService>().init(appEnvironment.host, appEnvironment.port);
  // TODO handle case that App must be updated
  await backend.get<ConfigService>().init();
}

void registerImplementations() {
  backend.registerSingleton<ErrorReporter>(ErrorReporter(ApiKeys.sentry));

  // Services
  backend.registerLazySingleton<ConfigService>(() => ConfigServiceImplementation());
  backend.registerLazySingleton<LocationService>(() => LocationServiceMock());
  backend.registerSingleton<InfApiClientsService>(InfApiClientsServiceImplementation());

  backend.registerLazySingleton<AuthenticationService>(

      /// By passing a userTestToken the server returns one of two test users
      /// when 'loginWithToken' is called so that we can test without the need for a real user token
      /// token: 'INF' and influencer
      /// token: 'BUSINESS' a business user
      () => AuthenticationServiceImplementation(
         //  userTestToken: 'INF',
          ));

  backend.registerLazySingleton<ImageService>(() => ImageServiceImplementation());
  backend.registerLazySingleton<SystemService>(() => SystemServiceImplementation());
  backend.registerLazySingleton<InfApiService>(() => InfApiServiceMock());

  // Managers
  backend.registerLazySingleton<AppManager>(() => AppManagerImplementation());
  backend.registerLazySingleton<UserManager>(() => UserManagerImplementation());
  backend.registerLazySingleton<OfferManager>(() => OfferManagerImplementation());

  // // Services
  // backend.registerLazySingleton<LocationService>(() => LocationServiceImplementation());
  // //backend.registerLazySingleton<AuthenticationService>(
  //     //() => AuthenticationServiceImplementation(_networkStreaming));
  // backend.registerLazySingleton<ConfigService>(() => ResourceServiceMock());
  // backend.registerLazySingleton<SystemService>(() => SystemServiceImplementation());
  // backend.registerLazySingleton<InfApiService>(() => InfApiServiceMock());
  // backend.registerLazySingleton<ImageService>(() => ImageServiceImplementation());

  // // Managers
  // backend.registerLazySingleton<AppManager>(() => AppManagerImplementation());
  // backend.registerLazySingleton<UserManager>(() => UserManagerImplementation());
  // backend.registerLazySingleton<OfferManager>(() => OfferManagerImplementation());
}

// void registerMocks() {
//   backend.registerSingleton<ErrorReporter>(ErrorReporter(ApiKeys.sentry));

//   // Services
//   backend.registerLazySingleton<LocationService>(() => LocationServiceMock());
//   backend.registerSingleton<InfApiClientsService>(InfApiClientsServiceImplementation());

//   backend.registerLazySingleton<AuthenticationService>(
//     /*
//     * currentUserIndex
//     *   0 = Business
//     *   1 = Influencer
//     */
//     () => AuthenticationServiceMock(
//           isLoggedIn: true,
//           currentUserIndex: 0,
//         ),
//   );
//   backend.registerLazySingleton<ConfigService>(() => ConfigServiceMock());
//   backend.registerLazySingleton<ImageService>(() => ImageServiceMock());
//   backend.registerLazySingleton<SystemService>(() => SystemServiceImplementation());
//   backend.registerLazySingleton<InfApiService>(() => InfApiServiceMock());

//   // Managers
//   backend.registerLazySingleton<AppManager>(() => AppManagerImplementation());
//   backend.registerLazySingleton<UserManager>(() => UserManagerImplementation());
//   backend.registerLazySingleton<OfferManager>(() => OfferManagerImplementation());
// }
