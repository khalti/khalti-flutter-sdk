import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

const String _khaltiPlayStore =
    'https://play.google.com/store/apps/details?id=com.khalti';
const String _khaltiAppStore =
    'https://apps.apple.com/us/app/khalti-digital-wallet-nepal/id1263400741';
const String _resetPinLink = 'https://khalti.com/#/account/transaction_pin';
const String _mPinDeeplink = 'khalti://go/?t=mpin';

UrlLauncherUtil _urlLauncher = UrlLauncherUtil();

UrlLauncherUtil get urlLauncher => _urlLauncher;

@visibleForTesting
set debugUrlLauncherOverride(UrlLauncherUtil launcher) {
  _urlLauncher = launcher;
}

class UrlLauncherUtil {
  Future<bool> launch(String url, {bool openInNewTab = false}) async {
    try {
      await launcher.launch(
        url,
        webOnlyWindowName: openInNewTab ? null : '_self',
      );
      return true;
    } on PlatformException catch (e) {
      log(e.message ?? '', name: 'URL Launcher Failed');
      return false;
    }
  }

  Future<bool> launchMPINSetting() {
    if (kIsWeb) {
      return launch(_resetPinLink, openInNewTab: true);
    }
    return launch(_mPinDeeplink);
  }

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

  Future<bool> openResetPinPageInBrowser() => launch(_resetPinLink);
}
