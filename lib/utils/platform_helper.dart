import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

String getBaseUrl() {
  if (kIsWeb) {
    return "https://your-api-hosted-url.com"; // Web version
  } else if (Platform.isAndroid) {
    return "http://10.0.2.2:5000"; // Android emulator
  } else {
    return "http://<your-local-ip>:5000"; // Physical device (Wi-Fi)
  }
}
