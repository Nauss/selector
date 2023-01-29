import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DoubleSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;

  const DoubleSwitch({
    Key? key,
    required this.value,
    this.onChanged,
  }) : super(key: key);

  @override
  State<DoubleSwitch> createState() => _DoubleSwitchState();
}

class _DoubleSwitchState extends State<DoubleSwitch> {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    final themeData = Theme.of(context);
    var opacity = 1.0;
    if (widget.onChanged == null) {
      opacity = 0.5;
    }
    return Opacity(
      opacity: opacity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Image.asset(
              "assets/icons/icone multi vinyle.png",
              width: 30,
              height: 30,
            ),
          ),
          Expanded(child: Text(locale.double)),
          Switch.adaptive(
            value: widget.value,
            onChanged: widget.onChanged,
            activeColor: themeData.primaryColor,
            inactiveThumbColor: themeData.primaryColor,
          ),
        ],
      ),
    );
  }
}
