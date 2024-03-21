// Copyright (c) 2024 The Khalti Authors. All rights reserved.

import 'package:khalti_checkout_core/khalti_checkout_core.dart';
import 'package:khalti_checkout_core/src/util/utils.dart';

/// The configuration class for Khalti Payment Gateway.
class KhaltiConfig {
  /// Default constructor for the configuration.
  const KhaltiConfig({
    required this.platform,
    required this.osVersion,
    required this.deviceModel,
    required this.deviceManufacturer,
    required this.packageName,
    required this.packageVersion,
  });

  /// Default constructor for the configuration.
  factory KhaltiConfig.platformOnly() {
    return KhaltiConfig(
      platform: Platform.operatingSystem,
      osVersion: '',
      deviceModel: '',
      deviceManufacturer: '',
      packageName: '',
      packageVersion: '',
    );
  }

  /// The version of the Khalti Payment Gateway Library.
  final String version = '2.0.0';

  /// The device platform.
  final String platform;

  /// The OS version.
  final String osVersion;

  /// The device model.
  final String deviceModel;

  /// The device manufacturer.
  final String deviceManufacturer;

  /// The application package name.
  final String packageName;

  /// Tha application package version.
  final String packageVersion;

  /// Util to extract device specific information
  static final DeviceUtil _deviceUtil = DeviceUtil();

  /// Util to extract package specific information
  static final PackageUtil _packageUtil = PackageUtil();

  /// Initializes [KhaltiConfig]
  static Future<void> getConfig() async {
    await _deviceUtil.init();
    await _packageUtil.init();

    KhaltiService.config = KhaltiConfig(
      platform: Platform.operatingSystem,
      osVersion: _deviceUtil.osVersion,
      deviceModel: _deviceUtil.deviceModel,
      deviceManufacturer: _deviceUtil.deviceManufacturer,
      packageName: _packageUtil.applicationId,
      packageVersion: _packageUtil.versionName,
    );
  }

  /// The map representation of [KhaltiConfig].
  Map<String, String> get raw {
    return {
      'checkout-version': version,
      'checkout-platform': platform,
      'checkout-os-version': osVersion,
      'checkout-device-model': deviceModel,
      'checkout-device-manufacturer': deviceManufacturer,
      'merchant-package-name': packageName,
      'merchant-package-version': packageVersion,
    };
  }
}
