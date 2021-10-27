import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:khalti/khalti.dart';
import 'package:khalti_flutter/localization/khalti_localizations.dart';
import 'package:khalti_flutter/src/helper/payment_config.dart';
import 'package:khalti_flutter/src/helper/payment_config_provider.dart';
import 'package:khalti_flutter/src/helper/payment_preference.dart';
import 'package:khalti_flutter/src/widget/color.dart';

import 'page/bank_payment_page.dart';
import 'page/card_payment_page.dart';
import 'page/wallet_payment_page.dart';
import 'widget/tab.dart';

class PaymentPage extends StatelessWidget {
  PaymentPage({
    Key? key,
    required this.config,
    this.preferences = PaymentPreference.values,
  })  : assert(
          preferences.isNotEmpty,
          '\n\nProvide at least one payment preference.\n',
        ),
        assert(
          preferences.toSet().length == preferences.length,
          '\n\nDuplicate payment preferences detected!\n',
        ),
        super(key: key);

  final PaymentConfig config;
  final List<PaymentPreference> preferences;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final colorScheme = isDark
        ? ColorScheme.dark(
            primary: Colors.deepPurple,
            onPrimary: Colors.white,
            secondary: Color(0xFF12091D),
          )
        : ColorScheme.light(
            primary: Colors.deepPurple,
            onPrimary: Colors.deepPurple,
            secondary: Color(0xFFDED5E9),
          );

    return KhaltiColor(
      isDark: isDark,
      child: Theme(
        data: ThemeData.from(
          colorScheme: colorScheme,
          textTheme: TextTheme(
            button: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            caption: TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
            subtitle1: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
        ),
        child: PaymentConfigScope(
          config: config,
          child: KhaltiService.publicKey.startsWith('test_')
              ? Banner(
                  location: BannerLocation.bottomEnd,
                  message: context.loc.test.toUpperCase(),
                  child: _HomePage(preferences: preferences),
                )
              : _HomePage(preferences: preferences),
        ),
      ),
    );
  }
}

class _HomePage extends StatelessWidget {
  _HomePage({Key? key, required this.preferences}) : super(key: key);

  final List<PaymentPreference> preferences;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final khaltiColor = KhaltiColor.of(context);
    final baseBorder = OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(6)),
      borderSide: BorderSide(color: khaltiColor.surface.shade300, width: 1),
    );

    return Theme(
      data: Theme.of(context).copyWith(
        appBarTheme: AppBarTheme(
          elevation: 0,
          color: colorScheme.background,
          foregroundColor: colorScheme.onPrimary,
          iconTheme: IconThemeData(color: khaltiColor.surface.shade400),
        ),
        tabBarTheme: TabBarTheme(
          unselectedLabelColor: khaltiColor.surface.shade50,
          unselectedLabelStyle: TextStyle(color: khaltiColor.surface.shade100),
          labelColor: colorScheme.onPrimary,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: baseBorder,
          focusedBorder: baseBorder.copyWith(
            borderSide: BorderSide(color: colorScheme.primary, width: 2),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16),
          labelStyle: TextStyle(fontWeight: FontWeight.normal),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            minimumSize: Size(64, 50),
            onPrimary: Colors.white,
          ),
        ),
      ),
      child: DefaultTabController(
        length: preferences.length,
        child: Scaffold(
          body: AnnotatedRegion(
            value: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarBrightness: Theme.of(context).brightness,
              statusBarIconBrightness:
                  Theme.of(context).brightness == Brightness.light
                      ? Brightness.dark
                      : Brightness.light,
            ),
            child: SafeArea(
              child: NestedScrollView(
                headerSliverBuilder: (context, _) {
                  return [
                    SliverAppBar(
                      title: Text(
                        preferences.length > 1
                            ? context.loc.chooseYourPaymentMethod
                            : context.loc.payWith(
                                _getTab(context, preferences.first).label,
                              ),
                      ),
                    ),
                    SliverPersistentHeader(
                      delegate: _TabBarDelegate(
                        tabBar: TabBar(
                          isScrollable: preferences.length > 2,
                          indicatorColor: Theme.of(context).primaryColor,
                          tabs: preferences
                              .map((p) => _getTab(context, p))
                              .toList(growable: false),
                        ),
                      ),
                      pinned: true,
                    )
                  ];
                },
                body: TabBarView(
                  children: preferences.map(_getView).toList(growable: false),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  KhaltiTab _getTab(BuildContext context, PaymentPreference preference) {
    switch (preference) {
      case PaymentPreference.khalti:
        return KhaltiTab(
          label: context.loc.khalti,
          iconAsset: 'payment/wallet.svg',
          horizontalPadding: 16,
        );
      case PaymentPreference.eBanking:
        return KhaltiTab(
          label: context.loc.eBanking,
          iconAsset: 'payment/ebanking.svg',
          horizontalPadding: 8,
        );
      case PaymentPreference.mobileBanking:
        return KhaltiTab(
          label: context.loc.mobileBanking,
          iconAsset: 'payment/mobilebanking.svg',
        );
      case PaymentPreference.connectIPS:
        return KhaltiTab(
          label: context.loc.connectIps,
          iconAsset: 'payment/connect-ips.svg',
          horizontalPadding: 8,
        );
      case PaymentPreference.sct:
        return KhaltiTab(
          label: context.loc.sct,
          iconAsset: 'payment/sct.svg',
          horizontalPadding: 16,
        );
    }
  }

  Widget _getView(PaymentPreference preference) {
    switch (preference) {
      case PaymentPreference.khalti:
        return WalletPaymentPage();
      case PaymentPreference.eBanking:
        return BankPaymentPage(paymentType: PaymentType.eBanking);
      case PaymentPreference.mobileBanking:
        return BankPaymentPage(paymentType: PaymentType.mobileCheckout);
      case PaymentPreference.connectIPS:
        return CardPaymentPage(paymentType: PaymentType.connectIPS);
      case PaymentPreference.sct:
        return CardPaymentPage(paymentType: PaymentType.sct);
    }
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  const _TabBarDelegate({required this.tabBar});

  final PreferredSizeWidget tabBar;

  @override
  double get minExtent => _height;

  @override
  double get maxExtent => _height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(child: tabBar),
        const Divider(thickness: 1, height: 1),
      ],
    );
  }

  @override
  bool shouldRebuild(_TabBarDelegate oldDelegate) {
    return oldDelegate.tabBar.hashCode != tabBar.hashCode;
  }

  double get _height => tabBar.preferredSize.height + 1;
}
