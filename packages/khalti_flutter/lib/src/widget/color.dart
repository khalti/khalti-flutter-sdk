// Copyright (c) 2021 The Khalti Authors. All rights reserved.

import 'package:flutter/material.dart';

/// The class defining color scheme for Khalti.
class KhaltiColor extends InheritedWidget {
  /// Creates [KhaltiColor] with the provided values.
  const KhaltiColor({
    Key? key,
    required this.isDark,
    required Widget child,
  }) : super(key: key, child: child);

  /// Whether it is dark mode or light mode.
  final bool isDark;

  /// The surface color variant.
  MaterialColor get surface => isDark ? _surfaceColorDark : _surfaceColorLight;

  /// Returns the [KhaltiColor] found in the [context].
  static KhaltiColor of(BuildContext context) {
    final KhaltiColor? color = context.dependOnInheritedWidgetOfExactType();
    return color!;
  }

  @override
  bool updateShouldNotify(KhaltiColor oldWidget) => false;
}

const int _rawSurface = 0xFF333333;

const MaterialColor _surfaceColorLight = MaterialColor(
  _rawSurface,
  {
    5: Color(0xFFF4F4F4),
    10: Color(0xFFEAEAEA),
    50: Color(0xFF989898),
    100: Color(0xFF848484),
    300: Color(0xFF5B5B5B),
    400: Color(0xFF474747),
    500: Color(_rawSurface),
  },
);

const MaterialColor _surfaceColorDark = MaterialColor(
  0xFFF4F4F4,
  {
    5: Color(0xFF1F1F1F),
    10: Color(0xFF474747),
    50: Color(0xFF989898),
    100: Color(0xFFADADAD),
    300: Color(0xFFD3D3D3),
    400: Color(0xFFEAEAEA),
    500: Color(0xFFF4F4F4),
  },
);
