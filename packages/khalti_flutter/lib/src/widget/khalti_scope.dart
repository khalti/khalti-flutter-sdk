// Copyright (c) 2021 The Khalti Authors. All rights reserved.

import 'package:flutter/material.dart';
import 'package:khalti/khalti.dart';
import 'package:khalti_flutter/src/helper/payment_config.dart';
import 'package:khalti_flutter/src/helper/payment_preference.dart';
import 'package:khalti_flutter/src/payment_page.dart';

/// The [KhaltiScope] builder.
typedef KhaltiScopeBuilder = Widget Function(
  BuildContext,
  GlobalKey<NavigatorState>,
);

/// The widget that initializes Khalti Payment Gateway and handles received deeplink.
class KhaltiScope extends StatefulWidget {
  /// Creates [KhaltiScope] with the provided properties.
  KhaltiScope({
    Key? key,
    required this.publicKey,
    required KhaltiScopeBuilder builder,
    this.enabledDebugging = false,
    GlobalKey<NavigatorState>? navigatorKey,
  })  : _navKey = navigatorKey ?? GlobalObjectKey(publicKey),
        _builder = builder,
        super(key: key);

  /// The [publicKey] can be either test or live public key provided to Khalti merchant account.
  ///
  /// See the [Getting Started](https://docs.khalti.com/getting-started/),
  /// to find out about grabbing public key.
  final String publicKey;

  /// Whether to print network logs or not.
  final bool enabledDebugging;

  final KhaltiScopeBuilder _builder;
  final GlobalKey<NavigatorState> _navKey;

  /// Returns the [KhaltiScope] instance for the widget tree
  /// that corresponds to the given [context].
  static KhaltiScope of(BuildContext context) {
    final _InheritedKhaltiScope? scope =
        context.dependOnInheritedWidgetOfExactType();
    assert(scope != null, 'KhaltiScope could not be found in context');
    return scope!.scope;
  }

  /// Launches the Khalti Payment Gateway interface.
  Future<void> pay({
    required PaymentConfig config,
    required ValueChanged<PaymentSuccessModel> onSuccess,
    required ValueChanged<PaymentFailureModel> onFailure,
    VoidCallback? onCancel,
    List<PaymentPreference> preferences = PaymentPreference.values,
  }) async {
    final navigatorState = _navKey.currentState;
    assert(
      navigatorState != null,
      'Ensure that the navKey from KhaltiScope is provided to MaterialApp or CupertinoApp',
    );

    final result = await navigatorState!.push(
      MaterialPageRoute(
        builder: (_) => PaymentPage(config: config, preferences: preferences),
        settings: const RouteSettings(name: '/kpg'),
      ),
    );

    if (result is PaymentSuccessModel) {
      onSuccess(result);
    } else if (result is PaymentFailureModel) {
      onFailure(result);
    } else {
      onCancel?.call();
    }
  }

  @override
  State<KhaltiScope> createState() => _KhaltiScopeState();
}

class _KhaltiScopeState extends State<KhaltiScope> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    Khalti.init(
      publicKey: widget.publicKey,
      enabledDebugging: widget.enabledDebugging,
    );
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Future<bool> didPushRoute(String route) {
    final uri = Uri.parse('https://khalti.com$route');
    final kpgPath = Platform.isIOS ? '/kpg' : '/kpg/';
    if (uri.path == kpgPath) {
      final navigatorState = widget._navKey.currentState;
      navigatorState!.pop(
        PaymentSuccessModel.fromMap(uri.queryParameters),
      );
    }
    return super.didPushRoute(route);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedKhaltiScope(
      scope: widget,
      child: widget._builder(context, widget._navKey),
    );
  }
}

class _InheritedKhaltiScope extends InheritedWidget {
  const _InheritedKhaltiScope({
    Key? key,
    required this.scope,
    required Widget child,
  }) : super(key: key, child: child);

  final KhaltiScope scope;

  @override
  bool updateShouldNotify(_InheritedKhaltiScope old) {
    return old.scope.publicKey != scope.publicKey;
  }
}
