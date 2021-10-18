import 'dart:convert';

abstract class KhaltiRequestModel {
  Map<String, Object?> toMap();

  String toJson({bool beautify = false}) {
    if (beautify) return JsonEncoder.withIndent('  ').convert(toMap());
    return jsonEncode(toMap());
  }
}
