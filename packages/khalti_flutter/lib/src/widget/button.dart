// Copyright (c) 2021 The Khalti Authors. All rights reserved.

import 'package:flutter/material.dart';
import 'package:khalti/khalti.dart';
import 'package:khalti_flutter/localization/khalti_localizations.dart';
import 'package:khalti_flutter/src/helper/assets.dart';
import 'package:khalti_flutter/src/helper/payment_config.dart';
import 'package:khalti_flutter/src/helper/payment_preference.dart';
import 'package:khalti_flutter/src/widget/image.dart';
import 'package:khalti_flutter/src/widget/khalti_scope.dart';

/// The widget that provides set of button to launch Khalti Payment Gateway interface.
class KhaltiButton extends StatelessWidget {
  /// Creates [KhaltiButton] with the provided properties.
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

  /// The [PaymentConfig].
  final PaymentConfig config;

  /// Called when payment succeeds.
  final ValueChanged<PaymentSuccessModel> onSuccess;

  /// Called when payment fails.
  final ValueChanged<PaymentFailureModel> onFailure;

  /// Called when user manually cancels the payment without performing any action.
  final VoidCallback? onCancel;

  /// The [PaymentPreference]s.
  ///
  /// Set which payment option tabs are to be shown.
  final List<PaymentPreference> preferences;

  /// The button [label].
  ///
  /// Default is 'PAY'.
  final String? label;
  final ButtonStyle? _style;

  /// Creates [KhaltiButton] which launches KPG interface
  /// with only wallet payment option.
  factory KhaltiButton.wallet({
    Key? key,
    required PaymentConfig config,
    required ValueChanged<PaymentSuccessModel> onSuccess,
    required ValueChanged<PaymentFailureModel> onFailure,
    VoidCallback? onCancel,
  }) = _WalletButton;

  /// Creates [KhaltiButton] which launches KPG interface
  /// with only e-banking payment option.
  factory KhaltiButton.eBanking({
    Key? key,
    required PaymentConfig config,
    required ValueChanged<PaymentSuccessModel> onSuccess,
    required ValueChanged<PaymentFailureModel> onFailure,
    VoidCallback? onCancel,
  }) = _EBankingButton;

  /// Creates [KhaltiButton] which launches KPG interface
  /// with only mobile banking payment option.
  factory KhaltiButton.mBanking({
    Key? key,
    required PaymentConfig config,
    required ValueChanged<PaymentSuccessModel> onSuccess,
    required ValueChanged<PaymentFailureModel> onFailure,
    VoidCallback? onCancel,
  }) = _MobileBankingButton;

  /// Creates [KhaltiButton] which launches KPG interface
  /// with only SCT card payment option.
  factory KhaltiButton.sct({
    Key? key,
    required PaymentConfig config,
    required ValueChanged<PaymentSuccessModel> onSuccess,
    required ValueChanged<PaymentFailureModel> onFailure,
    VoidCallback? onCancel,
  }) = _SCTButton;

  /// Creates [KhaltiButton] which launches KPG interface
  /// with only Connect IPS payment option.
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
      onPressed: () => _pay(context),
      child: Text(label ?? context.loc.pay.toUpperCase()),
    );
  }

  /// The button [style], which can be overridden with [KhaltiButton.style].
  ButtonStyle get style {
    return _style ?? ElevatedButton.styleFrom(minimumSize: const Size(180, 40));
  }

  Future<void> _pay(BuildContext context) {
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
      onPressed: () => _pay(context),
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
      onPressed: () => _pay(context),
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
      onPressed: () => _pay(context),
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
      onPressed: () => _pay(context),
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
      onPressed: () => _pay(context),
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
