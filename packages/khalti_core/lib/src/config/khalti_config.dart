import 'dart:io';

const bool _kIsWeb = identical(0, 0.0);

class KhaltiConfig {
  final String version = '0.0.1';

  final String platform;
  final String osVersion;
  final String deviceModel;
  final String deviceManufacturer;
  final String packageName;
  final String packageVersion;

  KhaltiConfig({
    required this.platform,
    required this.osVersion,
    required this.deviceModel,
    required this.deviceManufacturer,
    required this.packageName,
    required this.packageVersion,
  });

  factory KhaltiConfig.sourceOnly() {
    return KhaltiConfig(
      platform: _kIsWeb ? 'web' : Platform.operatingSystem,
      osVersion: '',
      deviceModel: '',
      deviceManufacturer: '',
      packageName: '',
      packageVersion: '',
    );
  }

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
