// Copyright (c) 2021 The Khalti Authors. All rights reserved.

/// Internal Extension for helping with type conversion.
extension ModelHelperExtension on Map<String, Object?> {
  /// Gets string value of the [key].
  String getString(String key, {String defaultValue = ''}) {
    return this[key] as String? ?? defaultValue;
  }

  /// Gets integer value of the [key].
  int getInt(String key, {int defaultValue = 0}) {
    return int.tryParse(this[key].toString()) ?? defaultValue;
  }

  /// Gets boolean value of the [key].
  bool getBool(String key, {bool defaultValue = false}) {
    return this[key] as bool? ?? defaultValue;
  }

  /// Gets list value of the [key].
  List<T> getList<T>(String key) {
    final value = this[key];
    if (value is Iterable<T>) return List<T>.of(value);
    return [];
  }
}
