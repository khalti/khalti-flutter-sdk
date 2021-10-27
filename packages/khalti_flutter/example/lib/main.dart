import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:khalti_flutter_example/app_preference.dart';
import 'package:khalti_flutter_example/home_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
                  title: 'Khalti Payment Gateway',
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
                    AppLocalizations.delegate,
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
