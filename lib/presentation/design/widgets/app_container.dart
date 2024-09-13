import 'package:estesis_tech/core/extensions/color_scheme_ext.dart';
import 'package:flutter/material.dart';

class AppContainer extends StatelessWidget {
  const AppContainer({
    super.key,
    this.width,
    this.height,
    this.boxShadow,
    this.border,
    this.child,
  });

  final double? width;
  final double? height;
  final List<BoxShadow>? boxShadow;
  final double? border;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: context.colorScheme.primary,
        borderRadius: border != null ? BorderRadius.circular(border!) : null,
        boxShadow: boxShadow,
      ),
      child: child,
    );
  }
}
