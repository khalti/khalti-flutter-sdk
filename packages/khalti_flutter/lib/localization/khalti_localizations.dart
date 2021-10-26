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
        desc: 'mobile number validation',
      );

  /// Khalti MPIN must be at least 4 characters
  String get mPinMustBeMin4Chars => Intl.message(
        'Khalti MPIN must be at least 4 characters',
        desc: 'pin validation',
      );

  /// Payment Code must be at least 6 characters
  String get payCodeMustBeMin6Chars => Intl.message(
        'Payment Code must be at least 6 characters',
        desc: 'otp validation',
      );

  /// This field is required
  String get fieldRequired => Intl.message(
        'This field is required',
        desc: 'empty field validation',
      );

  /// Please select your Bank
  String get pleaseSelectYourBank => Intl.message(
        'Please select your Bank',
        desc: 'bank payment',
      );

  /// No banks found
  String get noBanksFound => Intl.message(
        'No banks found',
        desc: 'title shown when bank search result is empty',
      );

  /// Please search for another keyword
  String get searchForAnotherKeyword => Intl.message(
        'Please search for another keyword',
        desc: 'message shown when bank search result is empty',
      );

  /// Confirm Payment
  String get confirmPayment => Intl.message(
        'Confirm Payment',
        desc: 'OTP confirmation title',
      );

  /// Enter the OTP sent via SMS to mobile number [mobileNo]
  String enterOtpSentTo(String mobileNo) => Intl.message(
        'Enter the OTP sent via SMS to mobile number $mobileNo',
        desc: 'otp sent hint',
        name: 'enterOtpSentTo',
        args: [mobileNo],
      );

  /// Confirming Payment
  String get confirmingPayment => Intl.message(
        'Confirming Payment',
        desc: 'OTP confirmation progress dialog message',
      );

  /// Verify OTP
  String get verifyOTP => Intl.message(
        'Verify OTP',
        desc: 'OTP verification button text',
      );
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
