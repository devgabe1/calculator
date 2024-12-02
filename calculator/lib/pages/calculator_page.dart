import 'package:flutter/material.dart';
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
      try {
        _output = _evaluateExpression(_output);
      } catch (e) {
        _output = "Erro";
      }
    } else if (buttonText == "+/-") {
      if (_output != "0") {
        if (_output.startsWith("-")) {
          _output = _output.substring(1);
        } else {
          _output = "-$_output";
        }
      }
    } else if (buttonText == "%") {
      // Calcula o valor percentual
      try {
        double value = double.parse(_output.replaceAll(',', '.')) / 100;
        _output = value.toString().replaceAll('.', ',');
      } catch (e) {
        _output = "Erro";
      }
    } else if (buttonText == "AC") {
      _output = "0";
    } else if (buttonText == "C") {
      _output = _output.length > 1 ? _output.substring(0, _output.length - 1) : "0";
    } else {
      if (_output == "0") {
        _output = buttonText;
      } else {
        _output += buttonText;
      }
    }
  });
}



String _evaluateExpression(String expression) {
  try {
    // Substituir vírgulas por pontos
    expression = expression.replaceAll(',', '.');
    
    // Substituir "×" por "*" e "÷" por "/"
    expression = expression.replaceAll('×', '*').replaceAll('÷', '/');

    // Parse a expressão fornecida
    Parser p = Parser();
    Expression exp = p.parse(expression);

    // Cria um modelo de contexto (para variáveis, se necessário)
    ContextModel cm = ContextModel();

    // Avalia a expressão
    double eval = exp.evaluate(EvaluationType.REAL, cm);

    // Verifica se o resultado é um inteiro
    if (eval == eval.toInt()) {
      // Retorna como inteiro (sem casas decimais)
      return eval.toInt().toString();
    } else {
      // Retorna como número decimal, com ponto ou vírgula
      return eval.toString().replaceAll('.', ',');
    }
  } catch (e) {
    return "Erro";
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Tela de exibição da calculadora
Padding(
  padding: const EdgeInsets.all(20.0),
  child: Align(
    alignment: Alignment.centerRight, // Alinha o texto à direita
    child: Text(
      _output,
      style: const TextStyle(fontSize: 48.0, color: Colors.white),
    ),
  ),
),

          // Linhas de botões
GridView.builder(
  shrinkWrap: true,
  padding: const EdgeInsets.all(10),
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 4, // 4 colunas no total
    crossAxisSpacing: 10.0,
    mainAxisSpacing: 10.0,
  ),
  itemCount: 19, // Total de botões
  itemBuilder: (context, index) {
    List<String> buttons = [
      'AC', '+/-', '%', '÷',
      '7', '8', '9', '×',
      '4', '5', '6', '-',
      '1', '2', '3', '+',
      '0', ',', '=', // Linha final com botão "0", vírgula e igual
    ];

    String buttonText = buttons[index];

    // Verifica se é o botão "0" para ajustar o tamanho
    if (buttonText == '0') {
      return Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(40),
        ),
        child: TextButton(
          onPressed: () => _buttonPressed(buttonText),
          child: Text(
            buttonText,
            style: TextStyle(
              fontSize: 30,
              color: Colors.white,
            ),
          ),
        ),
        width: MediaQuery.of(context).size.width * 0.4, // Ocupa duas colunas
      );
    }

    // Botão padrão
    return Container(
      alignment: Alignment.center,
decoration: BoxDecoration(
  color: buttonText == '=' || buttonText == '+' || buttonText == '-' ||
          buttonText == '×' || buttonText == '÷'
      ? Colors.orange
      : buttonText == 'AC' || buttonText == '+/-' || buttonText == '%'
          ? Color.fromARGB(255, 165, 165, 165) // Cor RGB(165, 165, 165)
          : Colors.grey[800],
  borderRadius: BorderRadius.circular(40),
),

      child: TextButton(
        onPressed: () => _buttonPressed(buttonText),
        child: Text(
          buttonText,
    style: TextStyle(
      fontSize: 30,
      color: buttonText == 'AC' || buttonText == '+/-' || buttonText == '%'
          ? Colors.black // Cor preta para AC, +/- e %
          : Colors.white, // Cor branca para os outros botões
    ),
  ),
),
    );
  },
),

        ],
      ),
    );
  }
}
