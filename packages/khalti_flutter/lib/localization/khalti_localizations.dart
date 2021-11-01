// Copyright (c) 2021 The Khalti Authors. All rights reserved.

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import 'messages_all.dart';

/// Internal helper extension for localizing strings.
extension KhaltiLocalizationsExtension on BuildContext {
  /// The localization instance.
  KhaltiLocalizations get loc => KhaltiLocalizations.of(this);
}

/// The class to provide localization support for the Khalti Payment Gateway library.
class KhaltiLocalizations {
  const KhaltiLocalizations._();

  static Future<KhaltiLocalizations> _load(Locale locale) async {
    final name = (locale.countryCode?.isEmpty ?? true)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);

    await initializeMessages(localeName);
    Intl.defaultLocale = localeName;
    return const KhaltiLocalizations._();
  }

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

  /// Initiating Payment
  String get initiatingPayment => Intl.message(
        'Initiating Payment',
        desc: 'payment initiation progress dialog message',
      );

  /// Success
  String get success => Intl.message(
        'Success',
        desc: 'success dialog title',
      );

  /// Khalti has sent a confirmation code in your Khalti registered number and email address.
  String get paymentInitiationSuccessMessage => Intl.message(
        'Khalti has sent a confirmation code in your Khalti registered number and email address.',
        desc: 'payment initiation success dialog message',
      );

  /// Forgot Khalti MPIN?
  String get forgotPin => Intl.message('Forgot Khalti MPIN?');

  /// Reset Khalti MPIN
  String get resetKhaltiMPIN => Intl.message('Reset Khalti MPIN');

  /// Khalti is not installed in your device. Either install Khalti App or proceed using your browser.
  String get khaltiNotInstalledMessage => Intl.message(
        'Khalti is not installed in your device. Either install Khalti App or proceed using your browser.',
        desc:
            'shows when Khalti app is not installed but user tries to reset MPIN',
      );

  /// Install Khalti
  String get installKhalti => Intl.message('Install Khalti');

  /// Proceed using browser
  String get proceedUsingBrowser => Intl.message('Proceed using browser');

  /// Cancel
  String get cancel => Intl.message('Cancel');

  /// Pay
  String get pay => Intl.message('Pay');

  /// Ok
  String get ok => Intl.message('Ok');

  /// Khalti Mobile Number
  String get khaltiMobileNumber => Intl.message('Khalti Mobile Number');

  /// Khalti MPIN
  String get khaltiMPIN => Intl.message('Khalti MPIN');

  /// Payment Code
  String get paymentCode => Intl.message('Payment Code');

  /// Search Bank
  String get searchBank => Intl.message('Search Bank');

  /// Amount
  String get amount => Intl.message('Amount');

  /// Test
  String get test => Intl.message('Test');

  /// Choose your payment method
  String get chooseYourPaymentMethod => Intl.message(
        'Choose your payment method',
      );

  /// Pay with [method]
  String payWith(String method) {
    return Intl.message('Pay with $method', name: 'payWith', args: [method]);
  }

  /// Khalti
  String get khalti => Intl.message('Khalti');

  /// E-Banking
  String get eBanking => Intl.message('E-Banking');

  /// Mobile Banking
  String get mobileBanking => Intl.message('Mobile Banking');

  /// Connect IPS
  String get connectIps => Intl.message('Connect IPS');

  /// SCT
  String get sct => Intl.message('SCT');

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
  String attemptsRemaining(int remainingAttempts) {
    return Intl.message(
      'Attempts Remaining: $remainingAttempts',
      name: 'attemptsRemaining',
      args: [remainingAttempts],
    );
  }
}

class _KhaltiLocalizationsDelegate
    extends LocalizationsDelegate<KhaltiLocalizations> {
  const _KhaltiLocalizationsDelegate();

  @override
  Future<KhaltiLocalizations> load(Locale locale) {
    return KhaltiLocalizations._load(locale);
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
