import 'package:flutter/material.dart';
import '../widgets/calculator_button.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _output = "0";

  void _buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "=") {
        // Avaliar a expressão
        try {
          _output = _evaluateExpression(_output);
        } catch (e) {
          _output = "Erro";
        }
      } else if (buttonText == "C") {
        _output = "0"; // Limpa a tela
      } else {
        if (_output == "0") {
          _output = buttonText; // Adiciona o primeiro dígito
        } else {
          _output += buttonText; // Continua a expressão
        }
      }
    });
  }

  String _evaluateExpression(String expression) {
    try {
      // Parse a expressão fornecida
      Parser p = Parser();
      Expression exp = p.parse(expression);

      // Cria um modelo de contexto (para variáveis, se necessário)
      ContextModel cm = ContextModel();

      // Avalia a expressão e retorna o valor
      double eval = exp.evaluate(EvaluationType.REAL, cm);

      return eval.toString();
    } catch (e) {
      return "Erro";
    }
  }

  Color _getButtonColor(String text) {
    if (text == "=") return Colors.green; // Resultado
    if (text == "C") return Colors.red; // Limpar
    if ("/*-+".contains(text)) return Colors.orange; // Operadores
    return Colors.blue; // Números
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueGrey, Colors.black],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Tela de exibição
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  _output,
                  style: const TextStyle(
                    fontSize: 48.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            // Grade de botões
            GridView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemCount: 16,
              itemBuilder: (context, index) {
                List<String> buttons = [
                  '7', '8', '9', '/',
                  '4', '5', '6', '*',
                  '1', '2', '3', '-',
                  'C', '0', '=', '+'
                ];
                String buttonText = buttons[index];

                return CalculatorButton(
                  buttonText: buttonText,
                  buttonColor: _getButtonColor(buttonText),
                  onPressed: () => _buttonPressed(buttonText),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
