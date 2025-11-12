import 'package:flutter/material.dart';

class IconWithLabelButton extends StatelessWidget {
  const IconWithLabelButton({
    super.key,
    required this.icon,
    required this.size,
    this.label = '',
    this.onPressed,
  });

  final IconData icon;
  final double size;
  final String label;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          Icon(icon, size: size),
          Text(label),
        ],
      ),
    );
  }
}
