import 'dart:async';
import 'dart:developer' show log;
import 'dart:typed_data';

import 'package:get_it/get_it.dart';
import 'package:inf/backend/api_keys.dart';
import 'package:inf/backend/managers/list_manager_.dart';
import 'package:inf/backend/managers/list_manager_impl.dart';
import 'package:inf/backend/managers/offer_manager_.dart';
import 'package:inf/backend/managers/offer_manager_impl.dart';
import 'package:inf/backend/managers/proposal_manager_.dart';
import 'package:inf/backend/managers/proposal_manager_impl.dart';
import 'package:inf/backend/managers/user_manager_.dart';
import 'package:inf/backend/managers/user_manager_impl.dart';
import 'package:inf/backend/services/auth_service_.dart';
import 'package:inf/backend/services/auth_service_impl.dart';
import 'package:inf/backend/services/config_service_.dart';
import 'package:inf/backend/services/config_service_impl.dart';
import 'package:inf/backend/services/image_service_.dart';
import 'package:inf/backend/services/image_service_impl.dart';
import 'package:inf/backend/services/inf_api_clients_service_.dart';
import 'package:inf/backend/services/inf_api_clients_service_impl.dart';
import 'package:inf/backend/services/inf_list_service_.dart';
import 'package:inf/backend/services/inf_list_service_impl.dart';
import 'package:inf/backend/services/inf_messaging_service_.dart';
import 'package:inf/backend/services/inf_messaging_service_impl.dart';
import 'package:inf/backend/services/inf_offer_service_.dart';
import 'package:inf/backend/services/inf_offer_service_impl.dart';
import 'package:inf/backend/services/location_service_.dart';
import 'package:inf/backend/services/location_service_mock.dart';
import 'package:inf/backend/services/system_service_.dart';
import 'package:inf/backend/services/system_service_impl.dart';
import 'package:inf/utils/build_config.dart';
import 'package:inf/utils/error_capture.dart';
import 'package:logging/logging.dart';

export 'package:grpc/grpc.dart' show GrpcError, CallOptions;
export 'package:inf/backend/managers/list_manager_.dart';
export 'package:inf/backend/managers/offer_manager_.dart';
export 'package:inf/backend/managers/proposal_manager_.dart';
export 'package:inf/backend/managers/user_manager_.dart';
export 'package:inf/backend/services/auth_service_.dart';
export 'package:inf/backend/services/config_service_.dart';
export 'package:inf/backend/services/image_service_.dart';
export 'package:inf/backend/services/inf_api_clients_service_.dart';
export 'package:inf/backend/services/inf_list_service_.dart';
export 'package:inf/backend/services/inf_messaging_service_.dart';
export 'package:inf/backend/services/inf_offer_service_.dart';
export 'package:inf/backend/services/location_service_.dart';
export 'package:inf/backend/services/system_service_.dart';
export 'package:inf/domain/domain.dart';
export 'package:inf/utils/error_capture.dart' show ErrorReporter;

typedef AssetLoader = Future<ByteData> Function(String key);

enum AppMode { dev, alpha, prod, mock }

class AppEnvironment {
  final AppMode mode;
  final String host;
  final int port;
  final String certificateAuthority;
  final bool sslRequired;

  AppEnvironment({
    this.mode,
    this.host,
    this.port,
    this.certificateAuthority,
    this.sslRequired = true,
  });
}

GetIt backend = GetIt();
AppEnvironment _appEnvironment;
AssetLoader _assetLoader;

Future<void> setupBackend({AppMode mode, String testRefreshToken, AssetLoader assetLoader}) async {
  _assetLoader = assetLoader;
  switch (mode) {
    case AppMode.alpha:
      _appEnvironment = AppEnvironment(
        mode: AppMode.alpha,
        host: 'api.alpha.swaymarketplace.com',
        port: 9026,
        sslRequired: false,
      );
      configureDevLogger();
      registerImplementations(testRefreshToken);
      break;
    case AppMode.dev:
      _appEnvironment = AppEnvironment(
        mode: AppMode.dev,
        host: 'api.dev.swaymarketplace.com',
        port: 9026,
      );
      configureDevLogger();
      registerImplementations(testRefreshToken);
      break;
    case AppMode.prod:
      _appEnvironment = AppEnvironment(
        mode: AppMode.prod,
        host: 'api.swaymarketplace.com', // FIXME: server not yet operational
        port: -1,
      );
      registerImplementations();
      break;
    case AppMode.mock:
      _appEnvironment = AppEnvironment(
        mode: AppMode.mock,
        host: await BuildConfig['API_HOST'],
        port: 8080,
        certificateAuthority: 'localhost',
      );
      configureDevLogger();
      registerImplementations(testRefreshToken);
      break;
    default:
      throw new Exception('Unknown backend selected.');
  }
}

void configureDevLogger() {
  hierarchicalLoggingEnabled = true;
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord record) {
    String message = record.message;
    message += record.object?.toString() ?? '';
    message += record.error?.toString() ?? '';
    message += record.stackTrace?.toString() ?? '';
    for (String line in message.trim().split('\n')) {
      log(
        line,
        time: record.time,
        sequenceNumber: record.sequenceNumber,
        level: record.level.value,
        name: record.loggerName,
        zone: record.zone,
        error: record.error,
        stackTrace: record.stackTrace,
      );
    }
  });
}

Future<void> initBackend() async {
  ByteData rootCertificateBundle;
  if (_appEnvironment.sslRequired) {
    rootCertificateBundle = await _assetLoader('assets/root.crt');
  }
  backend<InfApiClientsService>().init(
    _appEnvironment.host,
    _appEnvironment.port,
    rootCertificateBundle,
    _appEnvironment.certificateAuthority ?? _appEnvironment.host,
  );
  // TODO handle case that App must be updated
  await backend<ConfigService>().init();
}

void registerImplementations([String testRefreshToken]) {
  backend.registerSingleton<ErrorReporter>(ErrorReporter(ApiKeys.sentry));

  // Services
  backend.registerSingleton<InfApiClientsService>(InfApiClientsServiceImplementation());
  backend.registerLazySingleton<SystemService>(() => SystemServiceImplementation());
  backend.registerLazySingleton<ConfigService>(() => ConfigServiceImplementation());
  backend.registerLazySingleton<LocationService>(() => LocationServiceMock());
  backend.registerLazySingleton<InfListService>(() => InfListServiceImplementation());
  backend.registerLazySingleton<InfOfferService>(() => InfOfferServiceImplementation());
  backend.registerLazySingleton<ImageService>(() => ImageServiceImplementation());
  backend.registerLazySingleton<InfMessagingService>(() => InfMessagingServiceImplementation());
  backend.registerLazySingleton<AuthenticationService>(
      /// By passing a userTestToken the server returns one of two test users
      /// when 'loginWithToken' is called so that we can test without the need for a real user token
      /// token: 'INF' and influencer
      /// token: 'BUSINESS' a business user
      () => AuthenticationServiceImplementation(
            userTestToken: testRefreshToken,
          ));

  // Managers
  backend.registerLazySingleton<UserManager>(() => UserManagerImplementation());
  backend.registerLazySingleton<OfferManager>(() => OfferManagerImplementation());
  backend.registerLazySingleton<ProposalManager>(() => ProposalManagerImplementation());
  backend.registerLazySingleton<ListManager>(() => ListManagerImplementation());

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
