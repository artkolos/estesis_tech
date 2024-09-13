import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:estesis_tech/core/extensions/color_scheme_ext.dart';
import 'package:estesis_tech/core/extensions/locale_ext.dart';
import 'package:estesis_tech/domain/model/tag/tag.dart';
import 'package:estesis_tech/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class TagsDropdownButton extends StatelessWidget {
  const TagsDropdownButton({
    super.key,
    required this.title,
    required this.tags,
    required this.onSaved,
  });

  final String title;
  final List<Tag> tags;
  final Function(Tag? value) onSaved;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
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
          DropdownButtonFormField2(
            buttonStyleData: ButtonStyleData(
              overlayColor: WidgetStatePropertyAll(context.colorScheme.onError),
            ),
            dropdownStyleData: DropdownStyleData(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
              ),
            ),
            hint: Text(
              context.locale.withoutTag,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 18,
                fontFamily: FontFamily.poppins,
                color: context.colorScheme.onSurface,
              ),
            ),
            isExpanded: true,
            iconStyleData: IconStyleData(
              icon: Icon(
                Icons.keyboard_arrow_down_outlined,
                color: context.colorScheme.primary,
              ),
            ),
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: context.colorScheme.onPrimary,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: context.colorScheme.onPrimary,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: context.colorScheme.onPrimary,
                ),
              ),
            ),
            items: [
              ...tags.map(
                (e) => DropdownMenuItem(
                  onTap: () {
                    onSaved.call(e);
                  },
                  value: e.name,
                  child: Text(
                    e.name,
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: FontFamily.poppins,
                      fontWeight: FontWeight.w400,
                      color: context.colorScheme.onSecondary,
                    ),
                  ),
                ),
              ),
            ],
            onChanged: (value) {},
          ),
          Gap(16.h),
        ],
      ),
    );
  }
}
