// Copyright (c) 2021 The Khalti Authors. All rights reserved.

import 'package:flutter/widgets.dart';
import 'package:khalti_flutter/localization/khalti_localizations.dart';

/// The field validators.
class Validators {
  /// Creates [Validators] for the provided [context].
  const Validators(this.context);

  /// The context.
  final BuildContext context;

  /// Checks for valid mobile number, which is 10 digit number starting with '9'.
  String? mobile(String? value) {
    return _required(
      value,
      (value) {
        if (!_isValid(value, r'(^[9][678][0-9]{8}$)')) {
          return context.loc.enterValidMobileNumber;
        }

        return null;
      },
    );
  }

  /// Checks for valid Khalti MPIN, which is [value] at least of 4 characters.
  String? pin(String? value) {
    return _required(
      value,
      (value) {
        if (value.length < 4) {
          return context.loc.mPinMustBeMin4Chars;
        }

        return null;
      },
    );
  }

  /// Checks for valid payment code, which is [value] at least of 6 characters.
  String? code(String? value) {
    return _required(
      value,
      (value) {
        if (value.length < 6) {
          return context.loc.payCodeMustBeMin6Chars;
        }

        return null;
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
