/// Util containing various helper methods to deal with null checks.
extension EmptyUtil on Object? {
  /// Returns true is [Object] is null.
  bool get isNull => this == null;

  /// Returns true is [Object] is not null.
  bool get isNotNull => this != null;

  /// Returns true is [Object] is null or empty.
  bool get isNullOrEmpty {
    if (isNull) return true;
    final object = this;
    if (object is String && object.isEmpty) return true;
    if (object is Iterable && object.isEmpty) return true;
    if (object is Map && object.isEmpty) return true;
    return false;
  }

  /// Returns true is [Object] is not null and not empty.
  bool get isNotNullAndNotEmpty => !isNullOrEmpty;
}
