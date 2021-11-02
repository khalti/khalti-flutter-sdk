part of 'khalti_localizations.dart';

class _KhaltiLocalizationsNe extends KhaltiLocalizations {
  const _KhaltiLocalizationsNe();

  @override
  String get anErrorOccurred => 'त्रुटि देखा पर्‍यो';

  @override
  String get noInternet => 'इन्टरनेट छैन';

  @override
  String get noInternetMessage {
    return 'तपाईँ इन्टरनेटमा जडान हुनुहुन्न। कृपया आफ्नो जडान जाँच्नुहोस्।';
  }

  @override
  String get networkUnreachable => 'नेटवर्क पहुँचयोग्य छैन';

  @override
  String get networkUnreachableMessage => 'तपाईंको जडान स्थापित गर्न सकिएन।';

  @override
  String get noConnection => 'कुनै जडान छैन';

  @override
  String get noConnectionMessage {
    return 'इन्टरनेट जडान ढिलो छ वा जडान छैन। कृपया आफ्नो इन्टरनेट जाँच्नुहोस् र फेरि प्रयास गर्नुहोस्।';
  }

  @override
  String get enterValidMobileNumber => 'कृपया मान्य मोबाइल नम्बर हाल्नुहोस्';

  @override
  String get mPinMustBeMin4Chars => 'खल्ती MPIN कम्तीमा ४ वर्णको हुनुपर्छ';

  @override
  String get payCodeMustBeMin6Chars => 'भुक्तानी कोड कम्तिमा 6 वर्णको हुनुपर्छ';

  @override
  String get fieldRequired => 'यो फाँट आवश्यक छ';

  @override
  String get pleaseSelectYourBank => 'कृपया आफ्नो बैंक चयन गर्नुहोस्';

  @override
  String get noBanksFound => 'कुनै बैंक फेला परेन';

  @override
  String get searchForAnotherKeyword => 'कृपया अर्को किवर्ड खोज्नुहोस्';

  @override
  String get confirmPayment => 'भुक्तानी पुष्टि गर्नुहोस्';

  @override
  String enterOtpSentTo(String mobileNo) {
    return '$mobileNo मोबाइल नम्बरमा SMS मार्फत पठाइएको OTP प्रविष्ट गर्नुहोस्';
  }

  @override
  String get confirmingPayment => 'भुक्तानी पुष्टि गर्दै';

  @override
  String get verifyOTP => 'OTP प्रमाणित गर्नुहोस्';

  @override
  String get initiatingPayment => 'भुक्तानी प्रारम्भ गर्दै';

  @override
  String get success => 'सफल भयो';

  @override
  String get paymentInitiationSuccessMessage {
    return 'खल्तीले तपाईंको दर्ता भएको मोबाइल नम्बर र इमेल ठेगानामा पुष्टिकरण कोड पठाएको छ।';
  }

  @override
  String get forgotPin => 'खल्ती MPIN बिर्सनुभयो?';

  @override
  String get resetKhaltiMPIN => 'खल्ती पिन रिसेट गर्नुहोस्';

  @override
  String get khaltiNotInstalledMessage {
    return 'तपाईंको यन्त्रमा खल्ती इन्स्टल गरिएको छैन। कि त खल्ती एप इन्स्टल गर्नुहोस् वा आफ्नो ब्राउजर प्रयोग गरेर अगाडि बढ्नुहोस्।';
  }

  @override
  String get installKhalti => 'खल्ती इन्स्टल गर्नुहोस्';

  @override
  String get proceedUsingBrowser => 'ब्राउजर प्रयोग गरेर अगाडि बढ्नुहोस्';

  @override
  String get cancel => 'रद्द गर्नुहोस्';

  @override
  String get pay => 'भुक्तानी गर्नुहोस्';

  @override
  String get ok => 'ठिक छ';

  @override
  String get khaltiMobileNumber => 'खल्ती मोबाइल नम्बर';

  @override
  String get khaltiMPIN => 'खल्ती MPIN';

  @override
  String get paymentCode => 'भुक्तानी कोड';

  @override
  String get searchBank => 'बैंक खोज्नुहोस्';

  @override
  String get amount => 'रकम';

  @override
  String get test => 'परीक्षण';

  @override
  String get chooseYourPaymentMethod => 'आफ्नो भुक्तानी विधि छान्नुहोस्';

  @override
  String payWith(String method) => '$method बाट भुक्तानी गर्नुहोस्';

  @override
  String get khalti => 'खल्ती';

  @override
  String get eBanking => 'इबैङ्किङ';

  @override
  String get mobileBanking => 'मोबाइल बैङ्किङ';

  @override
  String get connectIps => 'कनेक्ट आइपिएस';

  @override
  String get sct => 'एससिटी कार्ड';

  @override
  String attemptsRemaining(int remainingAttempts) {
    return 'बाँकी प्रयासहरू: ${NumberFormat('##', 'ne').format(remainingAttempts)}';
  }
}
