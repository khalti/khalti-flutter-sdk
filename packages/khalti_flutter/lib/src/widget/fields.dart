import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:khalti_flutter/src/helper/validators.dart';

class MobileField extends StatelessWidget {
  const MobileField({
    Key? key,
    required this.onChanged,
  }) : super(key: key);

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: Validators.mobile,
      decoration: InputDecoration(
        label: Text('Khalti Mobile Number'),
        prefixIcon: Icon(Icons.perm_identity),
      ),
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      onChanged: onChanged,
    );
  }
}

class PINField extends StatelessWidget {
  const PINField({
    Key? key,
    required this.onChanged,
  }) : super(key: key);

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: Validators.pin,
      decoration: InputDecoration(
        label: Text('Khalti MPIN'),
        prefixIcon: Icon(Icons.password),
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      onChanged: onChanged,
    );
  }
}
