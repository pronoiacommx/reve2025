import 'package:flutter/material.dart';

enum AppFlavor { dev, qa, prd }

class Environment {
  static AppFlavor? _flavor;
  static String? _baseUrl;
  static String? _displayName;

  static bool get isInitialized => _flavor != null;

  static AppFlavor get flavor => _flavor ?? AppFlavor.dev;
  static String get apiBaseUrl => _baseUrl ?? 'https://api.dev.superapp.local';
  static String get name => _displayName ?? 'Reve (DEV)';

  static void init({
    required AppFlavor appFlavor,
    required String baseUrl,
    required String displayName,
  }) {
    _flavor = appFlavor;
    _baseUrl = baseUrl;
    _displayName = displayName;
  }

  static String get flavorName =>
      flavor.toString().split('.').last.toUpperCase();

  static Color get flavorColor {
    switch (flavor) {
      case AppFlavor.dev:
        return Colors.orange;
      case AppFlavor.qa:
        return Colors.purple;
      case AppFlavor.prd:
        return Colors.green;
    }
  }
}
