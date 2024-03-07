import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:khalti_flutter/src/data/core/exception_handler.dart';
import 'package:khalti_flutter/src/strings.dart';
import 'package:khalti_flutter/src/util/utils.dart';

/// A WebView wrapper for displaying Khalti Payment Interface.
class KhaltiWebView extends StatefulWidget {
  /// Constructor for initializing [KhaltiWebView].
  const KhaltiWebView({
    super.key,
    required this.pidx,
    required this.returnUrl,
    required this.onPaymentResult,
    required this.onMessage,
    required this.environment,
    this.onReturn,
  });

  /// Unique idx associated with the product.
  final String pidx;

  /// Url to redirect to after the payment is successful.
  final Uri returnUrl;

  /// Callback that gets triggered when a payment is made.
  final OnPaymentResult onPaymentResult;

  /// Callback for when any exceptions occur.
  final OnMessage onMessage;

  /// Callback for when user is redirected to `return_url`.
  final OnReturn? onReturn;

  /// Environment to run the SDK against.
  ///
  /// Can be: `prod` or `test`.
  ///
  /// Defaults to `prod`.
  final Environment environment;

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
            appBar: AppBar(
              title: const Text(s_payWithKhalti),
              actions: [
                IconButton(
                  onPressed: _reload,
                  icon: const Icon(Icons.refresh),
                )
              ],
              bottom: value
                  ? const _LinearLoadingIndicator(color: Colors.deepPurple)
                  : null,
              elevation: 4,
            ),
            body: StreamBuilder(
              stream: connectivityUtil.internetConnectionListenableStatus,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const SizedBox.shrink();

                final connectionStatus = snapshot.data!;

                switch (connectionStatus) {
                  case InternetConnectionStatus.connected:
                    return _KhaltiWebViewClient(
                      showLinearProgressIndicator: showLinearProgressIndicator,
                      webViewControllerCompleter: webViewControllerCompleter,
                    );
                  case InternetConnectionStatus.disconnected:
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
      if (defaultTargetPlatform == TargetPlatform.android) {
        webViewController.reload();
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        webViewController.loadUrl(
          urlRequest: URLRequest(
            url: await webViewController.getUrl(),
          ),
        );
      }
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
    final widget = context.findAncestorWidgetOfExactType<KhaltiWebView>()!;
    final isProd = widget.environment == Environment.prod;
    return InAppWebView(
      onLoadStop: (controller, webUri) async {
        if (webUri.isNotNull) {
          final currentStringUrl = webUri.toString();
          final returnStringUrl = widget.returnUrl.toString();
          if (currentStringUrl.contains(returnStringUrl)) {
            // Necessary if the user wants to perform an action when a payment is made.
            await widget.onReturn?.call();

            final pidx = widget.pidx;

            return handleException(
              pidx: pidx,
              caller: (pidx) {
                return Khalti.service.verify(pidx, isProd: isProd);
              },
              onPaymentResult: widget.onPaymentResult,
              onMessage: widget.onMessage,
            );
          }
        }
      },
      onReceivedError: (_, __, error) async {
        showLinearProgressIndicator.value = false;
        return widget.onMessage(
          description: error.description,
        );
      },
      onReceivedHttpError: (_, __, response) async {
        showLinearProgressIndicator.value = false;
        return widget.onMessage(
          statusCode: response.statusCode,
        );
      },
      onWebViewCreated: webViewControllerCompleter.complete,
      initialSettings: InAppWebViewSettings(
        useOnLoadResource: true,
        useHybridComposition: true,
      ),
      initialUrlRequest: URLRequest(
        url: WebUri.uri(
          Uri.parse(isProd ? prodPaymentUrl : testPaymentUrl).replace(
            queryParameters: {'pidx': widget.pidx},
          ),
        ),
      ),
      onProgressChanged: (_, progress) {
        if (progress == 100) showLinearProgressIndicator.value = false;
      },
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
