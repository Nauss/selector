import 'package:flutter/material.dart';
import 'package:selector/screens/search_screen.dart';

import 'package:selector/widgets/menu_button.dart';

const drawerSize = 500.0;
const halfDrawerSize = drawerSize / 2;

class SelectorMenu extends StatefulWidget {
  const SelectorMenu({
    Key? key,
  }) : super(key: key);

  @override
  State<SelectorMenu> createState() => _SelectorMenuState();
}

class _SelectorMenuState extends State<SelectorMenu>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 2000),
    vsync: this,
  )..animateTo(1);
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.elasticOut,
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned(
          top: -halfDrawerSize,
          left: -halfDrawerSize - 1, // -1 to hide the white part of the vinyl
          child: RotationTransition(
            turns: _animation,
            alignment: Alignment.center,
            child: Stack(
              children: [
                Image.asset(
                  'assets/missing.png',
                  width: drawerSize,
                  height: drawerSize,
                ),
                Positioned(
                  top: drawerSize - 220,
                  left: drawerSize - 140,
                  child: MenuButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const SearchScreen();
                          },
                        ),
                      );
                    },
                    icon: const Icon(Icons.add_circle, size: 36),
                    label: const Text('Ajouter'),
                    position: 'top',
                  ),
                ),
                Positioned(
                  top: drawerSize - 180,
                  left: drawerSize - 180,
                  child: MenuButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const SearchScreen();
                          },
                        ),
                      );
                    },
                    icon: const Icon(Icons.add_circle, size: 36),
                    label: const Text('Ajouter'),
                    position: 'center',
                  ),
                ),
                // Positioned(
                //   bottom: halfDrawerSize / 2 - 26,
                //   right: halfDrawerSize / 2 + 10,
                //   child: MenuButton(
                //     onPressed: () {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) {
                //             return const SearchScreen();
                //           },
                //         ),
                //       );
                //     },
                //     icon: const Icon(Icons.clear, size: 36),
                //     label: const Text('Vider'),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
