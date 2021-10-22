import 'package:flutter/material.dart';
import 'package:khalti_flutter/src/widget/fields.dart';
import 'package:khalti_flutter/src/widget/image.dart';
import 'package:khalti_flutter/src/widget/pay_button.dart';

class WalletPaymentPage extends StatelessWidget {
  const WalletPaymentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: KhaltiImage.asset(asset: 'logo/khalti.svg', height: 72),
        ),
        MobileField(
          onChanged: (mobile) {},
        ),
        const SizedBox(height: 24),
        PINField(
          onChanged: (pin) {},
        ),
        const SizedBox(height: 24),
        PayButton(
          amount: 1000,
          onPressed: () {},
        ),
        const SizedBox(height: 40),
        Text(
          'Forgot Khalti MPIN?',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Color(0xFF5B5B5B),
          ),
        ),
        const SizedBox(height: 8),
        const _ResetMPINSection(),
      ],
    );
  }
}

class _ResetMPINSection extends StatelessWidget {
  const _ResetMPINSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        style: TextButton.styleFrom(
          minimumSize: Size(144, 40),
          textStyle: Theme.of(context).textTheme.button?.copyWith(
                fontSize: 14,
              ),
        ),
        child: Text('RESET KHALTI MPIN'),
        onPressed: () {},
      ),
    );
  }
}
