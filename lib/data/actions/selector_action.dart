import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:selector/data/record.dart';

abstract class SelectorAction {
  const SelectorAction();
  SvgPicture image(BuildContext context);
  Icon icon(BuildContext context);
  Text text(BuildContext context);

  Future<void> execute(Record record);
}
