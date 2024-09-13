import 'package:estesis_tech/core/extensions/color_scheme_ext.dart';
import 'package:estesis_tech/core/extensions/locale_ext.dart';
import 'package:estesis_tech/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class DateTimeField extends StatelessWidget {
  const DateTimeField({
    super.key,
    required this.onTap,
    required this.title,
    required this.value,
  });

  final String title;
  final VoidCallback onTap;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: FontFamily.poppins,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: context.colorScheme.surface,
          ),
        ),
        Gap(16.h),
        Container(
          width: 148.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: context.colorScheme.onPrimary,
            ),
          ),
          child: GestureDetector(
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 17.h,
                horizontal: 20.w,
              ),
              child: Text(
                value,
                style: TextStyle(
                  fontFamily: FontFamily.poppins,
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                  color: context.colorScheme.onSecondary,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
