// Copyright (c) 2021 The Khalti Authors. All rights reserved.

import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

const String _khaltiPlayStore =
    'https://play.google.com/store/apps/details?id=com.khalti';
const String _khaltiAppStore =
    'https://apps.apple.com/us/app/khalti-digital-wallet-nepal/id1263400741';
const String _resetPinLink = 'https://khalti.com/#/account/transaction_pin';
const String _mPinDeeplink = 'khalti://go/?t=mpin';

UrlLauncherUtil _urlLauncher = UrlLauncherUtil();

/// The [UrlLauncherUtil] instance.
UrlLauncherUtil get urlLauncher => _urlLauncher;

@visibleForTesting
set debugUrlLauncherOverride(UrlLauncherUtil launcher) {
  _urlLauncher = launcher;
}

/// A utility class to launch URLs.
class UrlLauncherUtil {
  /// Parses the specified [url] string and delegates handling of it to the
  /// underlying platform.
  ///
  /// If [openInNewTab] is true, the [url] will be launched in new browser tab.
  /// The flag is ignored for platform other than web. Default is false.
  Future<bool> launch(String url, {bool openInNewTab = false}) async {
    try {
      await launcher.launchUrl(
        Uri.parse(url),
        webOnlyWindowName: openInNewTab ? null : '_self',
        mode: launcher.LaunchMode.externalApplication,
      );
      return true;
    } on PlatformException catch (e) {
      log(e.message ?? '', name: 'URL Launcher Failed');
      return false;
    }
  }

  /// Launches MPIN reset url or settings in Khalti App.
  Future<bool> launchMPINSetting() {
    if (kIsWeb) return openResetPinPageInBrowser();
    return launch(_mPinDeeplink);
  }

  /// Launches store depending upon the [platform] to install Khalti App.
  Future<bool> openStoreToInstallKhalti(TargetPlatform platform) {
    switch (platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        return launch(_khaltiPlayStore);
      case TargetPlatform.iOS:
        return launch(_khaltiAppStore);
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows: /* no-op */
    }
    return SynchronousFuture(false);
  }

  /// Launches MPIN reset url.
  Future<bool> openResetPinPageInBrowser() {
    return launch(_resetPinLink, openInNewTab: true);
  }
}
