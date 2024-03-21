import 'package:khalti_checkout_core/khalti_checkout_core.dart';
import 'package:test/test.dart';

void main() {
  group('KhaltiConfig tests | ', () {
    test('default constructor', () {
      const config = KhaltiConfig(
        platform: 'Android',
        osVersion: '12',
        deviceModel: 'Pixel 6 Pro',
        deviceManufacturer: 'Google',
        packageName: 'com.khalti.test',
        packageVersion: '3.0.0',
      );

      expect(
        config.raw,
        {
          'checkout-version': config.version,
          'checkout-platform': 'Android',
          'checkout-os-version': '12',
          'checkout-device-model': 'Pixel 6 Pro',
          'checkout-device-manufacturer': 'Google',
          'merchant-package-name': 'com.khalti.test',
          'merchant-package-version': '3.0.0',
        },
      );
    });

    test('platform only factory constructor', () {
      final config = KhaltiConfig.platformOnly();

      expect(
        config.raw,
        {
          'checkout-version': config.version,
          'checkout-platform': Platform.operatingSystem,
          'checkout-os-version': '',
          'checkout-device-model': '',
          'checkout-device-manufacturer': '',
          'merchant-package-name': '',
          'merchant-package-version': '',
        },
      );
    });
  });
}
