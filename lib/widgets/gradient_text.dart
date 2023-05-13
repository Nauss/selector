import 'package:flutter/material.dart';

class GradientText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  const GradientText(this.text, {Key? key, this.style}) : super(key: key);

  @override
  State<GradientText> createState() => _GradientTextState();
}

class _GradientTextState extends State<GradientText>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );
    animation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {});
      });
    controller.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return ShaderMask(
      child: Text(
        widget.text,
        style: widget.style,
      ),
      shaderCallback: (bounds) {
        return LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: [
            animation.value - 0.2,
            animation.value,
            animation.value + 0.2
          ],
          colors: [
            themeData.textTheme.bodyLarge?.color ?? Colors.amber,
            themeData.primaryColor,
            themeData.textTheme.bodyLarge?.color ?? Colors.amber,
          ],
        ).createShader(bounds);
      },
    );
  }

  @override
  void dispose() {
    animation.removeListener(() {
      setState(() {});
    });
    controller.dispose();
    super.dispose();
  }
}
