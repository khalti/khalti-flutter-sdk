import 'package:flutter/material.dart';
import 'package:khalti/khalti.dart';
import 'package:khalti_flutter/src/helper/payment_config.dart';
import 'package:khalti_flutter/src/helper/payment_preference.dart';
import 'package:khalti_flutter/src/payment_page.dart';

typedef KhaltiScopeBuilder = Widget Function(
  BuildContext,
  GlobalKey<NavigatorState>,
);

class KhaltiScope extends StatefulWidget {
  KhaltiScope({
    Key? key,
    required this.publicKey,
    required KhaltiScopeBuilder builder,
    this.enabledDebugging = false,
  })  : _navKey = GlobalObjectKey(publicKey),
        _builder = builder,
        super(key: key);

  final String publicKey;
  final bool enabledDebugging;

  final KhaltiScopeBuilder _builder;
  final GlobalKey<NavigatorState> _navKey;

  static KhaltiScope of(BuildContext context) {
    final _InheritedKhaltiScope? _scope =
        context.dependOnInheritedWidgetOfExactType();
    assert(_scope != null, 'KhaltiScope could not be found in context');
    return _scope!.scope;
  }

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
        settings: const RouteSettings(name: 'kpg'),
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
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  Future<bool> didPushRoute(String route) {
    final uri = Uri.parse('https://khalti.com$route');
    if (uri.path == '/kpg/') {
      final navigatorState = widget._navKey.currentState;
      navigatorState!.pop(
        PaymentSuccessModel.fromMap(uri.queryParameters),
      );
    }
    return super.didPushRoute(route);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
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
