// Copyright (c) 2021 The Khalti Authors. All rights reserved.

import 'package:flutter/widgets.dart';

import 'payment_config.dart';

/// The inherited provider of the [PaymentConfig].
class PaymentConfigScope extends InheritedWidget {
  /// Creates [PaymentConfigScope] from the provided values.
  const PaymentConfigScope({
    Key? key,
    required this.config,
    required Widget child,
  }) : super(key: key, child: child);

  /// The [PaymentConfig] to be scoped in the widget tree.
  final PaymentConfig config;

  /// Returns the [PaymentConfig] instance scoped in the widget tree.
  static PaymentConfig of(BuildContext context) {
    final PaymentConfigScope? configScope =
        context.dependOnInheritedWidgetOfExactType();

    assert(
      configScope != null,
      'No PaymentConfigScope found in the widget tree.',
    );
    return configScope!.config;
  }

  /// Returns the [PaymentConfig] instance scoped in the widget tree &
  /// returns null if not found.
  static PaymentConfig? mayBeOf(BuildContext context) {
    final PaymentConfigScope? configScope =
        context.dependOnInheritedWidgetOfExactType();

    return configScope?.config;
  }

  @override
  bool updateShouldNotify(PaymentConfigScope oldWidget) {
    return oldWidget.config != config;
  }
}
