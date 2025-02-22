import 'dart:convert';

import 'package:flutter/services.dart';

abstract class ConfigReader {
  static bool isDebugMode = false;
  static Map<String, dynamic>? _config;

  /// Initializes the configuration reader with the specified environment.
  ///
  /// This method attempts to load the configuration file for the specified environment.
  /// If the environment-specific configuration file fails to load, it falls back to the default configuration.
  static Future<void> initialize(String env) async {
    var configString = '{}';
    try {
      configString = await rootBundle.loadString('config/$env.json');
      isDebugMode = env == "dev";
    } catch (_) {
      configString = await rootBundle.loadString('config/default.json');
    }
    _config = json.decode(configString) as Map<String, dynamic>;
  }

  /// Get Unsplash API URL from the configuration.
  /// Returns the Unsplash API URL as a string.
  static String getApiUrl() {
    return _config!['api_url'] as String;
  }

  /// Get Unsplash API Key from the configuration.
  /// Returns the Unsplash API Key as a string.
  static String getApiKey() {
    return _config!['api_key'] as String;
  }
}
