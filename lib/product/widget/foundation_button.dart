import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

class FoundationButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;

  const FoundationButton(this.buttonText, this.onPressed, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
      width: context.dynamicHeight(0.8),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.surface,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              buttonText,
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.surface,
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
