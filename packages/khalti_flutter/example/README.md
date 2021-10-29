# Khalti Payment Gateway Example

```dart
const String testPublicKey = <test-public-key>;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KhaltiScope(
      publicKey: testPublicKey,
      enabledDebugging: true,
      builder: (context, navKey) {
        return ChangeNotifierProvider<AppPreferenceNotifier>(
          create: (_) => AppPreferenceNotifier(),
          builder: (context, _) {
            return Consumer<AppPreferenceNotifier>(
              builder: (context, appPreference, _) {
                return MaterialApp(
                  title: 'Khalti Payment Gateway',
                  supportedLocales: const [
                    Locale('en', 'US'),
                    Locale('ne', 'NP'),
                  ],
                  locale: appPreference.locale,
                  theme: ThemeData(
                    brightness: appPreference.brightness,
                    primarySwatch: Colors.deepPurple,
                    pageTransitionsTheme: const PageTransitionsTheme(
                      builders: {
                        TargetPlatform.android: ZoomPageTransitionsBuilder(),
                      },
                    ),
                  ),
                  debugShowCheckedModeBanner: false,
                  navigatorKey: navKey,
                  localizationsDelegates: const [
                    KhaltiLocalizations.delegate,
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                  ],
                  routes: {
                    '/': (_) => const HomePage(key: Key('home')),
                  },
                  onGenerateInitialRoutes: (route) {
                    // Only used for handling response from KPG in Flutter Web.
                    if (route.startsWith('/kpg/')) {
                      final uri = Uri.parse('https://khalti.com$route');
                      return [
                        MaterialPageRoute(
                          builder: (context) => HomePage(
                            key: const Key('kpg-home'),
                            params: uri.queryParameters,
                          ),
                        ),
                      ];
                    }
                    return Navigator.defaultGenerateInitialRoutes(
                      navKey.currentState!,
                      route,
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key, this.params}) : super(key: key);

  final Map<String, String>? params;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    if (widget.params != null) {
      SchedulerBinding.instance?.addPostFrameCallback((_) {
        onSuccess(PaymentSuccessModel.fromMap(widget.params!));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = PaymentConfig(
      amount: 1000,
      productIdentity: 'dell-g5-g5510-2021',
      productName:
      'Dell G5 G5510 2021 i7 10th Gen 8 Core / RTX 3060 / 16GB RAM / 512GB SSD / 15.6" 165Hz FHD Display',
      productUrl:
      'https://www.sastodeal.com/dell-g5-g5510-2021-i7-10th-gen-8-core-rtx-3060-16gb-ram-512gb-ssd-15-6-165h-itti-g5510.html',
      additionalData: {
        'vendor': 'Sastodeal',
        'image_url':
        'https://i.dell.com/is/image/DellContent/content/dam/global-site-design/product_images/dell_client_products/notebooks/g_series/g5_15_5590-non-touch/global_spi/ng/notebook-g5-15-5590-campaign-hero-504x350-ng.psd?hei=402&qlt=90,0&op_usm=1.75,0.3,2,0&resMode=sharp&pscan=auto&fmt=pjpg',
      },
    );
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localization.kpg),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Consumer<AppPreferenceNotifier>(
                builder: (context, appPreference, _) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 16, left: 16),
                        child: Text(
                          localization.appPreference.toUpperCase(),
                          style: Theme.of(context).textTheme.overline,
                        ),
                      ),
                      SwitchListTile(
                        value: appPreference.isDarkMode,
                        title: Text(localization.darkMode),
                        onChanged: (isDarkMode) {
                          context
                              .read<AppPreferenceNotifier>()
                              .updateBrightness(isDarkMode: isDarkMode);
                        },
                      ),
                      ListTile(
                        title: Text(localization.language),
                        trailing: DropdownButtonHideUnderline(
                          child: DropdownButton<Locale>(
                            items: {
                              'English': const Locale('en', 'US'),
                              'नेपाली': const Locale('ne', 'NP'),
                            }
                                .entries
                                .map(
                                  (e) => DropdownMenuItem(
                                child: Text(e.key),
                                value: e.value,
                              ),
                            )
                                .toList(growable: false),
                            value: appPreference.locale,
                            onChanged: (locale) {
                              if (locale != null) {
                                appPreference.updateLocale(locale);
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Flexible(
                  child: Column(
                    children: [
                      KhaltiButton(
                        config: config,
                        onSuccess: onSuccess,
                        onFailure: onFailure,
                        onCancel: onCancel,
                      ),
                      const SizedBox(height: 8),
                      KhaltiButton.eBanking(
                        config: config,
                        onSuccess: onSuccess,
                        onFailure: onFailure,
                        onCancel: onCancel,
                      ),
                      const SizedBox(height: 8),
                      KhaltiButton.mBanking(
                        config: config,
                        onSuccess: onSuccess,
                        onFailure: onFailure,
                        onCancel: onCancel,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Column(
                    children: [
                      KhaltiButton.wallet(
                        config: config,
                        onSuccess: onSuccess,
                        onFailure: onFailure,
                        onCancel: onCancel,
                      ),
                      const SizedBox(height: 8),
                      KhaltiButton.sct(
                        config: config,
                        onSuccess: onSuccess,
                        onFailure: onFailure,
                        onCancel: onCancel,
                      ),
                      const SizedBox(height: 8),
                      KhaltiButton.connectIPS(
                        config: config,
                        onSuccess: onSuccess,
                        onFailure: onFailure,
                        onCancel: onCancel,
                      ),
                    ],
                  ),
                ),
                if (MediaQuery.of(context).size.width > 500)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: _CustomButton(
                        config: config,
                        onSuccess: onSuccess,
                        onFailure: onFailure,
                        onCancel: onCancel,
                      ),
                    ),
                  ),
              ],
            ),
            if (MediaQuery.of(context).size.width < 500)
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: _CustomButton(
                  config: config,
                  onSuccess: onSuccess,
                  onFailure: onFailure,
                  onCancel: onCancel,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void onSuccess(PaymentSuccessModel success) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Payment Successful'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(
                success.additionalData?['image_url']?.toString() ?? '',
                height: 100,
              ),
              Text.rich(
                TextSpan(
                  text: 'Payment for ',
                  children: [
                    TextSpan(
                      text: success.productName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w300,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const TextSpan(text: ' of '),
                    TextSpan(
                      text: 'Rs. ${success.amount ~/ 100} ',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const TextSpan(text: ' was successfully made.'),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void onFailure(PaymentFailureModel failure) {
    log(failure.toString(), name: 'Failure');
  }

  void onCancel() {
    log('Cancelled');
  }
}

class _CustomButton extends StatelessWidget {
  const _CustomButton({
    Key? key,
    required this.config,
    required this.onSuccess,
    required this.onFailure,
    required this.onCancel,
  }) : super(key: key);

  final PaymentConfig config;
  final ValueChanged<PaymentSuccessModel> onSuccess;
  final ValueChanged<PaymentFailureModel> onFailure;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    final headline6 = Theme.of(context).textTheme.headline6?.copyWith(
      color: Colors.pink,
      fontWeight: FontWeight.bold,
    );

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      splashColor: Colors.orange.withOpacity(0.3),
      highlightColor: Colors.orange.withOpacity(0.2),
      hoverColor: Colors.orange.withOpacity(0.1),
      onTap: () {
        KhaltiScope.of(context).pay(
          config: config,
          preferences: [
            PaymentPreference.khalti,
            PaymentPreference.eBanking,
          ],
          onSuccess: onSuccess,
          onFailure: onFailure,
          onCancel: onCancel,
        );
      },
      child: Material(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.orange, width: 2.5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 16,
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  'assets/logo/khalti.svg',
                  package: 'khalti_flutter',
                  width: 200,
                ),
                const SizedBox(width: 8),
                Text('PAY', style: headline6),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```