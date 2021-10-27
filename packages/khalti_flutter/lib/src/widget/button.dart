import 'package:flutter/material.dart';
import 'package:khalti/khalti.dart';
import 'package:khalti_flutter/localization/khalti_localizations.dart';
import 'package:khalti_flutter/src/helper/assets.dart';
import 'package:khalti_flutter/src/helper/payment_config.dart';
import 'package:khalti_flutter/src/helper/payment_preference.dart';
import 'package:khalti_flutter/src/widget/image.dart';
import 'package:khalti_flutter/src/widget/khalti_scope.dart';

class KhaltiButton extends StatelessWidget {
  const KhaltiButton({
    Key? key,
    required this.config,
    required this.onSuccess,
    required this.onFailure,
    this.onCancel,
    this.preferences = PaymentPreference.values,
    this.label,
    ButtonStyle? style,
  })  : _style = style,
        super(key: key);

  final PaymentConfig config;
  final ValueChanged<PaymentSuccessModel> onSuccess;
  final ValueChanged<PaymentFailureModel> onFailure;
  final VoidCallback? onCancel;
  final List<PaymentPreference> preferences;
  final String? label;
  final ButtonStyle? _style;

  factory KhaltiButton.wallet({
    Key? key,
    required PaymentConfig config,
    required ValueChanged<PaymentSuccessModel> onSuccess,
    required ValueChanged<PaymentFailureModel> onFailure,
    VoidCallback? onCancel,
  }) = _WalletButton;

  factory KhaltiButton.eBanking({
    Key? key,
    required PaymentConfig config,
    required ValueChanged<PaymentSuccessModel> onSuccess,
    required ValueChanged<PaymentFailureModel> onFailure,
    VoidCallback? onCancel,
  }) = _EBankingButton;

  factory KhaltiButton.mBanking({
    Key? key,
    required PaymentConfig config,
    required ValueChanged<PaymentSuccessModel> onSuccess,
    required ValueChanged<PaymentFailureModel> onFailure,
    VoidCallback? onCancel,
  }) = _MobileBankingButton;

  factory KhaltiButton.sct({
    Key? key,
    required PaymentConfig config,
    required ValueChanged<PaymentSuccessModel> onSuccess,
    required ValueChanged<PaymentFailureModel> onFailure,
    VoidCallback? onCancel,
  }) = _SCTButton;

  factory KhaltiButton.connectIPS({
    Key? key,
    required PaymentConfig config,
    required ValueChanged<PaymentSuccessModel> onSuccess,
    required ValueChanged<PaymentFailureModel> onFailure,
    VoidCallback? onCancel,
  }) = _ConnectIPSButton;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: style,
      onPressed: () => pay(context),
      child: Text(label ?? context.loc.pay.toUpperCase()),
    );
  }

  ButtonStyle get style {
    return _style ?? ElevatedButton.styleFrom(minimumSize: const Size(180, 40));
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

class _WalletButton extends KhaltiButton {
  _WalletButton({
    Key? key,
    required PaymentConfig config,
    required ValueChanged<PaymentSuccessModel> onSuccess,
    required ValueChanged<PaymentFailureModel> onFailure,
    VoidCallback? onCancel,
  }) : super(
          key: key,
          config: config,
          onSuccess: onSuccess,
          onFailure: onFailure,
          onCancel: onCancel,
          preferences: [PaymentPreference.khalti],
        );

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: style,
      onPressed: () => pay(context),
      icon: const _ButtonIcon(assetName: a_walletIcon),
      label: Text(context.loc.khalti.toUpperCase()),
    );
  }
}

class _EBankingButton extends KhaltiButton {
  _EBankingButton({
    Key? key,
    required PaymentConfig config,
    required ValueChanged<PaymentSuccessModel> onSuccess,
    required ValueChanged<PaymentFailureModel> onFailure,
    VoidCallback? onCancel,
  }) : super(
          key: key,
          config: config,
          onSuccess: onSuccess,
          onFailure: onFailure,
          onCancel: onCancel,
          preferences: [PaymentPreference.eBanking],
        );

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: style,
      onPressed: () => pay(context),
      icon: const _ButtonIcon(assetName: a_eBankingIcon),
      label: Text(context.loc.eBanking.toUpperCase()),
    );
  }
}

class _MobileBankingButton extends KhaltiButton {
  _MobileBankingButton({
    Key? key,
    required PaymentConfig config,
    required ValueChanged<PaymentSuccessModel> onSuccess,
    required ValueChanged<PaymentFailureModel> onFailure,
    VoidCallback? onCancel,
  }) : super(
          key: key,
          config: config,
          onSuccess: onSuccess,
          onFailure: onFailure,
          onCancel: onCancel,
          preferences: [PaymentPreference.mobileBanking],
        );

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: style,
      onPressed: () => pay(context),
      icon: const _ButtonIcon(assetName: a_mobileBankingIcon),
      label: Text(context.loc.mobileBanking.toUpperCase()),
    );
  }
}

class _SCTButton extends KhaltiButton {
  _SCTButton({
    Key? key,
    required PaymentConfig config,
    required ValueChanged<PaymentSuccessModel> onSuccess,
    required ValueChanged<PaymentFailureModel> onFailure,
    VoidCallback? onCancel,
  }) : super(
          key: key,
          config: config,
          onSuccess: onSuccess,
          onFailure: onFailure,
          onCancel: onCancel,
          preferences: [PaymentPreference.sct],
        );

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: style,
      onPressed: () => pay(context),
      icon: const _ButtonIcon(assetName: a_sctIcon),
      label: Text(context.loc.sct.toUpperCase()),
    );
  }
}

class _ConnectIPSButton extends KhaltiButton {
  _ConnectIPSButton({
    Key? key,
    required PaymentConfig config,
    required ValueChanged<PaymentSuccessModel> onSuccess,
    required ValueChanged<PaymentFailureModel> onFailure,
    VoidCallback? onCancel,
  }) : super(
          key: key,
          config: config,
          onSuccess: onSuccess,
          onFailure: onFailure,
          onCancel: onCancel,
          preferences: [PaymentPreference.connectIPS],
        );

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: style,
      onPressed: () => pay(context),
      icon: const _ButtonIcon(assetName: a_connectIpsIcon),
      label: Text(context.loc.connectIps.toUpperCase()),
    );
  }
}

class _ButtonIcon extends StatelessWidget {
  const _ButtonIcon({Key? key, required this.assetName}) : super(key: key);

  final String assetName;

  @override
  Widget build(BuildContext context) {
    return KhaltiImage.asset(
      asset: assetName,
      inheritIconTheme: true,
      height: 24,
    );
  }
}
