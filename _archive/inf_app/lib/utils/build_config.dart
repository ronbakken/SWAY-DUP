import 'dart:async';

import 'package:flutter/services.dart' show MethodChannel;

const BuildConfig = _BuildConfig();

class _BuildConfig {
  const _BuildConfig();

  static final MethodChannel _channel = const MethodChannel('build/config');

  Future<String> operator [](String key) => get(key);

  static Future<String> get(String name) async {
    try {
      return await _channel.invokeMethod('get', {'name': name});
    } catch (e) {
      return null;
    }
  }
}
