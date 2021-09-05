import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:network_to_file_image/network_to_file_image.dart';
import 'package:selector/data/constants.dart';
import 'package:selector/data/record_info.dart';
import 'package:path/path.dart' as p;

ImageProvider getImage(RecordInfo info) {
  if (!Uri.parse(info.image).isAbsolute) {
    return const AssetImage(
      'assets/missing.png',
    );
  }

  var fileName = "${info.artist}-${info.title}";
  String pathName = p.join(Globals.images!.path, fileName);
  var file = File(pathName);
  try {
    return NetworkToFileImage(url: info.image, file: file);
  } catch (e) {
    return const AssetImage(
      'assets/missing.png',
    );
  }
}

extension HexColor on Color {
  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}
