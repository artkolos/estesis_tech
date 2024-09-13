import 'package:estesis_tech/core/extensions/color_scheme_ext.dart';
import 'package:estesis_tech/core/extensions/locale_ext.dart';
import 'package:estesis_tech/domain/model/enum/priority.dart';
import 'package:estesis_tech/gen/fonts.gen.dart';
import 'package:estesis_tech/presentation/design/widgets/tap_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ChoosePriority extends StatelessWidget {
  const ChoosePriority({
    super.key,
    required this.onChanged,
    required this.currentValue,
  });

  final Function(Priority value) onChanged;
  final Priority currentValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.locale.priority,
          style: TextStyle(
            fontFamily: FontFamily.poppins,
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: context.colorScheme.surface,
          ),
        ),
        Gap(16.h),
        Row(
          children: [
            TapAnimation(
              onTap: () => onChanged.call(Priority.low),
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: 13.h,
                  horizontal: 20.w,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Priority.low == currentValue
                        ? context.colorScheme.primary
                        : context.colorScheme.onPrimary,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  context.locale.low,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: FontFamily.poppins,
                    color: Priority.low == currentValue
                        ? context.colorScheme.primary
                        : context.colorScheme.surface,
                  ),
                ),
              ),
            ),
            Gap(15.w),
            TapAnimation(
              onTap: () => onChanged.call(Priority.medium),
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: 13.h,
                  horizontal: 20.w,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Priority.medium == currentValue
                        ? context.colorScheme.primary
                        : context.colorScheme.surface,
                  ),
                ),
                child: Text(
                  context.locale.medium,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: FontFamily.poppins,
                    color: Priority.medium == currentValue
                        ? context.colorScheme.primary
                        : context.colorScheme.surface,
                  ),
                ),
              ),
            ),
            Gap(15.w),
            TapAnimation(
              onTap: () => onChanged.call(Priority.high),
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: 13.h,
                  horizontal: 20.w,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Priority.high == currentValue
                        ? context.colorScheme.primary
                        : context.colorScheme.surface,
                  ),
                ),
                child: Text(
                  context.locale.high,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: FontFamily.poppins,
                    color: Priority.high == currentValue
                        ? context.colorScheme.primary
                        : context.colorScheme.surface,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
