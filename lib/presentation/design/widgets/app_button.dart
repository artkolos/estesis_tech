import 'package:estesis_tech/core/extensions/color_scheme_ext.dart';
import 'package:estesis_tech/gen/fonts.gen.dart';
import 'package:estesis_tech/presentation/design/widgets/app_container.dart';
import 'package:estesis_tech/presentation/design/widgets/tap_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.onTap,
    required this.title,
    this.boxShadow,
  });

  final VoidCallback onTap;
  final String title;
  final List<BoxShadow>? boxShadow;

  @override
  Widget build(BuildContext context) {
    return TapAnimation(
      onTap: onTap,
      child: AppContainer(
        border: 16,
        width: double.infinity,
        boxShadow: boxShadow ??
            const [
              BoxShadow(
                color: Color(0xFF8B78FF),
                blurRadius: 10,
                spreadRadius: -6,
                offset: Offset(
                  1,
                  8,
                ),
              ),
              BoxShadow(
                color: Color(0xFF5451D6),
                blurRadius: 20,
                spreadRadius: -10,
                offset: Offset(
                  1,
                  7,
                ),
              ),
            ],
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 16,
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16.sp,
                fontFamily: FontFamily.poppins,
                color: context.colorScheme.onPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
