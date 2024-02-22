import 'dart:async';

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
  late final Future<bool> isConnectivityAvailable;
  InAppWebViewController? webViewController;
  bool hasNetworkError = false;

  @override
  void initState() {
    super.initState();
    isConnectivityAvailable = connectivityUtil.hasInternetConnection;
  }

  @override
  void dispose() {
    webViewController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KhaltiPopScope(
      canPop: () async {
        final canGoBack = await webViewController?.canGoBack() ?? true;
        return webViewController.isNull ||
            (webViewController.isNotNull && canGoBack);
      },
      child: FutureBuilder<bool>(
        future: isConnectivityAvailable,
        initialData: false,
        builder: (context, snapshot) {
          final hasInternetConnection = snapshot.data!;
          final isProd = widget.environment == Environment.prod;
          return InAppWebView(
            onLoadStop: (controller, webUri) async {
              if (webUri.isNotNull) {
                final currentStringUrl = webUri.toString();
                final returnStringUrl = widget.returnUrl.toString();
                if (currentStringUrl.contains(returnStringUrl) &&
                    webUri!.queryParameters['status']!.toLowerCase() ==
                        'completed' &&
                    hasNetworkError) {
                  final queryParams = webUri.queryParameters;
                  final paymentPayload = PaymentPayload(
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
              useHybridComposition: true,
            ),
            initialUrlRequest: URLRequest(
              url: WebUri.uri(
                Uri.parse(isProd ? prodPaymentUrl : testPaymentUrl).replace(
                  queryParameters: {'pidx': widget.pidx},
                ),
              ),
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
