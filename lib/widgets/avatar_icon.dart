import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../data/constants.dart';

class AvatarIcon extends StatelessWidget {
  final SvgPicture svg;
  const AvatarIcon({
    Key? key,
    required this.svg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: CircleAvatar(
        radius: iconSize,
        backgroundColor: themeData.dialogBackgroundColor.withAlpha(150),
        child: svg,
      ),
    );
  }
}
