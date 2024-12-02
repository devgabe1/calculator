// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _output = "0";
  String _currentOperator =
      ""; // Variável para armazenar a operação selecionada
  String _previousValue = ""; // Armazena o valor anterior

  void _buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "=") {
        try {
          _output =
              _evaluateExpression("$_previousValue$_currentOperator$_output");
          _currentOperator = ""; // Limpa o operador após o cálculo
          _previousValue = ""; // Limpa o valor anterior após o cálculo
        } catch (e) {
          _output = "Erro";
        }
      } else if (buttonText == "+/-") {
        if (_output != "0") {
          if (_output.startsWith("-")) {
            _output = _output.substring(1); // Remove o sinal de negativo
          } else {
            _output = "-$_output"; // Adiciona o sinal de negativo
          }
        }
      } else if (buttonText == "%") {
        try {
          double value = double.parse(_output.replaceAll(',', '.')) / 100;
          _output = value.toString().replaceAll('.', ',');
        } catch (e) {
          _output = "Erro";
        }
      } else if (buttonText == "AC") {
        _output = "0"; // Reseta a tela
        _currentOperator = ""; // Limpa o operador selecionado
        _previousValue = ""; // Limpa o valor anterior
      } else if (buttonText == "C") {
        _output =
            _output.length > 1 ? _output.substring(0, _output.length - 1) : "0";
      } else if (buttonText == "+" ||
          buttonText == "-" ||
          buttonText == "×" ||
          buttonText == "÷") {
        // Se for um operador, realiza o cálculo com o valor anterior, se já houver valor armazenado
        if (_previousValue.isNotEmpty) {
          _output =
              _evaluateExpression("$_previousValue$_currentOperator$_output");
        } else {
          _previousValue =
              _output; // Armazena o valor atual antes de pressionar o operador
          _output = "0"; // Limpa a tela para o próximo número
        }
        _currentOperator = buttonText; // Armazena o operador selecionado
      } else {
        if (_output == "0") {
          _output = buttonText; // Substitui o "0" inicial
        } else {
          _output += buttonText; // Adiciona o botão pressionado
        }
      }
    });
  }

  String _evaluateExpression(String expression) {
    try {
      expression = expression.replaceAll('×', '*').replaceAll('÷', '/');
      Parser p = Parser();
      Expression exp = p.parse(expression);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);

      // Retorna o resultado como inteiro ou decimal
      return eval == eval.toInt() ? eval.toInt().toString() : eval.toString();
    } catch (e) {
      return "Erro";
    }
  }

  Color _getButtonColor(String buttonText) {
    if (buttonText == _currentOperator) {
      return Colors.white;
    } else if (buttonText == '=' ||
        buttonText == '+' ||
        buttonText == '-' ||
        buttonText == '×' ||
        buttonText == '÷') {
      return Colors.orange; // Cor laranja para os operadores
    } else if (buttonText == 'AC' || buttonText == '+/-' || buttonText == '%') {
      return const Color.fromARGB(255, 165, 165, 165);
    } else {
      return Colors.grey[800]!; // Cor cinza escura para os outros botões
    }
  }

  // Função para determinar a cor do texto do botão
  Color _getTextColor(String buttonText) {
    if (buttonText == _currentOperator) {
      return Colors.orange;
    } else if (buttonText == 'AC' || buttonText == '+/-' || buttonText == '%') {
      return Colors.black; // Cor preta para AC, +/- e %
    } else {
      return Colors.white; // Cor branca para os outros botões
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
                'AC',
                '+/-',
                '%',
                '÷',
                '7',
                '8',
                '9',
                '×',
                '4',
                '5',
                '6',
                '-',
                '1',
                '2',
                '3',
                '+',
                '0',
                ',',
                '=',
              ];

              String buttonText = buttons[index];

              // Verifica se é o botão "0" para ajustar o tamanho
              if (buttonText == '0') {
                return Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _getButtonColor(buttonText),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: TextButton(
                    onPressed: () => _buttonPressed(buttonText),
                    child: Text(
                      buttonText,
                      style: TextStyle(
                        fontSize: 30,
                        color: _getTextColor(buttonText),
                      ),
                    ),
                  ),
                );
              }

              // Botão padrão
              return Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _getButtonColor(buttonText),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: TextButton(
                  onPressed: () => _buttonPressed(buttonText),
                  child: Text(
                    buttonText,
                    style: TextStyle(
                      fontSize: 40,
                      color: _getTextColor(buttonText),
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
