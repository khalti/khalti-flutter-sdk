// Copyright (c) 2021 The Khalti Authors. All rights reserved.

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:khalti_flutter/localization/khalti_localizations.dart';
import 'package:khalti_flutter/src/helper/payment_config_scope.dart';
import 'package:khalti_flutter/src/helper/validators.dart';

import 'color.dart';

/// The Khalti Mobile Number field.
class MobileField extends StatefulWidget {
  /// Creates [MobileField].
  const MobileField({
    Key? key,
    required this.onChanged,
  }) : super(key: key);

  /// Called when the mobile number changes.
  final ValueChanged<String> onChanged;

  @override
  State<MobileField> createState() => _MobileFieldState();
}

class _MobileFieldState extends State<MobileField> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      final mobile = _config?.mobile;
      if (mobile != null) widget.onChanged(mobile);
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: _config?.mobile,
      readOnly: _config?.mobileReadOnly ?? false,
      validator: Validators(context).mobile,
      decoration: InputDecoration(
        label: Text(context.loc.khaltiMobileNumber),
        prefixIcon: const Icon(Icons.perm_identity),
        counterText: '',
      ),
      keyboardType: TextInputType.phone,
      maxLength: 10,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      onChanged: widget.onChanged,
    );
  }

  PaymentConfig? get _config => PaymentConfigScope.mayBeOf(context);
}

/// The Khalti MPIN field.
class PINField extends StatelessWidget {
  /// Creates [PINField].
  const PINField({
    Key? key,
    required this.onChanged,
  }) : super(key: key);

  /// Called when the MPIN changes.
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: Validators(context).pin,
      decoration: InputDecoration(
        label: Text(context.loc.khaltiMPIN),
        prefixIcon: const Icon(Icons.password),
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      obscureText: true,
      obscuringCharacter: '*',
      onChanged: onChanged,
    );
  }
}

/// The Payment Code field.
class CodeField extends StatelessWidget {
  /// Creates [CodeField].
  const CodeField({
    Key? key,
    required this.onChanged,
  }) : super(key: key);

  /// Called when the payment code changes.
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: Validators(context).code,
      decoration: InputDecoration(
        label: Text(context.loc.paymentCode),
        prefixIcon: const Icon(Icons.password),
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      onChanged: onChanged,
    );
  }
}

const double _searchFieldHeight = 40;

/// The Search field.
class SearchField extends StatelessWidget {
  /// Creates [SearchField].
  const SearchField({Key? key, required this.controller}) : super(key: key);

  /// The text editing controller associated with the search field.
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    const constraint = BoxConstraints(
      minHeight: _searchFieldHeight,
      minWidth: _searchFieldHeight,
    );
    final bodyText2 = Theme.of(context).textTheme.bodyMedium;
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
                labelText: context.loc.searchBank,
                hintText: context.loc.searchBank,
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
                        icon: const Icon(Icons.close, size: 24),
                      ),
              ),
              textAlignVertical: TextAlignVertical.center,
            );
          },
          child: const Icon(Icons.search, size: 24),
        ),
      ),
    );
  }
}
