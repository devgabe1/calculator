import 'package:flutter/material.dart';

class CalculatorButton extends StatelessWidget {
  final String buttonText;
  final Color buttonColor;
  final VoidCallback onPressed;

  const CalculatorButton({
    super.key,
    required this.buttonText,
    required this.buttonColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(20),
      ),
      child: Text(
        buttonText,
        style: const TextStyle(
          fontSize: 24,
          color: Colors.white,
        ),
      ),
    );
  }
}
