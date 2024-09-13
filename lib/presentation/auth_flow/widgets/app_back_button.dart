import 'package:auto_route/auto_route.dart';
import 'package:estesis_tech/core/extensions/color_scheme_ext.dart';
import 'package:estesis_tech/presentation/design/widgets/tap_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppBackButton extends StatelessWidget {
  const AppBackButton({
    super.key,
    this.icon,
    this.onTap,
  });

  final Icon? icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return TapAnimation(
      onTap: onTap ?? context.maybePop,
      child: Container(
        width: 42.w,
        height: 42.h,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: context.colorScheme.onPrimary,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(11),
          child: icon ??
              Icon(
                Icons.arrow_back_ios,
                size: 20,
                color: context.colorScheme.onSecondary,
              ),
        ),
      ),
    );
  }
}
