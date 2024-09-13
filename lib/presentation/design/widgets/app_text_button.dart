import 'package:estesis_tech/core/extensions/color_scheme_ext.dart';
import 'package:estesis_tech/gen/fonts.gen.dart';
import 'package:estesis_tech/presentation/design/widgets/tap_animation.dart';
import 'package:flutter/material.dart';

class AppTextButton extends StatelessWidget {
  const AppTextButton({
    super.key,
    required this.title,
    required this.onTap,
  });

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TapAnimation(
      onTap: onTap,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          fontFamily: FontFamily.poppins,
          color: context.colorScheme.primary,
        ),
      ),
    );
  }
}
