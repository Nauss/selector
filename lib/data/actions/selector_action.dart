import 'package:flutter/material.dart';
import 'package:selector/data/record.dart';

abstract class SelectorAction {
  const SelectorAction();
  Widget image(BuildContext context);
  Widget text(BuildContext context);

  Future<void> execute(Record record);
}
