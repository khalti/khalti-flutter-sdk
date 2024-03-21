// Copyright (c) 2024 The Khalti Authors. All rights reserved.

import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/services.dart';

/// A utility class to extract package related information.
class PackageUtil {
  late PackageInfo _packageInfo;

  /// Initializes the underlying [package_info](https://pub.dev/packages/package_info) plugin.
  ///
  /// This must be invoked before accessing any of the getters in the class.
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
