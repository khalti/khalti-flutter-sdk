part of 'khalti_localizations.dart';

class _KhaltiLocalizationsEn extends KhaltiLocalizations {
  const _KhaltiLocalizationsEn();

  @override
  String get anErrorOccurred => 'An Error Occurred';

  @override
  String get noInternet => 'No Internet';

  @override
  String get noInternetMessage {
    return 'You are not connected to the internet. Please check your connection.';
  }

  @override
  String get networkUnreachable => 'Network Unreachable';

  @override
  String get networkUnreachableMessage {
    return 'Your connection could not be established.';
  }

  @override
  String get noConnection => 'No Connection';

  @override
  String get noConnectionMessage {
    return 'Slow or no internet connection. Please check your internet & try again.';
  }

  @override
  String get enterValidMobileNumber => 'Please enter a valid mobile number';

  @override
  String get mPinMustBeMin4Chars => 'Khalti MPIN must be at least 4 characters';

  @override
  String get payCodeMustBeMin6Chars {
    return 'Payment Code must be at least 6 characters';
  }

  @override
  String get fieldRequired => 'This field is required';

  @override
  String get pleaseSelectYourBank => 'Please select your Bank';

  @override
  String get noBanksFound => 'No banks found';

  @override
  String get searchForAnotherKeyword => 'Please search for another keyword';

  @override
  String get confirmPayment => 'Confirm Payment';

  @override
  String enterOtpSentTo(String mobileNo) {
    return 'Enter the OTP sent via SMS to mobile number $mobileNo';
  }

  @override
  String get confirmingPayment => 'Confirming Payment';

  @override
  String get verifyOTP => 'Verify OTP';

  @override
  String get initiatingPayment => 'Initiating Payment';

  @override
  String get success => 'Success';

  @override
  String get paymentInitiationSuccessMessage {
    return 'Khalti has sent a confirmation code in your Khalti registered number and email address.';
  }

  @override
  String get forgotPin => 'Forgot Khalti MPIN?';

  @override
  String get resetKhaltiMPIN => 'Reset Khalti MPIN';

  @override
  String get khaltiNotInstalledMessage {
    return 'Khalti is not installed in your device. Either install Khalti App or proceed using your browser.';
  }

  @override
  String get installKhalti => 'Install Khalti';

  @override
  String get proceedUsingBrowser => 'Proceed using browser';

  @override
  String get cancel => 'Cancel';

  @override
  String get pay => 'Pay';

  @override
  String get ok => 'Ok';

  @override
  String get khaltiMobileNumber => 'Khalti Mobile Number';

  @override
  String get khaltiMPIN => 'Khalti MPIN';

  @override
  String get paymentCode => 'Payment Code';

  @override
  String get searchBank => 'Search Bank';

  @override
  String get amount => 'Amount';

  @override
  String get test => 'Test';

  @override
  String get chooseYourPaymentMethod => 'Choose your payment method';

  @override
  String payWith(String method) => 'Pay with $method';

  @override
  String get khalti => 'Khalti';

  @override
  String get eBanking => 'E-Banking';

  @override
  String get mobileBanking => 'Mobile Banking';

  @override
  String get connectIps => 'Connect IPS';

  @override
  String get sct => 'SCT';

  @override
  String attemptsRemaining(int remainingAttempts) {
    return 'Attempts Remaining: $remainingAttempts';
  }
}
