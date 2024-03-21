import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:khalti_checkout_flutter/khalti_checkout_flutter.dart';
import 'package:khalti_checkout_flutter/src/data/core/exception_handler.dart';
import 'package:khalti_checkout_flutter/src/strings.dart';
import 'package:khalti_checkout_flutter/src/util/utils.dart';
import 'package:khalti_checkout_flutter/src/widget/khalti_pop_scope.dart';

/// A WebView wrapper for displaying Khalti Payment Interface.
class KhaltiWebView extends StatefulWidget {
  /// Constructor for initializing [KhaltiWebView].
  const KhaltiWebView({
    super.key,
    required this.khalti,
  });

  /// The instance of [Khalti].
  final Khalti khalti;

  @override
  State<KhaltiWebView> createState() => _KhaltiWebViewState();
}

class _KhaltiWebViewState extends State<KhaltiWebView> {
  final webViewControllerCompleter = Completer<InAppWebViewController>();
  ValueNotifier<bool> showLinearProgressIndicator = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ValueListenableBuilder(
        valueListenable: showLinearProgressIndicator,
        builder: (_, value, __) {
          return Scaffold(
            appBar: kIsWeb
                ? null
                : AppBar(
                    title: const Text(s_payWithKhalti),
                    actions: [
                      IconButton(
                        onPressed: _reload,
                        icon: const Icon(Icons.refresh),
                      )
                    ],
                    bottom: value
                        ? const _LinearLoadingIndicator(
                            color: Colors.deepPurple,
                          )
                        : null,
                    elevation: 4,
                  ),
            body: StreamBuilder(
              stream: connectivityUtil.internetConnectionListenableStatus,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const SizedBox.shrink();

                final connectionStatus = snapshot.data!;

                switch (connectionStatus) {
                  case InternetStatus.connected:
                    return _KhaltiWebViewClient(
                      showLinearProgressIndicator: showLinearProgressIndicator,
                      webViewControllerCompleter: webViewControllerCompleter,
                    );
                  case InternetStatus.disconnected:
                    return const _NoInternetDisplay();
                }
              },
            ),
          );
        },
      ),
    );
  }

  Future<void> _reload() async {
    if (webViewControllerCompleter.isCompleted) {
      final webViewController = await webViewControllerCompleter.future;
      webViewController.loadUrl(
        urlRequest: URLRequest(
          url: WebUri('javascript:window.location.reload(true)'),
        ),
      );
    }
  }
}

class _KhaltiWebViewClient extends StatelessWidget {
  const _KhaltiWebViewClient({
    required this.showLinearProgressIndicator,
    required this.webViewControllerCompleter,
  });

  final ValueNotifier<bool> showLinearProgressIndicator;
  final Completer<InAppWebViewController?> webViewControllerCompleter;

  @override
  Widget build(BuildContext context) {
    final khalti =
        context.findAncestorWidgetOfExactType<KhaltiWebView>()!.khalti;
    final payConfig = khalti.payConfig;
    final isProd = payConfig.environment == Environment.prod;
    return KhaltiPopScope(
      onPopInvoked: (_) => khalti.onMessage(
        event: KhaltiEvent.kpgDisposed,
        description: s_kpgDisposed,
        needsPaymentConfirmation: true,
        khalti,
      ),
      child: InAppWebView(
        onLoadStop: (controller, webUri) async {
          showLinearProgressIndicator.value = false;
          if (webUri.isNotNull) {
            final currentStringUrl = webUri.toString();
            final returnStringUrl = payConfig.returnUrl.toString();
            if (currentStringUrl.contains(returnStringUrl)) {
              // Necessary if the user wants to perform an action when a payment is made.
              await khalti.onReturn?.call();

              final pidx = payConfig.pidx;

              return handleException(
                caller: () {
                  return Khalti.service.verify(pidx, isProd: isProd);
                },
                onPaymentResult: khalti.onPaymentResult,
                onMessage: khalti.onMessage,
                khalti: khalti,
              );
            }
          }
        },
        onReceivedError: (_, webResourceRequest, error) async {
          if (webResourceRequest.url
              .toString()
              .contains(payConfig.returnUrl.toString())) {
            showLinearProgressIndicator.value = false;
            return khalti.onMessage(
              description: error.description,
              event: KhaltiEvent.returnUrlLoadFailure,
              needsPaymentConfirmation: true,
              khalti,
            );
          }
        },
        onReceivedHttpError: (_, webResourceRequest, response) async {
          if (webResourceRequest.url
              .toString()
              .contains(payConfig.returnUrl.toString())) {
            showLinearProgressIndicator.value = false;
            return khalti.onMessage(
              statusCode: response.statusCode,
              event: KhaltiEvent.returnUrlLoadFailure,
              needsPaymentConfirmation: true,
              khalti,
            );
          }
        },
        onWebViewCreated: webViewControllerCompleter.complete,
        initialSettings: InAppWebViewSettings(
          useOnLoadResource: true,
          useHybridComposition: true,
          clearCache: true,
          cacheEnabled: false,
        ),
        initialUrlRequest: URLRequest(
          url: WebUri.uri(
            Uri.parse(isProd ? prodPaymentUrl : testPaymentUrl).replace(
              queryParameters: {'pidx': payConfig.pidx},
            ),
          ),
        ),
        onProgressChanged: (_, progress) {
          if (progress == 100) showLinearProgressIndicator.value = false;
        },
      ),
    );
  }
}

/// A widget that is displayed when there is no internet connection.
class _NoInternetDisplay extends StatelessWidget {
  /// Constructor for [_NoInternetDisplay].
  ///
  /// A widget that is displayed when there is no internet connection.
  const _NoInternetDisplay();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.signal_wifi_statusbar_connected_no_internet_4,
            ),
            SizedBox(height: 10),
            Text(
              s_noInternet,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 10),
            Text(s_noInternetDisplayMessage),
          ],
        ),
      ),
    );
  }
}

class _LinearLoadingIndicator extends LinearProgressIndicator
    implements PreferredSizeWidget {
  const _LinearLoadingIndicator({super.color});

  @override
  Size get preferredSize => const Size(double.maxFinite, 4);
}
