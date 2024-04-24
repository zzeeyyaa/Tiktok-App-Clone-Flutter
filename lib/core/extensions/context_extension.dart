import 'package:flutter/material.dart';

extension ContextExt on BuildContext {
  ThemeData get theme => Theme.of(this);

  MediaQueryData get mediaQeery => MediaQuery.of(this);

  Size get size => mediaQeery.size;
  double get height => size.height;
  double get width => size.width;
}
