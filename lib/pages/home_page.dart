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

  final List<String> buttons =
  [
    "C", "DEL", "%", "/",
    "9", "8", "7", "x",
    "6", "5", "4", "-",
    "3", "2", "1", "+",
    "0", ".", "RES", "="
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

                  SizedBox(height: 50),

                  Container(
                    padding: EdgeInsets.all(20),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      userQuestion,
                      style: TextStyle(
                        fontSize: 20
                      ),
                    )
                  ),

                  Container(
                    padding: EdgeInsets.all(20),
                    alignment: Alignment.centerRight,
                    child: Text(
                      userAnswer,
                      style: TextStyle(
                        fontSize: 20
                      ),
                    )
                  )

                ],
              ),
            )
          ),
          Expanded(
            flex: 2,
            child: Container(
              child: Center(
                child: GridView.builder(
                  itemCount: buttons.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      return Buttons(
                        buttonTapped: () {
                          setState(() {
                            userQuestion = "";
                            userAnswer = "";
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
                            if(userQuestion.isNotEmpty) {
                              userQuestion = userQuestion.substring(0, userQuestion.length - 1);
                              if(userQuestion.length > 0) {
                                preResult();
                              } else {
                                userAnswer = "";
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
                    } else {
                      return Buttons(
                        buttonTapped: () {
                          setState(() {
                            userQuestion += buttons[index];
                            isOperator(buttons[index]) ? false : preResult();
                          });
                        },
                        buttonText: buttons[index],
                        color: isOperator(buttons[index]) ? Colors.deepPurple : Colors.deepPurple[50],
                        textColor: isOperator(buttons[index]) ? Colors.white : Colors.deepPurple,
                      );
                    }
                  }
                )
              ),
            )
          )
        ],
      ),
    );
  }

  bool isOperator(String x) {
    if((x == "%") || (x == "/") || (x == "x") || (x == "-") || (x == "+") || (x == "=")) {
      return true;
    } else {
      return false;
    }
  }

  void preResult() {
    String finalQuestion = userQuestion;
    finalQuestion = finalQuestion.replaceAll("x", "*");
    if (isOperator(finalQuestion[finalQuestion.length - 1])) {
      finalQuestion = finalQuestion.substring(0, finalQuestion.length - 1);
    }

    Parser p = Parser();
    Expression exp = p.parse(finalQuestion);
    ContextModel cm = ContextModel();
    double eval = exp.evaluate(EvaluationType.REAL, cm);

    userAnswer = eval.toString();
  }

  void equalPressed() {

    userQuestion = userAnswer.toString();
    userAnswer = "";
  }
}
