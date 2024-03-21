// Copyright (c) 2024 The Khalti Authors. All rights reserved.

import 'dart:convert';

/// The base request model for [KhaltiClient].
abstract class KhaltiRequestModel {
  /// The map representation of the [KhaltiRequestModel].
  Map<String, Object?> toMap();

  /// The JSON representation of the [KhaltiRequestModel].
  ///
  /// Enabling [beautify] will prettify the JSON.
  String toJson({bool beautify = false}) {
    if (beautify) return const JsonEncoder.withIndent('  ').convert(toMap());
    return jsonEncode(toMap());
  }
}
