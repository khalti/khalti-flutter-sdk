import 'package:flutter_test/flutter_test.dart';
import 'package:khalti/khalti.dart';
import 'package:mocktail/mocktail.dart';
import 'package:package_info_plus/package_info_plus.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const testPublicKey = '__test_public_key__';

  PackageInfo.setMockInitialValues(
    appName: 'Khalti',
    packageName: 'com.khalti.kpg',
    version: '1.0.0',
    buildNumber: '100',
    buildSignature: '',
    installerStore: 'Play Store',
  );

  final config = KhaltiConfig(
    platform: 'Android',
    osVersion: '12',
    deviceModel: 'Pixel 6 Pro',
    deviceManufacturer: 'Google',
    packageName: 'com.khalti.test',
    packageVersion: '3.0.0',
  );

  final expectedResult = <String, String>{
    'checkout-version': '1.0.1',
    'checkout-platform': Platform.operatingSystem,
    'checkout-os-version': '',
    'checkout-device-model': '',
    'checkout-device-manufacturer': '',
    'merchant-package-name': 'com.khalti.kpg',
    'merchant-package-version': '1.0.0',
  };

  group(
    'Khalti: init() |',
    () {
      test(
        'should return KhaltiConfig when parameter config is not null inside init method',
        () async {
          await Khalti.init(publicKey: testPublicKey, config: config);

          expect(KhaltiService.config, config);
        },
      );

      test(
        'should initialize with default config if config is not provided during initialization',
        () async {
          await Khalti.init(
            publicKey: testPublicKey,
          );

          expect(KhaltiService.config.raw, expectedResult);
        },
      );

      test(
        'service getter should return KhaltiService',
        () {
          expect(Khalti.service, isA<KhaltiService>());
        },
      );

      test(
        'debugKhaltiServiceOverride setter should set a mocked KhaltiService',
        () async {
          Khalti.debugKhaltiServiceOverride = _KhaltiServiceMock();
          expect(Khalti.service, isA<_KhaltiServiceMock>());
        },
      );
    },
  );
}

class _KhaltiServiceMock extends Mock implements KhaltiService {}
