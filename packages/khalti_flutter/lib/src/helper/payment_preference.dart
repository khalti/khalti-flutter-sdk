// Copyright (c) 2021 The Khalti Authors. All rights reserved.

/// The payment preference associating each payment methods.
enum PaymentPreference {
  /// Khalti Wallet
  khalti,

  /// E-Banking
  eBanking,

  /// Mobile Banking
  mobileBanking,

  /// Connect IPS
  connectIPS,

  /// SCT card
  sct,
}
