import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/services.dart';

class PackageUtil {
  late PackageInfo _packageInfo;

  Future<void> init() async {
    try {
      _packageInfo = await PackageInfo.fromPlatform();
    } on PlatformException {/* no-op */}
  }

  /// Returns [versionName] i.e. `CFBundleShortVersionString` on iOS, `versionName` on Android.
  String get versionName => _packageInfo.version;

  /// Returns [applicationId] i.e. `bundleIdentifier` on iOS, `getPackageName` on Android.
  String get applicationId => _packageInfo.packageName;

  /// Returns [versionCode] i.e. `CFBundleVersion` on iOS, `versionCode` on Android.
  String get versionCode => _packageInfo.buildNumber;
}
