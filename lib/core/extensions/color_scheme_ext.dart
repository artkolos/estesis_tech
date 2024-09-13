import 'package:flutter/material.dart';

extension ColorSchemeExt on BuildContext {
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
}
