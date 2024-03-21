// Copyright (c) 2024 The Khalti Authors. All rights reserved.

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:khalti_checkout_core/khalti_checkout_core.dart';

/// A utility class to extract device related information.
class DeviceUtil {
  late AndroidDeviceInfo _androidDeviceInfo;
  late IosDeviceInfo _iosDeviceInfo;
  late WebBrowserInfo _webBrowserInfo;

  /// Initializes the underlying [device_info](https://pub.dev/packages/device_info) plugin.
  ///
  /// This must be invoked before accessing any of the getters in the class.
  Future<void> init() async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      if (kIsWeb) {
        _webBrowserInfo = await deviceInfo.webBrowserInfo;
      } else {
        if (Platform.isIOS) {
          _iosDeviceInfo = await deviceInfo.iosInfo;
        } else if (Platform.isAndroid) {
          _androidDeviceInfo = await deviceInfo.androidInfo;
        }
      }
    } on PlatformException {/*no-op*/}
  }

  /// The device manufacturer name.
  String get deviceManufacturer {
    String? manufacturer;
    if (kIsWeb) {
      manufacturer = _webBrowserInfo.vendor;
    } else {
      if (Platform.isIOS) {
        manufacturer = 'Apple';
      } else if (Platform.isAndroid) {
        manufacturer = _androidDeviceInfo.manufacturer;
      }
    }
    return manufacturer?.toUpperCase().onlyASCII ?? '';
  }

  /// The device's operating system version.
  String get osVersion {
    String? version;
    if (kIsWeb) {
      version = _webBrowserInfo.productSub;
    } else {
      if (Platform.isIOS) {
        version = _iosDeviceInfo.systemVersion;
      } else if (Platform.isAndroid) {
        version = _androidDeviceInfo.version.release;
      }
    }
    return version ?? '';
  }

  /// The device's model.
  String get deviceModel {
    String? model;
    if (kIsWeb) {
      model = _webBrowserInfo.userAgent;
    } else {
      if (Platform.isIOS) {
        model = _iosDeviceInfo.model;
      } else if (Platform.isAndroid) {
        model = _androidDeviceInfo.model;
      }
    }
    return model?.onlyASCII ?? '';
  }
}

extension on String {
  // Includes only the ASCII characters, and strips out the others.
  String get onlyASCII => replaceAll(RegExp(r'[^\x00-\x7F]'), '');
}
