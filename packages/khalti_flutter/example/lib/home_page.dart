import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:khalti_flutter_example/app_preference.dart';
import 'package:provider/provider.dart';

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
            KhaltiButton(
              config: config,
              onSuccess: onSuccess,
              onFailure: onFailure,
              onCancel: onCancel,
            ),
            const SizedBox(height: 8),
            KhaltiButton.wallet(
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
            const SizedBox(height: 8),
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
                shape: const StadiumBorder(),
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
