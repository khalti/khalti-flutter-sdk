import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:khalti_flutter/src/helper/validators.dart';

import 'color.dart';

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

class CodeField extends StatelessWidget {
  const CodeField({
    Key? key,
    required this.onChanged,
  }) : super(key: key);

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: Validators.code,
      decoration: InputDecoration(
        label: Text('Payment Code'),
        prefixIcon: Icon(Icons.password),
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      onChanged: onChanged,
    );
  }
}

const double _searchFieldHeight = 40;

class SearchField extends StatelessWidget {
  const SearchField({Key? key, required this.controller}) : super(key: key);

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    const constraint = BoxConstraints(
      minHeight: _searchFieldHeight,
      minWidth: _searchFieldHeight,
    );
    final bodyText2 = Theme.of(context).textTheme.bodyText2;
    final khaltiColor = KhaltiColor.of(context);

    return Material(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (context, value, prefixIcon) {
            return TextFormField(
              controller: controller,
              decoration: InputDecoration(
                labelText: 'Search Bank',
                hintText: 'Search Bank',
                labelStyle: bodyText2?.copyWith(color: khaltiColor.surface),
                hintStyle: bodyText2?.copyWith(
                  color: Theme.of(context).disabledColor,
                  fontWeight: FontWeight.w300,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.secondary,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                fillColor: Theme.of(context).colorScheme.secondary,
                filled: true,
                isCollapsed: true,
                floatingLabelBehavior: FloatingLabelBehavior.never,
                prefixIconConstraints: constraint,
                suffixIconConstraints: constraint,
                prefixIcon: prefixIcon!,
                suffixIcon: value.text.isEmpty
                    ? null
                    : IconButton(
                        splashRadius: 20,
                        onPressed: controller.clear,
                        constraints: constraint,
                        icon: Icon(Icons.close, size: 24),
                      ),
              ),
              textAlignVertical: TextAlignVertical.center,
            );
          },
          child: Icon(Icons.search, size: 24),
        ),
      ),
    );
  }
}
