// Copyright (c) 2021 The Khalti Authors. All rights reserved.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:khalti/khalti.dart';
import 'package:khalti_flutter/localization/khalti_localizations.dart';

import 'helper/assets.dart';
import 'helper/payment_config.dart';
import 'helper/payment_config_scope.dart';
import 'helper/payment_preference.dart';
import 'page/bank_payment_page.dart';
import 'page/card_payment_page.dart';
import 'page/wallet_payment_page.dart';
import 'widget/color.dart';
import 'widget/tab.dart';

/// The payment page for Khalti Payment Gateway.
class PaymentPage extends StatelessWidget {
  /// Creates [PaymentPage] with the provided [config] and [preferences].
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

  /// The [PaymentConfig].
  final PaymentConfig config;

  /// The [PaymentPreference]s.
  final List<PaymentPreference> preferences;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final colorScheme = isDark
        ? const ColorScheme.dark(
            primary: Colors.deepPurple,
            onPrimary: Colors.white,
            secondary: Color(0xFF12091D),
          )
        : const ColorScheme.light(
            primary: Colors.deepPurple,
            onPrimary: Colors.deepPurple,
            secondary: Color(0xFFDED5E9),
          );

    return KhaltiColor(
      isDark: isDark,
      child: Theme(
        data: ThemeData.from(
          colorScheme: colorScheme,
          textTheme: const TextTheme(
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
                  child: _MainPage(preferences: preferences),
                )
              : _MainPage(preferences: preferences),
        ),
      ),
    );
  }
}

class _MainPage extends StatelessWidget {
  const _MainPage({Key? key, required this.preferences}) : super(key: key);

  final List<PaymentPreference> preferences;

  @override
  Widget build(BuildContext context) {
    final title = preferences.length > 1
        ? context.loc.chooseYourPaymentMethod
        : context.loc.payWith(_getTab(context, preferences.first).label);

    return Theme(
      data: _themeData(context),
      child: DefaultTabController(
        length: preferences.length,
        child: Scaffold(
          body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: _systemUiOverlayStyle(context),
            child: SafeArea(
              child: NestedScrollView(
                headerSliverBuilder: (context, _) {
                  return [
                    SliverAppBar(title: Text(title)),
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
                  children: preferences.map(_getView).toList(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  SystemUiOverlayStyle _systemUiOverlayStyle(BuildContext context) {
    return SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Theme.of(context).brightness,
      statusBarIconBrightness: Theme.of(context).brightness == Brightness.light
          ? Brightness.dark
          : Brightness.light,
    );
  }

  ThemeData _themeData(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final khaltiColor = KhaltiColor.of(context);
    final baseBorder = OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(6)),
      borderSide: BorderSide(color: khaltiColor.surface.shade300, width: 1),
    );

    return Theme.of(context).copyWith(
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        labelStyle: const TextStyle(fontWeight: FontWeight.normal),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(64, 50),
          onPrimary: Colors.white,
        ),
      ),
    );
  }

  KhaltiTab _getTab(BuildContext context, PaymentPreference preference) {
    switch (preference) {
      case PaymentPreference.khalti:
        return KhaltiTab(
          label: context.loc.khalti,
          iconAsset: a_walletIcon,
          horizontalPadding: 16,
        );
      case PaymentPreference.eBanking:
        return KhaltiTab(
          label: context.loc.eBanking,
          iconAsset: a_eBankingIcon,
          horizontalPadding: 8,
        );
      case PaymentPreference.mobileBanking:
        return KhaltiTab(
          label: context.loc.mobileBanking,
          iconAsset: a_mobileBankingIcon,
        );
      case PaymentPreference.connectIPS:
        return KhaltiTab(
          label: context.loc.connectIps,
          iconAsset: a_connectIpsIcon,
          horizontalPadding: 8,
        );
      case PaymentPreference.sct:
        return KhaltiTab(
          label: context.loc.sct,
          iconAsset: a_sctIcon,
          horizontalPadding: 16,
        );
    }
  }

  Widget _getView(PaymentPreference preference) {
    switch (preference) {
      case PaymentPreference.khalti:
        return const WalletPaymentPage();
      case PaymentPreference.eBanking:
        return const BankPaymentPage(paymentType: PaymentType.eBanking);
      case PaymentPreference.mobileBanking:
        return const BankPaymentPage(paymentType: PaymentType.mobileCheckout);
      case PaymentPreference.connectIPS:
        return const CardPaymentPage(paymentType: PaymentType.connectIPS);
      case PaymentPreference.sct:
        return const CardPaymentPage(paymentType: PaymentType.sct);
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
