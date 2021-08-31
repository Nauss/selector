import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:network_to_file_image/network_to_file_image.dart';
import 'package:selector/data/constants.dart';
import 'package:selector/data/record_info.dart';
import 'package:path/path.dart' as p;

ImageProvider getImage(RecordInfo info) {
  if (!Uri.parse(info.image).isAbsolute) {
    return AssetImage(
      'assets/missing.png',
    );
  }

  var fileName = "${info.artist}-${info.title}";
  String pathName = p.join(Globals.images!.path, fileName);
  var file = File(pathName);
  try {
    return NetworkToFileImage(url: info.image, file: file);
  } catch (e) {
    return AssetImage(
      'assets/missing.png',
    );
  }
}
