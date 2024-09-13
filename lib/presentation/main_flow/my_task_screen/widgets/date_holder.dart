import 'package:estesis_tech/core/extensions/color_scheme_ext.dart';
import 'package:estesis_tech/core/extensions/string_ext.dart';
import 'package:estesis_tech/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class DateHolder extends StatelessWidget {
  const DateHolder({
    super.key,
    required this.dateTime,
    required this.isSelectedDate,
  });

  final DateTime dateTime;
  final bool isSelectedDate;

  @override
  Widget build(BuildContext context) {
    final day = DateFormat('EEE', 'ru_RU').format(dateTime).capitalize();
    final date = dateTime.day.toString();
    return Container(
      width: 64.w,
      height: 118.h,
      decoration: BoxDecoration(
        color: isSelectedDate ? context.colorScheme.primary : Colors.white,
        border: Border.all(
          color: isSelectedDate
              ? context.colorScheme.primary
              : context.colorScheme.onPrimary,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            date,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 25,
              fontFamily: FontFamily.poppins,
              color:
                  isSelectedDate ? Colors.white : context.colorScheme.surface,
            ),
            textAlign: TextAlign.center,
          ),
          Gap(8.h),
          Text(
            day,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              fontFamily: FontFamily.poppins,
              color:
                  isSelectedDate ? Colors.white : context.colorScheme.surface,
            ),
          ),
        ],
      ),
    );
  }
}
