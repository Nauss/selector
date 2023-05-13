import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddButtons extends StatelessWidget {
  final Function(BuildContext) onFinish;
  final Function(BuildContext) onAdd;
  const AddButtons({Key? key, required this.onFinish, required this.onAdd})
      : super(key: key);

  void add(BuildContext context) {
    debugPrint('add');
    onAdd(context);
  }

  void finish(BuildContext context) {
    debugPrint('finish');
    onFinish(context);
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          locale.addMore,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 8),
                child: ElevatedButton(
                  onPressed: () {
                    add(context);
                  },
                  child: Text(
                    locale.add,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 16),
                child: ElevatedButton(
                  onPressed: () {
                    finish(context);
                  },
                  child: Text(
                    locale.finish,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
