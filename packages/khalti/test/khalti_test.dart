import 'package:khalti/khalti.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockKhaltiService extends Mock implements KhaltiService {}

void main() {
  const _testPublicKey = '__test_public_key__';
  final _config = KhaltiConfig(
    platform: 'Android',
    osVersion: '12',
    deviceModel: 'Pixel 6 Pro',
    deviceManufacturer: 'Google',
    packageName: 'com.khalti.test',
    packageVersion: '3.0.0',
  );

  group(
    'KhaltiConfig |',
    () {
      test(
        'should return config when it is not null.',
        () async {
          await Khalti.init(publicKey: _testPublicKey, config: _config);
          expect(KhaltiService.config, _config);
        },
      );

      test(
        'should initialize config if it is null.',
        () async {
          await Khalti.init(
            publicKey: _testPublicKey,
          );
          expect(
            KhaltiService.config,
            isA<KhaltiConfig>()
                .having((e) => e.platform, 'platform', 'linux')
                .having((e) => e.osVersion, 'os version', '')
                .having((e) => e.deviceModel, 'device model', '')
                .having((e) => e.deviceManufacturer, 'manufacturer', '')
                .having((e) => e.packageName, 'package name', '')
                .having((e) => e.packageVersion, 'package version', ''),
          );
        },
      );

      test(
        'service getter should return KhaltiService.',
        () {
          expect(Khalti.service, isA<KhaltiService>());
        },
      );

      test(
        'debugKhaltiServiceOverride setter should set a mocked KhaltiService',
        () async {
          Khalti.debugKhaltiServiceOverride = _MockKhaltiService();
          expect(Khalti.service, isA<_MockKhaltiService>());
        },
      );
    },
  );
}
