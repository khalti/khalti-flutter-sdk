import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:khalti_flutter_example/app_preference.dart';
import 'package:provider/provider.dart';

const String testPublicKey = 'test_public_key_dc74e0fd57cb46cd93832aee0a507256';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
                  title: 'Flutter Demo',
                  supportedLocales: [
                    Locale('en', 'US'),
                    Locale('ne', 'NP'),
                  ],
                  locale: appPreference.locale,
                  theme: ThemeData(
                    brightness: appPreference.brightness,
                    primarySwatch: Colors.deepPurple,
                    pageTransitionsTheme: PageTransitionsTheme(
                      builders: {
                        TargetPlatform.android: ZoomPageTransitionsBuilder(),
                      },
                    ),
                  ),
                  debugShowCheckedModeBanner: false,
                  navigatorKey: navKey,
                  localizationsDelegates: [
                    KhaltiLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                  ],
                  home: HomePage(),
                );
              },
            );
          },
        );
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final config = PaymentConfig(
      amount: 1000,
      productIdentity: 'test-product',
      productName: 'Test Product',
      productUrl: 'https://khalti.com',
      additionalData: {
        'vendor': 'Khalti Bazaar',
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Khalti Payment Gateway'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
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
                        'App Preference'.toUpperCase(),
                        style: Theme.of(context).textTheme.overline,
                      ),
                    ),
                    SwitchListTile(
                      value: appPreference.isDarkMode,
                      title: Text('Dark Mode'),
                      onChanged: (isDarkMode) {
                        context
                            .read<AppPreferenceNotifier>()
                            .updateBrightness(isDarkMode: isDarkMode);
                      },
                    ),
                    ListTile(
                      title: Text('Language'),
                      trailing: DropdownButtonHideUnderline(
                        child: DropdownButton<Locale>(
                          items: {
                            'English': Locale('en', 'US'),
                            'Nepali': Locale('ne', 'NP'),
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
          KhaltiButton(
            config: config,
            onSuccess: onSuccess,
            onFailure: onFailure,
            onCancel: onCancel,
          ),
          const SizedBox(height: 16),
          GestureDetector(
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
              shape: StadiumBorder(),
              color: Colors.orange,
              child: SizedBox(
                height: 40,
                child: Center(
                  child: Text(
                    'CUSTOM PAY',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        ?.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onSuccess(PaymentSuccessModel success) {
    print('Success: $success');
  }

  void onFailure(PaymentFailureModel failure) {
    print('Failure; $failure');
  }

  void onCancel() {
    print('Cancelled');
  }
}
