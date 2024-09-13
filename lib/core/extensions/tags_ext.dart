import 'package:estesis_tech/core/extensions/locale_ext.dart';
import 'package:estesis_tech/domain/model/enum/tag_type.dart';
import 'package:flutter/cupertino.dart';

extension TagsExt on TagType {
  String tagName(BuildContext context) {
    switch (this) {
      case TagType.all:
        return context.locale.all;
      case TagType.work:
        return context.locale.work;
      case TagType.family:
        return context.locale.family;
      case TagType.study:
        return context.locale.study;
      case TagType.purchases:
        return context.locale.purchases;
    }
  }
}
