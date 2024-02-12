// Copyright (c) 2021 The Khalti Authors. All rights reserved.

import 'package:flutter/foundation.dart';
import 'package:khalti_core/khalti_core.dart';

import 'src/khalti_http_client.dart';

export 'package:khalti_core/khalti_core.dart';

export 'src/khalti_http_client.dart';

/// The entrypoint class for Khalti.
class Khalti {
  const Khalti._internal({
    required this.publicKey,
    required this.paymentUrl,
    required this.returnUrl,
    this.openInKhalti = true,
    this.autoStatusLookup = true,
  });

  /// Factory constructor for [Khalti].
  factory Khalti({
    required String publicKey,
    required String paymentUrl,
    required String returnUrl,
    bool openInKhalti = true,
    bool autoStatusLookup = true,
  }) {
    _instance ??= Khalti._internal(
      publicKey: publicKey,
      paymentUrl: paymentUrl,
      returnUrl: returnUrl,
      openInKhalti: openInKhalti,
      autoStatusLookup: autoStatusLookup,
    );
    return _instance!;
  }

  static Khalti? _instance;

  /// Public Key
  final String publicKey;

  /// The Payment URL to redirect to be able to make payments.
  final String paymentUrl;

  /// The URL to redirect after payment is successful.
  final String returnUrl;

  /// A boolean to determine whether to launch WebView or open in khalti app.
  final bool openInKhalti;

  /// A boolean to verify if verification status lookup API should be hit after making the payment.
  final bool autoStatusLookup;

  /// Initializes Khalti Configuration.
  ///
  /// [publicKey] can be either test or live public key provided to Khalti merchant account.
  /// See the [Getting Started](https://docs.khalti.com/getting-started/),
  /// to find out about grabbing public key.
  ///
  /// [enabledDebugging] decides whether to show network logs or not.
  static Future<Khalti> init({
    required String publicKey,
    required String paymentUrl,
    required String returnUrl,
    bool openInKhalti = true,
    bool autoStatusLookup = true,
    bool enabledDebugging = false,
  }) async {
    KhaltiService.enableDebugging = enabledDebugging;
    KhaltiService.publicKey = publicKey;

    await KhaltiConfig.getConfig();

    return Khalti(
      publicKey: publicKey,
      paymentUrl: paymentUrl,
      returnUrl: returnUrl,
      autoStatusLookup: autoStatusLookup,
      openInKhalti: openInKhalti,
    );
  }

  /// A http [service] to make requests to Khalti APIs.
  static KhaltiService get service => _service;

  /// Overrides [Khalti.service] with the provided [service].
  ///
  /// This can be used to provide mock implementation of [KhaltiService]
  /// for testing purposes.
  @visibleForTesting
  static set debugKhaltiServiceOverride(KhaltiService service) {
    _service = service;
  }
}

KhaltiService _service = KhaltiService(client: KhaltiHttpClient());
