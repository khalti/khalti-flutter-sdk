extension ModelHelperExtension on Map<String, Object?> {
  String getString(String key, {String defaultValue = ''}) {
    return this[key] as String? ?? defaultValue;
  }

  int getInt(String key, {int defaultValue = 0}) {
    return int.tryParse(this[key].toString()) ?? defaultValue;
  }

  bool getBool(String key, {bool defaultValue = false}) {
    return this[key] as bool? ?? defaultValue;
  }

  List<T> getList<T>(String key) {
    final value = this[key];
    if (value is Iterable<T>) return List<T>.of(value);
    return [];
  }
}
