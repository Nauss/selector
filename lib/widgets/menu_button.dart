import 'package:flutter/material.dart';
import 'dart:math' as math;

const Map<String, Map<String, dynamic>> movement = {
  'top': {
    'translateOffset': Offset(-36 / 2, -(36 / 2 + 6)),
    'rotateOffset': Offset(-28, 0),
    'angle': math.pi / 8
  },
  'center': {
    'translateOffset': Offset(-36 / 2, -(36 / 2 + 6)),
    'rotateOffset': Offset(-28, 0),
    'angle': math.pi / 4
  }
};

class MenuButton extends StatelessWidget {
  final Widget icon;
  final void Function() onPressed;
  final Widget label;
  final String position;
  const MenuButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.onPressed,
    required this.position,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: movement[position]!['translateOffset'],
      child: Transform.rotate(
        // angle: 0,
        angle: movement[position]!['angle'],
        origin: movement[position]!['rotateOffset'],
        child: TextButton.icon(
          style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              const EdgeInsets.all(0),
            ),
            // backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
          ),
          onPressed: onPressed,
          icon: icon,
          label: label,
        ),
      ),
    );
  }
}
