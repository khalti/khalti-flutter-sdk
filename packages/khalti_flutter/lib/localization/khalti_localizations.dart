import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import 'messages_all.dart';

extension KhaltiLocalizationsExtension on BuildContext {
  KhaltiLocalizations get loc => KhaltiLocalizations.of(this);
}

class KhaltiLocalizations {
  const KhaltiLocalizations._();

  factory KhaltiLocalizations._for(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? true)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);

    unawaited(initializeMessages(localeName));
    Intl.defaultLocale = localeName;
    return KhaltiLocalizations._();
  }

  static KhaltiLocalizations of(BuildContext context) {
    final loc = Localizations.of<KhaltiLocalizations>(
      context,
      KhaltiLocalizations,
    );
    assert(
      loc != null,
      'Ensure to add KhaltiLocalizations.delegate in MaterialApp.localizationDelegates or CupertinoApp.localizationDelegates',
    );
    return loc!;
  }

  static const LocalizationsDelegate<KhaltiLocalizations> delegate =
      _KhaltiLocalizationsDelegate();

  /// An Error Occurred
  String get anErrorOccurred => Intl.message('An Error Occurred');

  /// No Internet
  String get noInternet => Intl.message('No Internet');

  /// You are not connected to the internet. Please check your connection.
  String get noInternetMessage => Intl.message(
        'You are not connected to the internet. Please check your connection.',
      );

  /// Network Unreachable
  String get networkUnreachable => Intl.message('Network Unreachable');

  /// Your connection could not be established.
  String get networkUnreachableMessage => Intl.message(
        'Your connection could not be established.',
      );

  /// No Connection
  String get noConnection => Intl.message('No Connection');

  /// Slow or no internet connection. Please check your internet & try again.
  String get noConnectionMessage => Intl.message(
        'Slow or no internet connection. Please check your internet & try again.',
      );

  /// Please enter a valid mobile number
  String get enterValidMobileNumber => Intl.message(
        'Please enter a valid mobile number',
      );

  /// Khalti MPIN must be at least 4 characters
  String get mPinMustBeMin4Chars => Intl.message(
        'Khalti MPIN must be at least 4 characters',
      );

  /// Payment Code must be at least 6 characters
  String get payCodeMustBeMin6Chars => Intl.message(
        'Payment Code must be at least 6 characters',
      );

  /// This field is required
  String get fieldRequired => Intl.message('This field is required');
}

class _KhaltiLocalizationsDelegate
    extends LocalizationsDelegate<KhaltiLocalizations> {
  const _KhaltiLocalizationsDelegate();

  @override
  Future<KhaltiLocalizations> load(Locale locale) {
    return SynchronousFuture(KhaltiLocalizations._for(locale));
  }

  @override
  bool isSupported(Locale locale) {
    return [
      'en',
      'ne',
    ].contains(locale.languageCode);
  }

  @override
  bool shouldReload(_KhaltiLocalizationsDelegate old) => false;
}
