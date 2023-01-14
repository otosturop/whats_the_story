import 'package:flutter/material.dart';

class SocialLoginButton extends StatelessWidget {
  final String buttonText;
  final Color buttonColor;
  final Color textColor;
  final double buttonRadius;
  final double buttonHeight;
  final Widget buttonIcon;
  final VoidCallback onPressed;

  const SocialLoginButton(
      {super.key,
      required this.buttonText,
      required this.buttonColor,
      this.textColor = Colors.white,
      this.buttonRadius = 16.0,
      this.buttonHeight = 40,
      required this.buttonIcon,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(buttonRadius))),
        backgroundColor: buttonColor,
        foregroundColor: Theme.of(context).colorScheme.surface,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buttonIcon,
          Text(
            buttonText,
            style: TextStyle(color: textColor),
          ),
          Opacity(opacity: 0, child: buttonIcon)
        ],
      ),
    );
  }
}
