// Copyright (c) 2021 The Khalti Authors. All rights reserved.

import 'package:khalti_core/src/platform/platform.dart';

/// The configuration class for Khalti Payment Gateway.
class KhaltiConfig {
  /// The version of the Khalti Payment Gateway Library.
  final String version = '1.0.1';

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

  /// Default constructor for the configuration.
  KhaltiConfig({
    required this.platform,
    required this.osVersion,
    required this.deviceModel,
    required this.deviceManufacturer,
    required this.packageName,
    required this.packageVersion,
  });

  /// A factory constructor that only configures the [platform]
  /// and ignores everything else.
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
