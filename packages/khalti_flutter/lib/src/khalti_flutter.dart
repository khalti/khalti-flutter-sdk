// Copyright (c) 2024 The Khalti Authors. All rights reserved.

import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:khalti_core/khalti_core.dart';
import 'package:khalti_flutter/src/data/core/exception_handler.dart';
import 'package:khalti_flutter/src/data/khalti_http_client.dart';
import 'package:khalti_flutter/src/widget/khalti_webview.dart';

export 'package:khalti_core/khalti_core.dart';

/// Environment to choose to different API endpoints based on the selected [Environment].
///
/// Can be: `prod` or `test`.
enum Environment {
  /// Production
  prod,

  /// Test / Staging
  test,
}

/// Various events associated with different actions.
enum KhaltiEvent {
  /// Event for when user presses back button.
  backpressed,

  /// Event for when return url fails to load.
  returnUrlLoadFailure,

  /// Event for when there's an exception when making a network call.
  networkFailure,

  /// Event for when there's a HTTP failure when making a network call.
  paymentLookupfailure,

  /// An unknown event.
  unknown
}

/// Callback for when a successful or failed payment result is obtained.
typedef OnPaymentResult = FutureOr<void> Function(
  PaymentResult paymentResult,
  Khalti khalti,
);

/// Callback for when any exceptions occur.
typedef OnMessage = FutureOr<void> Function(
  Khalti khalti, {
  int? statusCode,
  Object? description,
  KhaltiEvent? event,
  bool? needsPaymentConfirmation,
});

/// Callback for when user is redirected to `return_url`.
typedef OnReturn = FutureOr<void> Function();

/// Typedef for `Future<PaymentVerificationLookupResponseModel>`.
typedef VerificationLookup = Future<PaymentVerificationResponseModel>;

/// The entrypoint class for Khalti.
class Khalti extends Equatable {
  /// Constructor for [Khalti].
  const Khalti._({
    required this.payConfig,
    required this.onPaymentResult,
    required this.onMessage,
    this.onReturn,
  });

  /// Config class necessary to hold all the necessary informations needed to initialize the SDK.
  final KhaltiPayConfig payConfig;

  /// A callback which is to be triggered when any payment is made.
  final OnPaymentResult onPaymentResult;

  /// Callback for when any exceptions occur.
  final OnMessage onMessage;

  /// Callback for when user is redirected to `return_url`.
  final OnReturn? onReturn;

  /// Initializes Khalti Configuration.
  static Future<Khalti> init({
    required KhaltiPayConfig payConfig,
    required OnPaymentResult onPaymentResult,
    required OnMessage onMessage,
    OnReturn? onReturn,
    bool enableDebugging = false,
  }) async {
    KhaltiService.enableDebugging = enableDebugging;
    KhaltiService.publicKey = payConfig.publicKey;

    await KhaltiConfig.getConfig();

    return Khalti._(
      payConfig: payConfig,
      onPaymentResult: onPaymentResult,
      onMessage: onMessage,
      onReturn: onReturn,
    );
  }

  static bool _hasPopped = false;

  /// A http [service] to make requests to Khalti APIs.
  static KhaltiService get service => _service;

  /// Method to load webview to be able to make payment.
  void open(BuildContext context) {
    _hasPopped = false;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return KhaltiWebView(khalti: this);
        },
      ),
    );
  }

  /// Helper method to call payment verification api.
  Future<void> verify() async {
    return handleException(
      caller: () => service.verify(
        payConfig.pidx,
        isProd: payConfig.environment == Environment.prod,
      ),
      onMessage: onMessage,
      onPaymentResult: onPaymentResult,
      khalti: this,
    );
  }

  /// Helper method to close the webview.
  void close(BuildContext context) {
    if (!_hasPopped) Navigator.pop(context);
    _hasPopped = true;
  }

  /// Overrides [Khalti.service] with the provided [service].
  ///
  /// This can be used to provide mock implementation of [KhaltiService]
  /// for testing purposes.
  @visibleForTesting
  static set debugKhaltiServiceOverride(KhaltiService service) {
    _service = service;
  }

  @override
  List<Object?> get props => [payConfig, onPaymentResult, onMessage, onReturn];
}

KhaltiService _service = KhaltiService(client: KhaltiHttpClient());

/// A class to hold necessary informations for loading the flutter SDK.
class KhaltiPayConfig extends Equatable {
  /// A class to hold necessary informations for loading the flutter SDK.
  ///
  /// Constructor for [KhaltiPayConfig].
  const KhaltiPayConfig({
    required this.publicKey,
    required this.pidx,
    required this.returnUrl,
    this.openInKhalti = false,
    this.environment = Environment.prod,
  });

  /// Public Key
  final String publicKey;

  /// The Payment URL to redirect to be able to make payments.
  final String pidx;

  /// The URL to redirect after payment is successful.
  final Uri returnUrl;

  /// A boolean to determine whether to launch WebView or open in khalti app.
  final bool openInKhalti;

  /// Environment to run the SDK against.
  ///
  /// Can be: `prod` or `test`.
  ///
  /// Defaults to `prod`.
  final Environment environment;

  @override
  List<Object?> get props {
    return [
      publicKey,
      pidx,
      returnUrl,
      openInKhalti,
      environment,
    ];
  }
}
