import 'package:flutter/material.dart';
import 'package:khalti/khalti.dart';
import 'package:khalti_flutter/localization/khalti_localizations.dart';
import 'package:khalti_flutter/src/helper/error_info.dart';
import 'package:khalti_flutter/src/widget/dialogs.dart';
import 'package:khalti_flutter/src/widget/fields.dart';

class ConfirmationPage extends StatefulWidget {
  const ConfirmationPage({
    Key? key,
    required this.token,
    required this.mobileNo,
    required this.mPin,
  }) : super(key: key);

  final String token;
  final String mobileNo;
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
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
    );
  }

  Future<void> _confirmPayment() async {
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
        Navigator.popUntil(context, ModalRoute.withName('kpg'));
        Navigator.pop(context, response);
      } catch (e) {
        Navigator.pop(context);
        showErrorDialog(
          context,
          error: e,
          onPressed: () {
            Navigator.popUntil(
              context,
              ModalRoute.withName('kpg'),
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
