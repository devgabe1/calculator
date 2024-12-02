import 'package:flutter/material.dart';

class CalculatorButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  final int widthFactor; // Novo parâmetro para controlar a largura

  const CalculatorButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
    this.widthFactor = 1, // Largura padrão de 1
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widthFactor == 2 ? 160 : 80, // Ajusta a largura do botão
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(20),
        ),
        child: Text(
          buttonText,
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
