import 'package:flutter/material.dart';
import 'package:khalti/khalti.dart';
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
  String? _code;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Confirm Payment',
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Enter the OTP sent via SMS to mobile number ${widget.mobileNo}',
              style: Theme.of(context).textTheme.caption,
            ),
            const SizedBox(height: 24),
            CodeField(onChanged: (code) => _code = code),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () async {
                showProgressDialog(context, message: 'Confirming Payment');
                try {
                  final response = await Khalti.service.confirmPayment(
                    request: PaymentConfirmationRequestModel(
                      transactionPin: widget.mPin,
                      confirmationCode: _code!,
                      token: widget.token,
                    ),
                  );
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context, response);
                } catch (e) {
                  Navigator.pop(context);
                  showErrorDialog(
                    context,
                    error: e,
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      final errorInfo = ErrorInfo.from(e);

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
              },
              child: Text('VERIFY OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
