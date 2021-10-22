import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:khalti/src/khalti_http_client.dart';
import 'package:khalti/src/util/device_util.dart';
import 'package:khalti/src/util/package_util.dart';
import 'package:khalti_core/khalti_core.dart';

export 'package:khalti/src/khalti_http_client.dart';
export 'package:khalti_core/khalti_core.dart';

class Khalti {
  static Future<void> init({
    required String publicKey,
    KhaltiConfig? config,
    bool enabledDebugging = false,
  }) async {
    KhaltiService.enableDebugging = enabledDebugging;
    KhaltiService.publicKey = publicKey;

    if (config == null) {
      final deviceUtil = DeviceUtil();
      final packageUtil = PackageUtil();
      await deviceUtil.init();
      await packageUtil.init();

      KhaltiService.config = KhaltiConfig(
        platform: kIsWeb ? 'web' : Platform.operatingSystem,
        osVersion: deviceUtil.osVersion,
        deviceModel: deviceUtil.deviceModel,
        deviceManufacturer: deviceUtil.deviceManufacturer,
        packageName: packageUtil.applicationId,
        packageVersion: packageUtil.versionName,
      );
    } else {
      KhaltiService.config = config;
    }
  }

  static KhaltiService get service => _service;
}

final KhaltiService _service = KhaltiService(client: KhaltiHttpClient());
