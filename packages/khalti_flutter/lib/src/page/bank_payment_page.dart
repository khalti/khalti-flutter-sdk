import 'package:flutter/material.dart';
import 'package:khalti/khalti.dart';
import 'package:khalti_flutter/src/helper/payment_config_provider.dart';
import 'package:khalti_flutter/src/widget/bank_tile.dart';
import 'package:khalti_flutter/src/widget/color.dart';
import 'package:khalti_flutter/src/widget/error_widget.dart';
import 'package:khalti_flutter/src/widget/fields.dart';
import 'package:khalti_flutter/src/widget/image.dart';
import 'package:khalti_flutter/src/widget/khalti_progress_indicator.dart';
import 'package:khalti_flutter/src/widget/pay_button.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

class BankPaymentPage extends StatefulWidget {
  const BankPaymentPage({
    Key? key,
    required this.paymentType,
  }) : super(key: key);

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

    final config = PaymentConfigScope.of(context);

    return FutureBuilder<BankListModel>(
      future: banksFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: KhaltiProgressIndicator());
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
                    'Please select your Bank',
                    style: Theme.of(context).textTheme.caption,
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
                                error: {},
                                title: 'No banks found',
                                subtitle: 'Please search for another keyword',
                              )
                            : ListView.builder(
                                itemCount: filteredBanks.length,
                                itemBuilder: (context, index) {
                                  final bank = filteredBanks.elementAt(index);

                                  return KhaltiBankTile(
                                    name: bank.name,
                                    logoUrl: bank.logo,
                                    onTap: () {
                                      final isDark =
                                          Theme.of(context).brightness ==
                                              Brightness.dark;
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        builder: (ctx) {
                                          return KhaltiColor(
                                            isDark: isDark,
                                            child: _BankBottomSheet(
                                              logo: bank.logo,
                                              name: bank.name,
                                              amount: config.amount,
                                              onTap: (mobile) async {
                                                final url =
                                                    Khalti.service.buildBankUrl(
                                                  bankId: bank.idx,
                                                  mobile: mobile,
                                                  amount: config.amount,
                                                  productIdentity:
                                                      config.productIdentity,
                                                  productName:
                                                      config.productName,
                                                  paymentType:
                                                      widget.paymentType,
                                                  productUrl: config.productUrl,
                                                  additionalData:
                                                      config.additionalData,
                                                );
                                                await launcher.launch(url);
                                                Navigator.pop(context);
                                              },
                                            ),
                                          );
                                        },
                                      );
                                    },
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

        return SizedBox.shrink();
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
    final bottomMargin = 16 + MediaQuery.of(context).viewInsets.bottom;
    final titleStyle = Theme.of(context).textTheme.headline6?.copyWith(
          fontWeight: FontWeight.w600,
          height: 1.4,
        );

    return Card(
      margin: EdgeInsets.fromLTRB(16, 0, 16, bottomMargin),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
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
        ),
      ),
    );
  }
}
