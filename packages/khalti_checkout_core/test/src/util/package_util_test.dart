import 'package:flutter/services.dart';
import 'package:khalti_checkout_core/src/util/utils.dart' show PackageUtil;
import 'package:mocktail/mocktail.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:package_info_plus_platform_interface/method_channel_package_info.dart';
import 'package:package_info_plus_platform_interface/package_info_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:test/test.dart';

void main() {
  final packageUtil = PackageUtil();

  group(
    "package_util's init method",
    () {
      late _MethodChannelPackageInfoMock mockedMethodChannel;

      setUp(() {
        mockedMethodChannel = _MethodChannelPackageInfoMock();
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
            installerStore: '',
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

class _MethodChannelPackageInfoMock extends Mock
    with MockPlatformInterfaceMixin
    implements MethodChannelPackageInfo {}
