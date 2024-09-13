import 'package:estesis_tech/core/extensions/color_scheme_ext.dart';
import 'package:estesis_tech/gen/fonts.gen.dart';
import 'package:estesis_tech/presentation/design/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CreateTaskTextField extends StatelessWidget {
  const CreateTaskTextField({
    super.key,
    required this.title,
    required this.hint,
    required this.controller,
  });

  final String title;
  final String hint;
  final TextEditingController controller;

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
        AppTextField(
          controller: controller,
          hint: hint,
        ),
      ],
    );
  }
}
