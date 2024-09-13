import 'package:estesis_tech/core/extensions/color_scheme_ext.dart';
import 'package:estesis_tech/core/extensions/tags_ext.dart';
import 'package:estesis_tech/domain/model/enum/tag_type.dart';
import 'package:estesis_tech/gen/fonts.gen.dart';
import 'package:estesis_tech/presentation/design/widgets/tap_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TagsPanel extends StatelessWidget {
  const TagsPanel({
    super.key,
    this.currentType = TagType.all,
    required this.onChange,
  });

  final TagType currentType;
  final Function(TagType value) onChange;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...TagType.values.map(
          (e) => TapAnimation(
            onTap: () => onChange.call(e),
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: 4.h,
                horizontal: 10.w,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: currentType == e
                      ? context.colorScheme.primary
                      : Colors.white,
                ),
              ),
              child: Text(
                e.tagName(context),
                style: currentType == e
                    ? TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                        fontFamily: FontFamily.poppins,
                        color: context.colorScheme.onSecondary,
                      )
                    : TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                        fontFamily: FontFamily.poppins,
                        color: context.colorScheme.surface,
                      ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
