abstract class Validators {
  static String? mobile(String? value) {
    return _required(
      value,
      (value) {
        if (!_isValid(value, r'(^[9][678][0-9]{8}$)')) {
          return 'Please enter a valid mobile number';
        }
      },
    );
  }

  static String? pin(String? value) {
    return _required(
      value,
      (value) {
        if (value.length < 4) {
          return 'Khalti MPIN must be at least 4 characters';
        }
      },
    );
  }

  static String? code(String? value) {
    return _required(
      value,
      (value) {
        if (value.length < 6) {
          return 'Payment Code must be at least 6 characters';
        }
      },
    );
  }

  static String? _required(
    String? value,
    String? Function(String value) onValue,
  ) {
    if (value == null || value.isEmpty) return 'This field is required';

    return onValue(value);
  }

  static bool _isValid(String? text, String? regex) {
    if (text == null || regex == null) return false;
    final regExp = RegExp(regex);
    return regExp.hasMatch(text);
  }
}
