abstract class Validators {
  static String? mobile(String? value) {
    if (_isValid(value, r'(^[9][678][0-9]{8}$)')) return null;

    return 'Please enter a valid mobile number';
  }

  static String? pin(String? value) {
    if (value == null || value.length < 4) {
      return 'Your pin must be at least 4 characters';
    }

    return null;
  }

  static bool _isValid(String? text, String? regex) {
    if (text == null || regex == null) return false;
    final regExp = RegExp(regex);
    return regExp.hasMatch(text);
  }
}
