import 'package:calculadora/util/buttons.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var userQuestion = "";
  var userAnswer = "";
  var parentesesFechados = true;

  final List<String> buttons = [
    "C",
    "DEL",
    "%",
    "/",
    "9",
    "8",
    "7",
    "x",
    "6",
    "5",
    "4",
    "-",
    "3",
    "2",
    "1",
    "+",
    "0",
    ".",
    "()",
    "=",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[100],
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(height: 5),

                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.deepPurpleAccent.shade100,
                    ),
                    padding: EdgeInsets.all(20),
                    alignment: Alignment.centerLeft,
                    child: Text(userQuestion, style: TextStyle(fontSize: 20)),
                  ),

                  SizedBox(height: 10),

                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.deepPurpleAccent.shade100,
                    ),
                    padding: EdgeInsets.all(20),
                    alignment: Alignment.centerRight,
                    child: Text(userAnswer, style: TextStyle(fontSize: 20)),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              child: Center(
                child: GridView.builder(
                  itemCount: buttons.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      return Buttons(
                        buttonTapped: () {
                          setState(() {
                            userQuestion = "";
                            userAnswer = "";
                            parentesesFechados = true;
                          });
                        },
                        buttonText: buttons[index],
                        color: Colors.green,
                        textColor: Colors.white,
                      );
                    } else if (index == 1) {
                      return Buttons(
                        buttonTapped: () {
                          setState(() {
                            if (userQuestion.isNotEmpty) {
                              userQuestion = userQuestion.substring(
                                0,
                                userQuestion.length - 1,
                              );
                              if (userQuestion.isNotEmpty) {
                                preResult();
                              } else {
                                userAnswer = "";
                                parentesesFechados = true;
                              }
                            }
                          });
                        },
                        buttonText: buttons[index],
                        color: Colors.red,
                        textColor: Colors.white,
                      );
                    } else if (index == buttons.length - 1) {
                      return Buttons(
                        buttonTapped: () {
                          setState(() {
                            equalPressed();
                          });
                        },
                        buttonText: buttons[index],
                        color: Colors.deepPurple,
                        textColor: Colors.white,
                      );
                    } else if (index == buttons.length - 2) {
                      return Buttons(
                        buttonTapped: () {
                          setState(() {
                            if (parentesesFechados) {
                              userQuestion += "(";
                              parentesesFechados = false;
                            } else {
                              if (userQuestion[userQuestion.length - 1] ==
                                  "(") {
                                userQuestion += "(";
                              } else {
                                userQuestion += ")";
                                if (contarOcorrencias(userQuestion, "(") ==
                                    contarOcorrencias(userQuestion, ")")) {
                                  parentesesFechados = true;
                                }
                              }
                            }
                          });
                        },
                        buttonText: buttons[index],
                        color: Colors.deepPurple,
                        textColor: Colors.white,
                      );
                    } else {
                      return Buttons(
                        buttonTapped: () {
                          setState(() {
                            userQuestion += buttons[index];
                            if (userQuestion.length == 1) {
                              if (isOperator(buttons[index]) &&
                                  buttons[index] != "-") {
                                userQuestion = "";
                              } else {
                                if (userQuestion != "-" &&
                                    userQuestion != ".") {
                                  preResult();
                                }
                              }
                            }
                            if (userQuestion.length > 1) {
                              if (!isOperator(
                                userQuestion[userQuestion.length - 2],
                              )) {
                                if (buttons[index] == ".") {
                                  if (userQuestion[userQuestion.length - 2] ==
                                      ".") {
                                    userQuestion = userQuestion.substring(
                                      0,
                                      userQuestion.length - 1,
                                    );
                                  } else {
                                    // Operadores que separam os números
                                    final operadores = [
                                      '+',
                                      '-',
                                      'x',
                                      '/',
                                      '%',
                                    ];

                                    // Encontra o índice do último operador
                                    int ultimoOperadorIndex = -1;
                                    for (var op in operadores) {
                                      int i = userQuestion.lastIndexOf(op);
                                      if (i > ultimoOperadorIndex) {
                                        ultimoOperadorIndex = i;
                                      }
                                    }

                                    // Pega a parte do número atual (depois do último operador)
                                    String parteAtual = userQuestion.substring(
                                      ultimoOperadorIndex + 1,
                                      userQuestion.length - 1,
                                    );

                                    print(parteAtual);

                                    // Se já tiver um ponto nessa parte, cancela o ponto digitado agora
                                    if (parteAtual.contains(".") &&
                                        parteAtual[parteAtual.length - 1] !=
                                            ".") {
                                      userQuestion = userQuestion.substring(
                                        0,
                                        userQuestion.length - 1,
                                      );
                                    }
                                  }
                                } else {
                                  preResult();
                                }
                              } else {
                                if (isOperator(buttons[index])) {
                                  if (userQuestion.length == 2) {
                                    userQuestion = "-";
                                  } else if ((userQuestion[userQuestion.length -
                                                  2] ==
                                              "x" ||
                                          userQuestion[userQuestion.length -
                                                  2] ==
                                              "/" ||
                                          userQuestion[userQuestion.length -
                                                  2] ==
                                              "%") &&
                                      buttons[index] == "-") {
                                    userQuestion = userQuestion;
                                  } else if (!isOperator(
                                    userQuestion[userQuestion.length - 3],
                                  )) {
                                    userQuestion =
                                        userQuestion.substring(
                                          0,
                                          userQuestion.length - 2,
                                        ) +
                                        buttons[index];
                                  } else {
                                    userQuestion = userQuestion.substring(
                                      0,
                                      userQuestion.length - 1,
                                    );
                                  }
                                } else {
                                  preResult();
                                }
                              }
                            }
                          });
                        },
                        buttonText: buttons[index],
                        color:
                            isOperator(buttons[index])
                                ? Colors.deepPurple
                                : Colors.deepPurple[50],
                        textColor:
                            isOperator(buttons[index])
                                ? Colors.white
                                : Colors.deepPurple,
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool isOperator(String x) {
    if ((x == "%") ||
        (x == "/") ||
        (x == "x") ||
        (x == "-") ||
        (x == "+") ||
        (x == "=") ||
        (x == "()")) {
      return true;
    } else {
      return false;
    }
  }

  void preResult() {
    try {
      String finalQuestion = userQuestion;

      while (finalQuestion.isNotEmpty &&
          isOperator(finalQuestion[finalQuestion.length - 1])) {
        finalQuestion = finalQuestion.substring(0, finalQuestion.length - 1);
      }

      finalQuestion = finalQuestion.replaceAll("x", "*");

      Parser p = Parser();
      Expression exp = p.parse(finalQuestion);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);

      userAnswer = formatDouble(eval);
    } catch (e) {
      // Erro na Operação
    }
  }

  void equalPressed() {
    if (userAnswer.isNotEmpty) {
      userQuestion = formatDouble(double.parse(userAnswer));
      userAnswer = "";
    }
  }

  String formatDouble(double valor) {
    if (valor == valor.toInt()) {
      return valor.toInt().toString();
    } else {
      return valor.toString();
    }
  }

  int contarOcorrencias(String texto, String caractere) {
    return RegExp(RegExp.escape(caractere)).allMatches(texto).length;
  }
}
