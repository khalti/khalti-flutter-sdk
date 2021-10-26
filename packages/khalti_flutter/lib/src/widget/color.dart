import 'package:flutter/material.dart';

class KhaltiColor extends InheritedWidget {
  KhaltiColor({required this.isDark, required Widget child})
      : super(child: child);

  final bool isDark;

  MaterialColor get surface => isDark ? _surfaceColorDark : _surfaceColorLight;

  static KhaltiColor of(BuildContext context) {
    final KhaltiColor? color = context.dependOnInheritedWidgetOfExactType();
    return color!;
  }

  @override
  bool updateShouldNotify(KhaltiColor old) => false;
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