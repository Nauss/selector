import 'package:flutter/material.dart';
import 'package:selector/data/record.dart';

abstract class Action {
  const Action();
  Image image(BuildContext context);
  Icon icon(BuildContext context);
  Text text(BuildContext context);

  Future<void> execute(Record record);
}
