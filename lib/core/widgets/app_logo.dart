import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double iconSize;
  final double fontSize;

  const AppLogo({super.key, this.iconSize = 26.0, this.fontSize = 20.0});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color:  primaryColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.shopping_bag_rounded,
            color: primaryColor,
            size: iconSize,
          ),
        ),
        const SizedBox(width: 10),
       
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
            children: [
              const TextSpan(text: 'E comerce'),
              TextSpan(
                text: 'Store',
                style: TextStyle(color: primaryColor),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
