///
/// Flutter Captured Error Reporting
/// Created by Simon Lightfoot
///
/// Copyright (C) DevAngels Limited 2018
/// License: APACHE 2.0 - https://www.apache.org/licenses/LICENSE-2.0
///
import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui show window;

import 'package:connectivity/connectivity.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:package_info/package_info.dart';
import 'package:sentry/sentry.dart';
import 'package:system_info/system_info.dart';

/// Flutter Captured Error Reporting
/// Created by Simon Lightfoot & Thomas Burkhart
///
/// Copyright (C) DevAngels Limited 2018
/// License: APACHE 2.0 - https://www.apache.org/licenses/LICENSE-2.0
///

const int MEGABYTE = 1024 * 1024;

typedef Widget ErrorReportingWidget(ErrorReporter reporter);

bool get _isInDebugMode {
  bool inDebugMode = false;
  assert(inDebugMode = true);
  return inDebugMode;
}

///
/// Example:
///     void main() => runCapturedApp((reporter) => new AppComponent(reporter), dsn: '<YOUR-DSN>');
///
/// During your app lifecycle you can use the Reporter parameter to report a exception, like this:
///     try {
///         throw new AssertionError();
///     } catch (exception, stackTrace) {
///         errorReporter(exception, stackTrace);
///     }
///
PackageInfo info;

void runCapturedApp(Widget app, ErrorReporter reporter) async {
  info = await PackageInfo.fromPlatform();

  FlutterError.onError = (FlutterErrorDetails details) {
    if (_isInDebugMode) {
      // In development mode simply print to console.
      FlutterError.dumpErrorToConsole(details);
    } else {
      // In production mode report to the application zone to report to Sentry.
      Zone.current.handleUncaughtError(details.exception, details.stack);
    }
  };
  runZoned(() {
    runApp(app);
  }, onError: (Object error, StackTrace stackTrace) async {
    await reporter.logException(error, stackTrace: stackTrace);
  });
}

class ErrorReporter {
  SentryClient _sentry;

  String dsn;

  SentryClient get sentry => _sentry ?? SentryClient(dsn: dsn);

  ErrorReporter(this.dsn);

  Future<void> logEvent(
      String message, SeverityLevel severity, Map<String, dynamic> data) async {
    final Event event = Event(
      loggerName: '',
      message: message,
      release: '${info.version}_${info.buildNumber}',
      environment: 'qa',
      extra: data,
      level: severity,
    );

    try {
      final SentryResponse response = await sentry.capture(event: event);
      if (response.isSuccessful) {
        print('Success! Event ID: ${response.eventId}');
      } else {
        print('Failed to report to Sentry.io: ${response.error}');
      }
    } catch (e, stackTrace) {
      print(
          'Exception whilst reporting to Sentry.io\n' + stackTrace.toString());
    }
  }

  Future<void> logInfo(String message, [Map<String, dynamic> data]) =>
      logEvent(message, SeverityLevel.info, data);

  Future<void> logWarning(String message, [Map<String, dynamic> data]) =>
      logEvent(message, SeverityLevel.warning, data);

  Future<void> logException(Object error,
      {String message, StackTrace stackTrace}) async {
    print('Caught error: $error');

    if (_isInDebugMode) {
      print(stackTrace);
      print('In dev mode. Not sending report to Sentry.io.');
      return;
    }

    print('Reporting to Sentry.io...');

    final PackageInfo info = await PackageInfo.fromPlatform();

    Map<String, dynamic> extra = <String, dynamic>{};
    if (defaultTargetPlatform == TargetPlatform.android) {
      extra['device_info'] =
          await DeviceInfoPlugin.channel.invokeMethod('getAndroidDeviceInfo');
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      extra['device_info'] =
          await DeviceInfoPlugin.channel.invokeMethod('getIosDeviceInfo');
    }

    String mode = _isInDebugMode ? 'checked' : 'release';

    Map<String, String> tags = {};
    tags['message'] = message;
    tags['platform'] =
        defaultTargetPlatform.toString().substring('TargetPlatform.'.length);
    tags['package_name'] = info.packageName;
    tags['build_number'] = info.buildNumber;
    tags['version'] = info.version;
    tags['mode'] = mode;
    tags['locale'] = ui.window.locale.toString();

    ConnectivityResult connectivity =
        await (Connectivity().checkConnectivity());
    tags['connectivity'] =
        connectivity.toString().substring('ConnectivityResult.'.length);

    Map<String, dynamic> uiValues = <String, dynamic>{};
    uiValues['locale'] = ui.window.locale.toString();
    uiValues['pixel_ratio'] = ui.window.devicePixelRatio;
    uiValues['default_route'] = ui.window.defaultRouteName;
    uiValues['physical_size'] = [
      ui.window.physicalSize.width,
      ui.window.physicalSize.height
    ];
    uiValues['text_scale_factor'] = ui.window.textScaleFactor;
    uiValues['view_insets'] = [
      ui.window.viewInsets.left,
      ui.window.viewInsets.top,
      ui.window.viewInsets.right,
      ui.window.viewInsets.bottom
    ];
    uiValues['padding'] = [
      ui.window.padding.left,
      ui.window.padding.top,
      ui.window.padding.right,
      ui.window.padding.bottom
    ];
    if (WidgetsBinding.instance != null) {
      // Removed the widget tree as it posts too much information.
      /*
		if (WidgetsBinding.instance.renderViewElement != null) {
			uiValues['render_view'] = WidgetsBinding.instance.renderViewElement.toStringDeep();
		} else {
			uiValues['render_view'] = '<no tree currently mounted>';
		}
		*/
    }
    extra['ui'] = uiValues;

    Map<String, dynamic> memory = <String, dynamic>{};
    memory['phys_total'] = '${SysInfo.getTotalPhysicalMemory() ~/ MEGABYTE}MB';
    memory['phys_free'] = '${SysInfo.getFreePhysicalMemory() ~/ MEGABYTE}MB';
    memory['virt_total'] = '${SysInfo.getTotalVirtualMemory() ~/ MEGABYTE}MB';
    memory['virt_free'] = '${SysInfo.getFreeVirtualMemory() ~/ MEGABYTE}MB';
    extra['memory'] = memory;

    extra['dart_version'] = Platform.version;

    final Event event = Event(
        loggerName: '',
        exception: error,
        stackTrace: stackTrace,
        release: '${info.version}_${info.buildNumber}',
        environment: 'qa',
        tags: tags,
        extra: extra,
        level: SeverityLevel.fatal);

    try {
      final SentryResponse response = await sentry.capture(event: event);
      if (response.isSuccessful) {
        print('Success! Event ID: ${response.eventId}');
      } else {
        print('Failed to report to Sentry.io: ${response.error}');
      }
    } catch (e, stackTrace) {
      print(
          'Exception whilst reporting to Sentry.io\n' + stackTrace.toString());
    }
  }
}
