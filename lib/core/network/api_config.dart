import 'package:flutter/foundation.dart';

class ApiConfig {
  // Automatically switch between localhost (for Web) and 10.0.2.2 (for Android Emulator)
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:5093/api';
    }
    // Android Emulator special IP
    return 'http://10.0.2.2:5093/api';
  }
}
