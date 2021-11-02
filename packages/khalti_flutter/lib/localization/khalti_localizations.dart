// Copyright (c) 2021 The Khalti Authors. All rights reserved.

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

part 'khalti_localizations_en.dart';
part 'khalti_localizations_ne.dart';

const Map<String, KhaltiLocalizations> _localizations = {
  'en': _KhaltiLocalizationsEn(),
  'ne': _KhaltiLocalizationsNe(),
};

/// Internal helper extension for localizing strings.
extension KhaltiLocalizationsExtension on BuildContext {
  /// The localization instance.
  KhaltiLocalizations get loc => KhaltiLocalizations.of(this);
}

/// The class to provide localization support for the Khalti Payment Gateway library.
abstract class KhaltiLocalizations {
  /// Default constructor for [KhaltiLocalizations].
  const KhaltiLocalizations();

  /// Returns the localized resources object of [KhaltiLocalizations] for the widget
  /// tree that corresponds to the given [context].
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

  /// The delegate to provide [KhaltiLocalizations].
  ///
  /// This should be added to [MaterialApp.localizationsDelegates].
  ///
  /// ```dart
  /// MaterialApp(
  ///   localizationsDelegates: const [
  ///     KhaltiLocalizations.delegate,
  ///     // other delegates
  ///   ],
  /// );
  /// ```
  static const LocalizationsDelegate<KhaltiLocalizations> delegate =
      _KhaltiLocalizationsDelegate();

  /// An Error Occurred
  String get anErrorOccurred;

  /// No Internet
  String get noInternet;

  /// You are not connected to the internet. Please check your connection.
  String get noInternetMessage;

  /// Network Unreachable
  String get networkUnreachable;

  /// Your connection could not be established.
  String get networkUnreachableMessage;

  /// No Connection
  String get noConnection;

  /// Slow or no internet connection. Please check your internet & try again.
  String get noConnectionMessage;

  /// Please enter a valid mobile number
  String get enterValidMobileNumber;

  /// Khalti MPIN must be at least 4 characters
  String get mPinMustBeMin4Chars;

  /// Payment Code must be at least 6 characters
  String get payCodeMustBeMin6Chars;

  /// This field is required
  String get fieldRequired;

  /// Please select your Bank
  String get pleaseSelectYourBank;

  /// No banks found
  String get noBanksFound;

  /// Please search for another keyword
  String get searchForAnotherKeyword;

  /// Confirm Payment
  String get confirmPayment;

  /// Enter the OTP sent via SMS to mobile number [mobileNo]
  String enterOtpSentTo(String mobileNo);

  /// Confirming Payment
  String get confirmingPayment;

  /// Verify OTP
  String get verifyOTP;

  /// Initiating Payment
  String get initiatingPayment;

  /// Success
  String get success;

  /// Khalti has sent a confirmation code in your Khalti registered number and email address.
  String get paymentInitiationSuccessMessage;

  /// Forgot Khalti MPIN?
  String get forgotPin;

  /// Reset Khalti MPIN
  String get resetKhaltiMPIN;

  /// Khalti is not installed in your device. Either install Khalti App or proceed using your browser.
  String get khaltiNotInstalledMessage;

  /// Install Khalti
  String get installKhalti;

  /// Proceed using browser
  String get proceedUsingBrowser;

  /// Cancel
  String get cancel;

  /// Pay
  String get pay;

  /// Ok
  String get ok;

  /// Khalti Mobile Number
  String get khaltiMobileNumber;

  /// Khalti MPIN
  String get khaltiMPIN;

  /// Payment Code
  String get paymentCode;

  /// Search Bank
  String get searchBank;

  /// Amount
  String get amount;

  /// Test
  String get test;

  /// Choose your payment method
  String get chooseYourPaymentMethod;

  /// Pay with [method]
  String payWith(String method);

  /// Khalti
  String get khalti;

  /// E-Banking
  String get eBanking;

  /// Mobile Banking
  String get mobileBanking;

  /// Connect IPS
  String get connectIps;

  /// SCT
  String get sct;

  /// Rs. [amount]
  String rupee(double amount) {
    final formattedAmount = NumberFormat.currency(
      symbol: (Intl.defaultLocale ?? 'en').startsWith('ne') ? 'रू.' : 'Rs.',
      customPattern: '\u00A4\u00A0##,##,##0.00',
    ).format(amount);

    if (formattedAmount.endsWith('.00')) {
      return formattedAmount.substring(0, formattedAmount.length - 3);
    }
    return formattedAmount;
  }

  /// Attempts Remaining: [remainingAttempts]
  String attemptsRemaining(int remainingAttempts);
}

class _KhaltiLocalizationsDelegate
    extends LocalizationsDelegate<KhaltiLocalizations> {
  const _KhaltiLocalizationsDelegate();

  @override
  Future<KhaltiLocalizations> load(Locale locale) {
    return SynchronousFuture(
      _localizations[locale.languageCode] ?? const _KhaltiLocalizationsEn(),
    );
  }

  @override
  bool isSupported(Locale locale) {
    return _localizations.containsKey(locale.languageCode);
  }

  @override
  bool shouldReload(_KhaltiLocalizationsDelegate old) => false;
}
