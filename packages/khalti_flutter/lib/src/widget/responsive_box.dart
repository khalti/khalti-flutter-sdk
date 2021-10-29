// Copyright (c) 2021 The Khalti Authors. All rights reserved.

import 'package:flutter/material.dart';

/// The widget which constraints it's [child] depending upon the screen size.
class ResponsiveBox extends StatelessWidget {
  /// Creates [ResponsiveBox] with the provided properties.
  const ResponsiveBox({
    Key? key,
    required this.child,
    this.alignment = Alignment.center,
  }) : super(key: key);

  /// The [child] widget.
  final Widget child;

  /// How to align the child.
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 500) {
            return Align(
              alignment: alignment,
              child: ConstrainedBox(
                constraints: constraints.copyWith(maxWidth: 500, minWidth: 500),
                child: child,
              ),
            );
          }

          return child;
        },
      ),
    );
  }
}
