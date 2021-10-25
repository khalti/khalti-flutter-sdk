import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:khalti/khalti.dart';
import 'package:khalti_flutter/src/helper/payment_config.dart';
import 'package:khalti_flutter/src/helper/payment_config_provider.dart';
import 'package:khalti_flutter/src/helper/payment_preference.dart';

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
    final baseBorder = OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(6)),
      borderSide: BorderSide(color: Color(0xFFD3D3D3), width: 1),
    );

    return Theme(
      data: ThemeData.from(
        colorScheme: ColorScheme.light(
          primary: Colors.deepPurple,
          secondary: Colors.purple,
        ),
        textTheme: TextTheme(
          button: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          caption: TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
          subtitle1: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ).copyWith(
        appBarTheme: AppBarTheme(
          elevation: 0,
          color: Colors.white,
          foregroundColor: Colors.deepPurple,
          iconTheme: IconThemeData(color: Color(0xFF474747)),
        ),
        tabBarTheme: TabBarTheme(
          unselectedLabelColor: Color(0xFF989898), //surface50
          unselectedLabelStyle: TextStyle(
            color: Color(0xFF848484), //surface100
          ),
          labelColor: Colors.deepPurple,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: baseBorder,
          focusedBorder: baseBorder.copyWith(
            borderSide: BorderSide(color: Colors.deepPurple, width: 2),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16),
          labelStyle: TextStyle(fontWeight: FontWeight.normal),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            minimumSize: Size(64, 50),
          ),
        ),
      ),
      child: PaymentConfigScope(
        config: config,
        child: KhaltiService.publicKey.startsWith('test_')
            ? Banner(
                location: BannerLocation.bottomEnd,
                message: 'TEST',
                child: _HomePage(preferences: preferences),
              )
            : _HomePage(preferences: preferences),
      ),
    );
  }
}

class _HomePage extends StatelessWidget {
  _HomePage({Key? key, required this.preferences}) : super(key: key);

  final List<PaymentPreference> preferences;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: preferences.length,
      child: Scaffold(
        body: AnnotatedRegion(
          value: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.dark,
          ),
          child: SafeArea(
            child: NestedScrollView(
              headerSliverBuilder: (context, _) {
                return [
                  SliverAppBar(
                    title: Text(
                      preferences.length > 1
                          ? 'Choose your payment method'
                          : 'Pay with Khalti',
                    ),
                  ),
                  SliverPersistentHeader(
                    delegate: _TabBarDelegate(
                      tabBar: TabBar(
                        isScrollable: preferences.length > 2,
                        indicatorColor: Theme.of(context).primaryColor,
                        tabs: preferences.map(_getTab).toList(growable: false),
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
    );
  }

  KhaltiTab _getTab(PaymentPreference preference) {
    switch (preference) {
      case PaymentPreference.khalti:
        return KhaltiTab(
          label: 'Khalti',
          iconAsset: 'payment/wallet.svg',
          horizontalPadding: 16,
        );
      case PaymentPreference.eBanking:
        return KhaltiTab(
          label: 'E-Banking',
          iconAsset: 'payment/ebanking.svg',
          horizontalPadding: 8,
        );
      case PaymentPreference.mobileBanking:
        return KhaltiTab(
          label: 'Mobile Banking',
          iconAsset: 'payment/mobilebanking.svg',
        );
      case PaymentPreference.connectIPS:
        return KhaltiTab(
          label: 'Connect IPS',
          iconAsset: 'payment/connect-ips.svg',
          horizontalPadding: 8,
        );
      case PaymentPreference.sct:
        return KhaltiTab(
          label: 'SCT',
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
