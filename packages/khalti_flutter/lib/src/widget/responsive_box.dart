import 'package:flutter/material.dart';

class ResponsiveBox extends StatelessWidget {
  const ResponsiveBox({
    Key? key,
    required this.child,
    this.alignment = Alignment.center,
  }) : super(key: key);

  final Widget child;
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
