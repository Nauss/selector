import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EmptySelector extends StatefulWidget {
  const EmptySelector({Key? key}) : super(key: key);

  @override
  State<EmptySelector> createState() => _EmptySelectorState();
}

class _EmptySelectorState extends State<EmptySelector>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    animation = Tween<double>(begin: 0, end: 1).animate(controller);
    controller.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    return Stack(
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                locale.emptySelector,
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(height: 16),
              Text(
                locale.addRecords,
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 50,
          right: 50,
          child: AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return FadeTransition(
                opacity: animation,
                child: Transform.translate(
                  offset: Offset(animation.value * 10, animation.value * 10),
                  child: child,
                ),
              );
            },
            child: Transform.rotate(
              angle: -pi / 2.4,
              child: const Icon(
                Icons.play_arrow,
                size: 100,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
