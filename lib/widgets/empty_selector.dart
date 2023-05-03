import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:math';

import 'package:selector/widgets/pointing_arrow.dart';

class EmptySelector extends StatefulWidget {
  const EmptySelector({Key? key}) : super(key: key);

  @override
  State<EmptySelector> createState() => _EmptySelectorState();
}

class _EmptySelectorState extends State<EmptySelector> {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    final themeData = Theme.of(context);
    return Stack(
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                locale.emptySelector,
                style: themeData.textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    locale.addRecords,
                    style: themeData.textTheme.titleMedium,
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.menu, color: themeData.primaryColor),
                ],
              ),
            ],
          ),
        ),
        const Positioned(
          top: 45,
          left: 20,
          child: PointingArrow(angle: -(pi / 2 + pi / 5.5), size: 100),
        )
      ],
    );
  }
}
