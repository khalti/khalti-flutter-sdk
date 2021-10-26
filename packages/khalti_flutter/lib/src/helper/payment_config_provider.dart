import 'package:flutter/widgets.dart';
import 'package:khalti_flutter/src/helper/payment_config.dart';

class PaymentConfigScope extends InheritedWidget {
  PaymentConfigScope({
    Key? key,
    required this.config,
    required Widget child,
  }) : super(key: key, child: child);

  final PaymentConfig config;

  static PaymentConfig of(BuildContext context) {
    final PaymentConfigScope? configScope =
        context.dependOnInheritedWidgetOfExactType();

    assert(
      configScope != null,
      'No PaymentConfigScope found in the widget tree.',
    );
    return configScope!.config;
  }

  @override
  bool updateShouldNotify(PaymentConfigScope old) => old.config != config;
}
