import 'package:flutter/services.dart' show rootBundle;
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
import 'package:inf/backend/services/inf_api_service_impl.dart';
import 'package:inf/backend/services/inf_api_service_mock.dart';
import 'package:inf/backend/services/location_service_impl.dart';
import 'package:inf/backend/services/location_service_mock.dart';
import 'package:inf/backend/services/resource_service_.dart';
import 'package:inf/backend/services/resource_service_impl.dart';
import 'package:inf/backend/services/resource_service_mock.dart';
import 'package:inf/backend/services/system_service_.dart';
import 'package:inf/backend/services/system_service_impl.dart';
import 'package:inf/backend/services/system_service_mock.dart';
import 'package:inf/backend/services/inf_api_service_.dart';
import 'package:inf/backend/services/location_service_.dart';
import 'package:inf/backend/managers/offer_manager_.dart';
import 'package:inf/network_generic/multi_account_store.dart';
import 'package:inf/network_streaming/network_streaming.dart';

import 'package:inf/utils/error_capture.dart';
import 'package:inf_common/inf_common.dart';
import 'package:logging/logging.dart';

export 'package:inf/backend/managers/app_manager_.dart';
export 'package:inf/backend/services/auth_service_.dart';
export 'package:inf/backend/managers/user_manager_.dart';
export 'package:inf/backend/services/resource_service_.dart';
export 'package:inf/backend/services/system_service_.dart';
export 'package:inf/backend/services/inf_api_service_.dart';
export 'package:inf/backend/services/location_service_.dart';
export 'package:inf/backend/managers/offer_manager_.dart';

enum AppEnvironment { dev, prod, mock }

GetIt backend = GetIt();

Future<void> setupBackend(AppEnvironment env) async {
  switch (env) {
    case AppEnvironment.dev:
      configureDevLogger();
      await startApiClient('config_ulfberth.bin');
      registerImplementations();
      break;
    case AppEnvironment.prod:
      await startApiClient('config_prod.bin');
      registerImplementations();
      break;
    case AppEnvironment.mock:
      registerMocks();
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

Future<ConfigData> loadConfig(String configFile) async {
  var configData = await rootBundle.load('assets/$configFile');
  ConfigData config = new ConfigData();
  config.mergeFromBuffer(configData.buffer.asUint8List());
  return config;
}

Future<MultiAccountStore> loadMultiAccountStore(String startupDomain) async {
  MultiAccountStore store = new MultiAccountStore(startupDomain);
  await store.initialize();
  return store;
}

NetworkStreaming _networkStreaming;
Future<void> startApiClient(String configFile) async {
  // Load well-known config from APK
  ConfigData config = await loadConfig(configFile);
  // Load known local accounts from SharedPreferences
  MultiAccountStore multiAccountStore =
      await loadMultiAccountStore(config.services.environment);
  _networkStreaming = new NetworkStreaming(
    multiAccountStore: multiAccountStore,
    startupConfig: config
  );
  _networkStreaming.start();
  
  // FIXME: Call _networkStreaming.setApplicationForeground(foreground) from UI
  // FIXME: Call _networkStreaming.reload() from UI on reassemble()
  
  // TODO: Call _networkStreaming.listenNavigation(...) from UI
}

void registerImplementations() {
  backend.registerSingleton<ErrorReporter>(ErrorReporter(ApiKeys.sentry));

  // Services
  backend.registerLazySingleton<LocationService>(
      () => LocationServiceImplementation());
  backend.registerLazySingleton<AuthenticationService>(
      () => AuthenticationServiceImplementation(_networkStreaming));
  backend.registerLazySingleton<ResourceService>(
      () => ResourceServiceMock());
  backend.registerLazySingleton<SystemService>(
      () => SystemServiceImplementation());
  backend.registerLazySingleton<InfApiService>(
      () => InfApiServiceMock());

  // Managers
  backend.registerLazySingleton<AppManager>(() => AppManagerImplementation());
  backend.registerLazySingleton<UserManager>(() => UserManagerImplementation());
  backend
      .registerLazySingleton<OfferManager>(() => OfferManagerImplementation());
}

void registerMocks() {
  backend.registerSingleton<ErrorReporter>(ErrorReporter(ApiKeys.sentry));

  // Services
  backend.registerLazySingleton<LocationService>(() => LocationServiceMock());
  backend.registerLazySingleton<AuthenticationService>(
    () => AuthenticationServiceMock(
          isLoggedIn: true,
          currentUser: 0,
        ),
  );
  backend.registerLazySingleton<ResourceService>(() => ResourceServiceMock());
  backend.registerLazySingleton<SystemService>(
      () => SystemServiceMock(NetworkConnectionState.connected));
  backend.registerLazySingleton<InfApiService>(() => InfApiServiceMock());

  // Managers
  backend.registerLazySingleton<AppManager>(() => AppManagerImplementation());
  backend.registerLazySingleton<UserManager>(() => UserManagerImplementation());
  backend
      .registerLazySingleton<OfferManager>(() => OfferManagerImplementation());
}
