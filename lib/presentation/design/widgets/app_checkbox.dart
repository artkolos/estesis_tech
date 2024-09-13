import 'package:estesis_tech/core/extensions/color_scheme_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppCheckbox extends StatelessWidget {
  const AppCheckbox({
    super.key,
    required this.onChanged,
    this.size,
    required this.currentValue,
  });

  final Function(bool value) onChanged;

  final double? size;
  final bool currentValue;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        onChanged.call(!currentValue);
      },
      child: Container(
        width: size ?? 13.88.w,
        height: size ?? 13.88.h,
        decoration: BoxDecoration(
          color: currentValue ? context.colorScheme.secondary : null,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: context.colorScheme.onSecondary,
            width: 1.2,
          ),
        ),
        child: currentValue
            ? const Icon(
                Icons.check,
                size: 10,
              )
            : null,
      ),
    );
  }
}
