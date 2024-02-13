import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:khalti_flutter/src/util/connectivity_util.dart';
import 'package:khalti_flutter/src/util/empty_util.dart';
import 'package:khalti_flutter/src/widget/khalti_pop_scope.dart';

/// Enum to choose request type when loading webview.
enum WebViewRequestType {
  /// WebViewRequestType.get
  get,

  ///WebViewRequestType.post
  post
}

/// A WebView wrapper for displaying Khalti Payment Interface.
class KhaltiWebView extends StatefulWidget {
  /// Constructor for initializing [KhaltiWebView].
  const KhaltiWebView({
    Key? key,
    required this.paymentUrl,
    required this.returnUrl,
    this.loadCache = false,
    this.webViewRequestType = WebViewRequestType.get,
    this.header = const {},
  }) : super(key: key);

  /// Uri to load in webview to make payment.
  final Uri paymentUrl;

  /// Url to redirect to after the payment is successful.
  final Uri returnUrl;

  /// Whether webview should load from cache or not.
  final bool loadCache;

  /// Request type to send along when loading this webview.
  ///
  /// Can be `GET` or `POST`.
  final WebViewRequestType webViewRequestType;

  /// Headers to send along when loading the webview.
  final Map<String, String> header;

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
      onPopInvoked: (didPop) async {
        if (didPop) await webViewController!.goBack();
      },
      child: FutureBuilder<bool>(
        future: isConnectivityAvailable,
        initialData: false,
        builder: (context, snapshot) {
          final hasInternetConnection = snapshot.data!;
          return hasNetworkError
              ? const Scaffold(
                  body: Center(
                    child: Text('Error loading webview'),
                  ),
                )
              : InAppWebView(
                  shouldOverrideUrlLoading: (controller, action) async {
                    final currentStringUri = action.request.url.toString();
                    if (currentStringUri
                        .contains(widget.returnUrl.toString())) {
                      // final interceptingInformations =
                      //     widget.model.meta?.info?.urlInterceptors;

                      // if (interceptingInformations.isNullOrEmpty)
                      //   return NavigationActionPolicy.ALLOW;

                      // for (final info in interceptingInformations!) {
                      //   assert(
                      //     info.url.isNotNullAndNotEmpty &&
                      //         info.preActionUrl.isNotNullAndNotEmpty,
                      //     'url that is to be intercepted and pre_action_url cannot be null or empty',
                      //   );
                      //   final urlToIntercept = info.url!;
                      //   final preActionUrl = info.preActionUrl!;
                      //   if (currentUri.toString().contains(urlToIntercept)) {
                      //     widget.actionOnUriIntercept
                      //         ?.call(currentUri.toString(), preActionUrl);
                      //     break;
                      //   }
                      // }
                      return NavigationActionPolicy.ALLOW;
                    }
                    return NavigationActionPolicy.ALLOW;
                  },
                  onLoadStop: (_, __) {
                    pullToRefreshController?.endRefreshing();
                  },
                  onReceivedError: (_, __, ___) {
                    setState(() => hasNetworkError = true);
                  },
                  onReceivedHttpError: (_, __, ___) {
                    setState(() => hasNetworkError = true);
                  },
                  onWebViewCreated: (controller) {
                    webViewController = controller;
                  },
                  initialSettings: InAppWebViewSettings(
                    useOnLoadResource: true,
                    useShouldOverrideUrlLoading: true,
                    cacheMode: widget.loadCache
                        ? CacheMode.LOAD_CACHE_ONLY
                        : CacheMode.LOAD_NO_CACHE,
                    useHybridComposition: true,
                    clearSessionCache: !widget.loadCache,
                  ),
                  initialUrlRequest: URLRequest(
                    method: widget.webViewRequestType.name.toUpperCase(),
                    url: WebUri.uri(widget.paymentUrl),
                    headers: widget.header,
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
