// Copyright (c) 2021 The Khalti Authors. All rights reserved.

import 'package:flutter/material.dart';
import 'package:khalti/khalti.dart';
import 'package:khalti_flutter/localization/khalti_localizations.dart';
import 'package:khalti_flutter/src/helper/payment_config_scope.dart';
import 'package:khalti_flutter/src/util/url_launcher_util.dart';
import 'package:khalti_flutter/src/widget/bank_tile.dart';
import 'package:khalti_flutter/src/widget/color.dart';
import 'package:khalti_flutter/src/widget/error_widget.dart';
import 'package:khalti_flutter/src/widget/fields.dart';
import 'package:khalti_flutter/src/widget/image.dart';
import 'package:khalti_flutter/src/widget/khalti_progress_indicator.dart';
import 'package:khalti_flutter/src/widget/pay_button.dart';
import 'package:khalti_flutter/src/widget/responsive_box.dart';

/// The page for making payments using E-banking or Mobile Banking
class BankPaymentPage extends StatefulWidget {
  /// Creates [BankPaymentPage] with the provided [paymentType].
  const BankPaymentPage({
    Key? key,
    required this.paymentType,
  }) : super(key: key);

  /// The [PaymentType].
  final PaymentType paymentType;

  @override
  State<BankPaymentPage> createState() => _BankPaymentPageState();
}

class _BankPaymentPageState extends State<BankPaymentPage>
    with AutomaticKeepAliveClientMixin {
  late final Future<BankListModel> banksFuture;
  late final TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    banksFuture = Khalti.service.getBanks(paymentType: widget.paymentType);
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return FutureBuilder<BankListModel>(
      future: banksFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: KhaltiProgressIndicator());
        }

        if (snapshot.hasError) {
          return KhaltiErrorWidget(error: snapshot.error!);
        }

        if (snapshot.hasData) {
          final banks = snapshot.data!.banks;

          return Scaffold(
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text(
                    context.loc.pleaseSelectYourBank,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                Expanded(
                  child: ValueListenableBuilder<TextEditingValue>(
                    valueListenable: searchController,
                    builder: (context, query, _) {
                      final filteredBanks = banks.where(
                        (bank) => _contains(bank, query),
                      );

                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: filteredBanks.isEmpty
                            ? KhaltiErrorWidget(
                                error: const {},
                                title: context.loc.noBanksFound,
                                subtitle: context.loc.searchForAnotherKeyword,
                              )
                            : ListView.builder(
                                itemCount: filteredBanks.length,
                                itemBuilder: (context, index) {
                                  return _BankTile(
                                    bank: filteredBanks.elementAt(index),
                                    paymentType: widget.paymentType,
                                  );
                                },
                              ),
                      );
                    },
                  ),
                ),
              ],
            ),
            bottomSheet: SearchField(controller: searchController),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  bool _contains(BankModel bank, TextEditingValue query) {
    final queryText = query.text.toLowerCase();

    return bank.name.toLowerCase().contains(queryText) ||
        bank.shortName.toLowerCase().contains(queryText);
  }

  @override
  bool get wantKeepAlive => true;
}

class _BankTile extends StatelessWidget {
  const _BankTile({
    Key? key,
    required this.bank,
    required this.paymentType,
  }) : super(key: key);

  final BankModel bank;
  final PaymentType paymentType;

  @override
  Widget build(BuildContext context) {
    final config = PaymentConfigScope.of(context);

    return KhaltiBankTile(
      name: bank.name,
      logoUrl: bank.logo,
      onTap: () {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (ctx) {
            return PaymentConfigScope(
              config: config,
              child: KhaltiColor(
                isDark: isDark,
                child: _BankBottomSheet(
                  logo: bank.logo,
                  name: bank.name,
                  amount: config.amount,
                  onTap: (mobile) async {
                    final navigator = Navigator.of(context);
                    final url = Khalti.service.buildBankUrl(
                      bankId: bank.idx,
                      mobile: mobile,
                      amount: config.amount,
                      productIdentity: config.productIdentity,
                      productName: config.productName,
                      paymentType: paymentType,
                      productUrl: config.productUrl,
                      additionalData: config.additionalData,
                      returnUrl: config.returnUrl,
                    );
                    await urlLauncher.launch(url);
                    navigator.pop();
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _BankBottomSheet extends StatefulWidget {
  const _BankBottomSheet({
    Key? key,
    required this.name,
    required this.logo,
    required this.amount,
    required this.onTap,
  }) : super(key: key);

  final String name;
  final String logo;
  final int amount;
  final ValueChanged<String> onTap;

  @override
  State<_BankBottomSheet> createState() => _BankBottomSheetState();
}

class _BankBottomSheetState extends State<_BankBottomSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  String? _khaltiMobileNumber;

  @override
  Widget build(BuildContext context) {
    final bottomMargin = 10 + MediaQuery.of(context).viewInsets.bottom;
    final titleStyle = Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          height: 1.4,
        );

    return ResponsiveBox(
      alignment: Alignment.bottomLeft,
      child: Card(
        margin: EdgeInsets.fromLTRB(16, 0, 16, bottomMargin),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Align(
                alignment: Alignment.topRight,
                child: _CloseButton(),
              ),
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox.square(
                          dimension: 32,
                          child: KhaltiImage.network(url: widget.logo),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(widget.name, style: titleStyle),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    MobileField(
                      onChanged: (number) => _khaltiMobileNumber = number,
                    ),
                    const SizedBox(height: 24),
                    PayButton(
                      amount: widget.amount,
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          widget.onTap(_khaltiMobileNumber!);
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _CloseButton extends StatelessWidget {
  const _CloseButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: KhaltiColor.of(context).surface.shade50,
        ),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Icon(
            Icons.close,
            color: Theme.of(context).scaffoldBackgroundColor,
            size: 14,
          ),
        ),
      ),
      onPressed: () => Navigator.maybePop(context),
    );
  }
}
