// Copyright (c) 2021 The Khalti Authors. All rights reserved.

import 'package:flutter/foundation.dart';
import 'package:khalti_core/khalti_core.dart';

import 'src/khalti_http_client.dart';
import 'src/util/device_util.dart';
import 'src/util/package_util.dart';

export 'package:khalti_core/khalti_core.dart';

export 'src/khalti_http_client.dart';

/// The entrypoint class for Khalti.
abstract class Khalti {
  /// Initializes Khalti Configuration.
  ///
  /// [publicKey] can be either test or live public key provided to Khalti merchant account.
  /// See the [Getting Started](https://docs.khalti.com/getting-started/),
  /// to find out about grabbing public key.
  ///
  /// [config] describes the plugin configuration. By default some device and
  /// package information are included alongside the platform type. Providing
  /// custom config is not recommended.
  ///
  /// [enabledDebugging] decides whether to show network logs or not.
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

  /// A http [service] to make requests to Khalti APIs.
  static KhaltiService get service => _service;

  /// Overrides [Khalti.service] with the provided [service].
  ///
  /// This can be used to provide mock implementation of [KhaltiService]
  /// for testing purposes.
  @visibleForTesting
  static set debugKhaltiServiceOverride(KhaltiService service) {
    _service = service;
  }
}

KhaltiService _service = KhaltiService(client: KhaltiHttpClient());
