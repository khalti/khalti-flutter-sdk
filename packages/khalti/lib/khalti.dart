import 'package:flutter/foundation.dart';
import 'package:khalti_core/khalti_core.dart';

import 'src/khalti_http_client.dart';
import 'src/platform/platform.dart';
import 'src/util/device_util.dart';
import 'src/util/package_util.dart';

export 'package:khalti_core/khalti_core.dart';

export 'src/khalti_http_client.dart';
export 'src/platform/platform.dart';

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
        platform: Platform.operatingSystem,
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

  @visibleForTesting
  static set debugKhaltiServiceOverride(KhaltiService service) {
    _service = service;
  }
}

KhaltiService _service = KhaltiService(client: KhaltiHttpClient());
