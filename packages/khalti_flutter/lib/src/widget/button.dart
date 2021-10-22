import 'package:flutter/material.dart';
import 'package:khalti/khalti.dart';
import 'package:khalti_flutter/khalti_flutter.dart';

class KhaltiButton extends StatelessWidget {
  const KhaltiButton({
    Key? key,
    required this.config,
    required this.onSuccess,
    required this.onFailure,
    this.onCancel,
    this.preferences = PaymentPreference.values,
    this.label,
  }) : super(key: key);

  final PaymentConfig config;
  final ValueChanged<PaymentSuccessModel> onSuccess;
  final ValueChanged<PaymentFailureModel> onFailure;
  final VoidCallback? onCancel;
  final List<PaymentPreference> preferences;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => pay(context),
      child: Text(label ?? 'PAY'),
    );
  }

  Future<void> pay(BuildContext context) {
    return KhaltiScope.of(context).pay(
      config: config,
      onSuccess: onSuccess,
      onFailure: onFailure,
      onCancel: onCancel,
      preferences: preferences,
    );
  }
}
