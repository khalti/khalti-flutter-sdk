// Copyright (c) 2021 The Khalti Authors. All rights reserved.

import 'package:flutter/material.dart';
import 'package:khalti/khalti.dart';
import 'package:khalti_flutter/localization/khalti_localizations.dart';
import 'package:khalti_flutter/src/helper/error_info.dart';
import 'package:khalti_flutter/src/widget/dialogs.dart';
import 'package:khalti_flutter/src/widget/fields.dart';
import 'package:khalti_flutter/src/widget/responsive_box.dart';

/// The page for confirming the payment made.
class ConfirmationPage extends StatefulWidget {
  /// Creates [ConfirmationPage] with the provided values.
  const ConfirmationPage({
    Key? key,
    required this.token,
    required this.mobileNo,
    required this.mPin,
  }) : super(key: key);

  /// The [token] received at payment initiation step.
  final String token;

  /// The [mobileNo] to which the confirmation payment code was sent.
  final String mobileNo;

  /// The Khalti MPIN.
  final String mPin;

  @override
  State<ConfirmationPage> createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends State<ConfirmationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  String? _code;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc.confirmPayment),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ResponsiveBox(
          alignment: Alignment.topLeft,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  context.loc.enterOtpSentTo(widget.mobileNo),
                  style: Theme.of(context).textTheme.caption,
                ),
                const SizedBox(height: 24),
                CodeField(onChanged: (code) => _code = code),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _confirmPayment,
                  child: Text(context.loc.verifyOTP.toUpperCase()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmPayment() async {
    final navigator = Navigator.of(context);
    if (_formKey.currentState?.validate() ?? false) {
      showProgressDialog(
        context,
        message: context.loc.confirmingPayment,
      );
      try {
        final response = await Khalti.service.confirmPayment(
          request: PaymentConfirmationRequestModel(
            transactionPin: widget.mPin,
            confirmationCode: _code!,
            token: widget.token,
          ),
        );
        navigator.popUntil(ModalRoute.withName('/kpg'));
        navigator.pop(response);
      } catch (e) {
        Navigator.pop(context);
        showErrorDialog(
          context,
          error: e,
          onPressed: () {
            Navigator.popUntil(
              context,
              ModalRoute.withName('/kpg'),
            );
            final errorInfo = ErrorInfo.from(context, e);

            Navigator.pop(
              context,
              PaymentFailureModel(
                message: errorInfo.secondary ?? errorInfo.primary,
                data: errorInfo.data,
              ),
            );
          },
        );
      }
    }
  }
}
