import 'package:flutter/material.dart';

class PayButton extends StatelessWidget {
  const PayButton({
    Key? key,
    required this.amount,
    required this.onPressed,
  }) : super(key: key);

  final int amount;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _AmountWidget(amount: amount),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: onPressed,
          child: Text('PAY'),
        ),
      ],
    );
  }
}

class _AmountWidget extends StatelessWidget {
  const _AmountWidget({Key? key, required this.amount}) : super(key: key);

  final int amount;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Amount',
          style: Theme.of(context)
              .textTheme
              .caption!
              .copyWith(color: Color(0xFF989898)),
        ),
        const SizedBox(height: 4),
        Text(
          'Rs. ${amount ~/ 100}',
          style: Theme.of(context).textTheme.headline6?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}
