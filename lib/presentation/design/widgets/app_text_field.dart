import 'package:estesis_tech/core/extensions/color_scheme_ext.dart';
import 'package:estesis_tech/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.obscureText = false,
    this.prefixIcon,
    this.focusNode,
  });

  final TextEditingController controller;
  final String hint;
  final bool obscureText;
  final FocusNode? focusNode;
  final Widget? prefixIcon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      controller: controller,
      style: TextStyle(
        fontFamily: FontFamily.poppins,
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        color: context.colorScheme.onSecondary,
      ),
      keyboardType: TextInputType.emailAddress,
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        hintText: hint,
        hintStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 16.sp,
          color: context.colorScheme.surface,
          // fontFamily: FontFamily.poppins,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            16,
          ),
          borderSide: BorderSide(
            color: context.colorScheme.primary,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            16,
          ),
          borderSide: BorderSide(
            color: context.colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }
}
