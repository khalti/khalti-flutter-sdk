import 'package:flutter/services.dart';
import 'package:khalti/src/util/package_util.dart';
import 'package:mocktail/mocktail.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:package_info_plus_platform_interface/method_channel_package_info.dart';
import 'package:package_info_plus_platform_interface/package_info_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:test/test.dart';

class MockMethodChannelPackageInfo extends Mock
    with MockPlatformInterfaceMixin
    implements MethodChannelPackageInfo {}

void main() {
  late PackageUtil packageUtil;
  late MockMethodChannelPackageInfo mockedMethodChannel;

  setUp(
    () {
      packageUtil = PackageUtil();
    },
  );

  group(
    "package_util's init method",
    () {
      setUp(() {
        mockedMethodChannel = MockMethodChannelPackageInfo();
        PackageInfoPlatform.instance = mockedMethodChannel;
      });

      tearDown(
        () {
          PackageInfoPlatform.instance = MethodChannelPackageInfo();
        },
      );

      test(
        'should handle thrown PlatformException',
        () async {
          when(() => mockedMethodChannel.getAll()).thenThrow(
            PlatformException(code: ''),
          );
          await packageUtil.init();
          verify(() => mockedMethodChannel.getAll()).called(1);
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
          await packageUtil.init();
        },
      );

      test(
        'versionName: should return the version name',
        () async {
          final versionName = packageUtil.versionName;
          expect(versionName, 'version');
        },
      );

      test(
        'applicationId: should return the application id',
        () async {
          final appId = packageUtil.applicationId;
          expect(appId, 'packageName');
        },
      );

      test(
        'versionCode: should return the version code',
        () async {
          final versionCode = packageUtil.versionCode;
          expect(versionCode, 'buildNumber');
        },
      );
    },
  );
}
