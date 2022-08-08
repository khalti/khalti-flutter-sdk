import 'package:flutter/services.dart';
import 'package:khalti/src/util/package_util.dart';
import 'package:mocktail/mocktail.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:package_info_plus_platform_interface/method_channel_package_info.dart';
import 'package:package_info_plus_platform_interface/package_info_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:test/test.dart';

class _MockMethodChannelPackageInfo extends Mock
    with MockPlatformInterfaceMixin
    implements MethodChannelPackageInfo {}

void main() {
  late PackageUtil _packageUtil;
  late _MockMethodChannelPackageInfo _mockedMethodChannel;

  setUp(
    () {
      _packageUtil = PackageUtil();
    },
  );

  group(
    "package_util's init method",
    () {
      setUp(() {
        _mockedMethodChannel = _MockMethodChannelPackageInfo();
        PackageInfoPlatform.instance = _mockedMethodChannel;
      });

      tearDown(
        () {
          PackageInfoPlatform.instance = MethodChannelPackageInfo();
        },
      );

      test(
        'should handle thrown PlatformException',
        () async {
          when(() => _mockedMethodChannel.getAll()).thenThrow(
            PlatformException(code: ''),
          );
          await _packageUtil.init();
          verify(() => _mockedMethodChannel.getAll()).called(1);
        },
      );
    },
  );

  group(
    'PackageUtil |',
    () {
      setUp(
        () async {
          PackageInfo.setMockInitialValues(
            appName: 'appName',
            packageName: 'packageName',
            version: 'version',
            buildNumber: 'buildNumber',
            buildSignature: 'buildSignature',
          );
          await _packageUtil.init();
        },
      );

      test(
        'versionName: should return the version name',
        () async {
          final versionName = _packageUtil.versionName;
          expect(versionName, 'version');
        },
      );

      test(
        'applicationId: should return the application id',
        () async {
          final appId = _packageUtil.applicationId;
          expect(appId, 'packageName');
        },
      );

      test(
        'versionCode: should return the version code',
        () async {
          final versionCode = _packageUtil.versionCode;
          expect(versionCode, 'buildNumber');
        },
      );
    },
  );
}
