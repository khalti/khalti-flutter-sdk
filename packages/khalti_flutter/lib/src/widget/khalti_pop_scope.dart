import 'dart:async';

import 'package:flutter/widgets.dart';

/// `FutureOr<void> Function(bool didPop)`
typedef PopInvokedCallback = FutureOr<void> Function(bool didPop);

/// `FutureOr<bool> Function()`
typedef CanPopCallback = FutureOr<bool> Function();

/// A wrapper around [PopScope] widget.
class KhaltiPopScope extends StatelessWidget {
  /// Constructor for [KhaltiPopScope].
  const KhaltiPopScope({
    super.key,
    required this.child,
    this.onPopInvoked,
    this.canPop,
  });

  /// The child widget which is to be wrapped with [KhaltiPopScope].
  final Widget child;

  /// Callback that gets executed when the page is popped.
  final PopInvokedCallback? onPopInvoked;

  /// Callback that determines whether or not a page can be popped.
  final CanPopCallback? canPop;

  @override
  Widget build(BuildContext context) {
    final isPoppable = canPop == null ? true : canPop!();

    if (isPoppable is Future<bool>) {
      return FutureBuilder<bool>(
        future: isPoppable,
        builder: (_, canPop) {
          return PopScope(
            canPop: canPop.data ?? true,
            onPopInvoked: onPopInvoked,
            child: child,
          );
        },
      );
    }
    return PopScope(
      canPop: isPoppable,
      onPopInvoked: onPopInvoked,
      child: child,
    );
  }
}
