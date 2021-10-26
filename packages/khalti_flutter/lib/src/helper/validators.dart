import 'package:flutter/widgets.dart';
import 'package:khalti_flutter/localization/khalti_localizations.dart';

class Validators {
  const Validators(this.context);

  final BuildContext context;

  String? mobile(String? value) {
    return _required(
      value,
      (value) {
        if (!_isValid(value, r'(^[9][678][0-9]{8}$)')) {
          return context.loc.enterValidMobileNumber;
        }
      },
    );
  }

  String? pin(String? value) {
    return _required(
      value,
      (value) {
        if (value.length < 4) {
          return context.loc.mPinMustBeMin4Chars;
        }
      },
    );
  }

  String? code(String? value) {
    return _required(
      value,
      (value) {
        if (value.length < 6) {
          return context.loc.payCodeMustBeMin6Chars;
        }
      },
    );
  }

  String? _required(
    String? value,
    String? Function(String value) onValue,
  ) {
    if (value == null || value.isEmpty) return context.loc.fieldRequired;

    return onValue(value);
  }

  bool _isValid(String? text, String? regex) {
    if (text == null || regex == null) return false;
    final regExp = RegExp(regex);
    return regExp.hasMatch(text);
  }
}
