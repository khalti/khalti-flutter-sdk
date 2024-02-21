import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:khalti_flutter/src/util/connectivity_util.dart';
import 'package:khalti_flutter/src/util/empty_util.dart';
import 'package:khalti_flutter/src/widget/khalti_pop_scope.dart';

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

  final Environment environment;

  @override
  State<KhaltiWebView> createState() => _KhaltiWebViewState();
}

class _KhaltiWebViewState extends State<KhaltiWebView> {
  late final Future<bool> isConnectivityAvailable;
  PullToRefreshController? pullToRefreshController;
  InAppWebViewController? webViewController;
  bool hasNetworkError = false;

  @override
  void initState() {
    super.initState();
    isConnectivityAvailable = connectivityUtil.hasInternetConnection;
    pullToRefreshController = kIsWeb
        ? null
        : PullToRefreshController(
            settings: PullToRefreshSettings(
              color: const Color(0xFF5C2D91), // Khalti's primary color
            ),
            onRefresh: () async {
              if (defaultTargetPlatform == TargetPlatform.android) {
                webViewController?.reload();
              } else if (defaultTargetPlatform == TargetPlatform.iOS) {
                webViewController?.loadUrl(
                  urlRequest: URLRequest(
                    url: await webViewController?.getUrl(),
                  ),
                );
              }
            },
          );
  }

  @override
  void dispose() {
    pullToRefreshController?.dispose();
    webViewController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KhaltiPopScope(
      canPop: () async {
        final canGoBack = await webViewController!.canGoBack();
        return webViewController.isNull ||
            (webViewController.isNotNull && !canGoBack);
      },
      child: FutureBuilder<bool>(
        future: isConnectivityAvailable,
        initialData: false,
        builder: (context, snapshot) {
          final hasInternetConnection = snapshot.data!;
          final isProd = widget.environment == Environment.prod;
          return InAppWebView(
            onLoadStop: (controller, webUri) async {
              pullToRefreshController?.endRefreshing();
              final currentUrl = webUri!.uriValue;
              final currentStringUrl = currentUrl.toString();
              final returnStringUrl = widget.returnUrl.toString();
              if (currentStringUrl.contains(returnStringUrl) &&
                  currentUrl.queryParameters['status']!.toLowerCase() ==
                      'completed' &&
                  hasNetworkError) {
                final queryParams = currentUrl.queryParameters;
                final paymentPayload = PaymentPaylod(
                  pidx: queryParams['pidx'] ?? '',
                  amount: int.tryParse(queryParams['amount']!) ?? 0,
                  transactionId: queryParams['transaction_id'] ?? '',
                );

                // Necessary if the user wants to perform an action when a payment is made.
                await widget.onReturn?.call();

                final pidx = widget.pidx;

                PaymentVerificationResponseModel? lookupResult;

                try {
                  lookupResult = await Khalti.service.verify(
                    pidx,
                    isProd: isProd,
                  );
                } on ExceptionHttpResponse catch (e) {
                  return widget.onMessage(
                    statusCode: e.statusCode,
                    description: e.detail,
                  );
                } on FailureHttpResponse catch (e) {
                  return widget.onMessage(
                    statusCode: e.statusCode,
                    description: e.data,
                  );
                }

                if (lookupResult.isNotNull) {
                  return widget.onPaymentResult(
                    PaymentResult(
                      status: lookupResult.status,
                      payload: paymentPayload,
                    ),
                  );
                }
              }
            },
            onReceivedError: (_, __, e) async {
              setState(() => hasNetworkError = true);
              return widget.onMessage(description: e.description);
            },
            onReceivedHttpError: (_, __, response) async {
              setState(() => hasNetworkError = true);
              return widget.onMessage(statusCode: response.statusCode);
            },
            onWebViewCreated: (controller) {
              webViewController = controller;
            },
            initialSettings: InAppWebViewSettings(
              useOnLoadResource: true,
              useShouldOverrideUrlLoading: true,
              useHybridComposition: true,
            ),
            initialUrlRequest: URLRequest(
              url: WebUri(isProd ? prodBaseUrl : testBaseUrl),
              cachePolicy: hasInternetConnection
                  ? URLRequestCachePolicy.RELOAD_IGNORING_LOCAL_CACHE_DATA
                  : URLRequestCachePolicy.RETURN_CACHE_DATA_ELSE_LOAD,
            ),
          );
        },
      ),
    );
  }
}
