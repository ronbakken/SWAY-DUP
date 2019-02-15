import 'dart:async';

import 'package:flutter/services.dart' show MethodChannel;

class BuildConfig {
  const BuildConfig();

  static final MethodChannel _channel = MethodChannel('build/config');

  static const instance = const BuildConfig();

  Future<String> operator [](String key) async => get(key);

  static Future<String> get(String name) async {
    try {
      return await _channel.invokeMethod('get', {'name': name});
    } catch (e) {
      return null;
    }
  }
}
