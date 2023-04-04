

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:math_expressions/math_expressions.dart';
import '../admob/admob_testingids.dart';
import '../buttons.dart';
import 'constants.dart';
import 'keyboards.dart';

String firstOperand = '0';
String secondOperand = '';
String operators = '';
String equation = '0';
String result = '';




class ScientificCalculator extends StatefulWidget {
  @override
  _ScientificCalculatorState createState() => _ScientificCalculatorState();
}

class _ScientificCalculatorState extends State<ScientificCalculator> {
  bool scientificKeyboard = false;
  late BannerAd _bannerAd;
  bool isBannerAdLoaded = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  initBannerAd() {
    _bannerAd = BannerAd(size: AdSize.banner,
      adUnitId: AdmobManager.banner_id,
      request: AdRequest(),
      listener: BannerAdListener(onAdLoaded: (Ad ad) {
        setState(() {
          isBannerAdLoaded = true;
        });
      },
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            ad.dispose();
            print("HelloAds Ad failed to load : $error");
          },
          onAdOpened: (Ad ad) {
            return print("HelloAds Ad opened");
          }
      ),
    );
    _bannerAd.load();
  }
  @override
  void initState()  {
    super.initState();
    initBannerAd();
    initialise();
  }

  @override
  void disposeState(){
    super.dispose();
    _bannerAd.dispose();
  }


 /* @override
  void initState() {
    super.initState();
    initialise();
  }*/

  String expression = '';
  double equationFontSize = 35.0;
  double resultFontSize = 25.0;

  void initialise() {}


  void _onPressed({ String? buttonText}) {
    switch (buttonText) {
      case EXCHANGE_CALCULATOR:
        setState(() {
          scientificKeyboard = !scientificKeyboard;
          _clear();
        });
        break;
      case CLEAR_ALL_SIGN:
        setState(() {
          _clear();
        });
        break;
      case DEL_SIGN:
        setState(() {
          if (scientificKeyboard) {
            equationFontSize = 35.0;
            resultFontSize = 25.0;
            equation = equation.substring(0, equation.length - 1);
            if (equation == '') equation = '0';
          } else {
            equationFontSize = 35.0;
            resultFontSize = 25.0;
            if (operators == '') {
              firstOperand = firstOperand.substring(0, firstOperand.length - 1);
              if (firstOperand == '') firstOperand = '0';
            } else {
              secondOperand =
                  secondOperand.substring(0, secondOperand.length - 1);
              if (secondOperand == '') secondOperand = '';
            }
          }
        });
        break;
      case EQUAL_SIGN:
        if (result == '') {
          scientificKeyboard ? _scientificResult() : _simpleResult();
        }
        break;
      default:
        scientificKeyboard
            ? _scientificOperands(buttonText)
            : _simpleOperands(buttonText);
    }
  }

  void _clear() {
    firstOperand = '0';
    secondOperand = '';
    operators = '';
    equation = '0';
    result = '';
    expression = '';
    equationFontSize = 35.0;
    resultFontSize = 25.0;
  }

  void _simpleOperands(value) {
    setState(() {
      equationFontSize = 35.0;
      resultFontSize = 25.0;
      switch (value) {
        case MODULAR_SIGN:
          if (result != '') {
            firstOperand = (double.parse(result) / 100).toString();
          } else if (operators != '') {
            if (secondOperand != "") {
              if (operators == PLUS_SIGN || operators == MINUS_SIGN) {
                secondOperand = ((double.parse(firstOperand) / 100) *
                    double.parse(secondOperand))
                    .toString();
              } else if (operators == MULTIPLICATION_SIGN ||
                  operators == DIVISION_SIGN) {
                secondOperand = (double.parse(secondOperand) / 100).toString();
              }
            }
          } else {
            if (firstOperand != "") {
              firstOperand = (double.parse(firstOperand) / 100).toString();
            }
          }
          if (firstOperand.toString().endsWith(".0")) {
            firstOperand =
                int.parse(firstOperand.toString().replaceAll(".0", ""))
                    .toString();
          }
          if (secondOperand.toString().endsWith(".0")) {
            secondOperand =
                int.parse(secondOperand.toString().replaceAll(".0", ""))
                    .toString();
          }
          break;
        case DECIMAL_POINT_SIGN:
          if (result != '') _clear();
          if (operators != '') {
            if (!secondOperand.toString().contains(".")) {
              if (secondOperand == "") {
                secondOperand = ".";
              } else {
                secondOperand += ".";
              }
            }
          } else {
            if (!firstOperand.toString().contains(".")) {
              if (firstOperand == "") {
                firstOperand = ".";
              } else {
                firstOperand += ".";
              }
            }
          }
          break;
        case PLUS_SIGN:
        case MINUS_SIGN:
        case MULTIPLICATION_SIGN:
        case DIVISION_SIGN:
          if (firstOperand == '0') {
            if (value == MINUS_SIGN) firstOperand = MINUS_SIGN;
          } else if (secondOperand == '') {
            operators = value;
          } else {
            _simpleResult();
            firstOperand = result;
            operators = value;
            secondOperand = '';
            result = '';
          }
          break;
        default:
          if (operators != '') {
            secondOperand += value;
          } else {
            firstOperand == ZERO ? firstOperand = value : firstOperand += value;
          }
      }
    });
  }

  void _simpleResult() {
    setState(() {
      equationFontSize = 25.0;
      resultFontSize = 35.0;
      expression = firstOperand + operators + secondOperand ;
      expression = expression.replaceAll('×', '*');
      expression = expression.replaceAll('÷', '/');

      try {
        Parser p = Parser();
        Expression exp = p.parse(expression);
        ContextModel cm = ContextModel();
        double eval = exp.evaluate(EvaluationType.REAL, cm);
        result = eval.toString();

        if (result == 'NaN') result = CALCULATE_ERROR;
        _isIntResult();
      } catch (e) {
        result = CALCULATE_ERROR;
      }
    });
  }

  void _scientificOperands(value) {
    setState(() {
      equationFontSize = 35.0;
      resultFontSize = 25.0;
      if (value == POWER_SIGN) value = '^';
      if (value == MODULAR_SIGN) value = '%';
      if (value == ARCSIN_SIGN) value = 'arcsin';
      if (value == ARCCOS_SIGN) value = 'arccos';
      if (value == ARCTAN_SIGN) value = 'arctan';
      if (value == DECIMAL_POINT_SIGN) {
        if (equation[equation.length - 1] == DECIMAL_POINT_SIGN) return;
      }

      equation == ZERO ? equation = value : equation += value;
    });
  }

  void _scientificResult() {
    setState(() {
      equationFontSize = 25.0;
      resultFontSize = 35.0;
      expression = equation;
      expression = expression.replaceAll('×', '*');
      expression = expression.replaceAll('÷', '/');
      expression = expression.replaceAll(PI, '3.1415926535897932');
      expression = expression.replaceAll(E_NUM, 'e^1');
      expression = expression.replaceAll(SQUARE_ROOT_SIGN, 'sqrt');
      expression = expression.replaceAll(POWER_SIGN, '^');
      expression = expression.replaceAll(ARCSIN_SIGN, 'arcsin');
      expression = expression.replaceAll(ARCCOS_SIGN, 'arccos');
      expression = expression.replaceAll(ARCTAN_SIGN, 'arctan');
      expression = expression.replaceAll(MODULAR_SIGN , '%');


      try {
        Parser p = Parser();
        Expression exp = p.parse(expression);
        ContextModel cm = ContextModel();
        result = '${exp.evaluate(EvaluationType.REAL, cm)}';
        if (result == 'NaN') result = CALCULATE_ERROR;
        _isIntResult();
      } catch (e) {
        result = CALCULATE_ERROR;
      }
    });
  }

  _isIntResult() {
    if (result.toString().endsWith(".0")) {
      result = int.parse(result.toString().replaceAll(".0", "")).toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          drawer: MyDrawer(),
          appBar: AppBar(
            title: Text('Basic Calculator'),
            centerTitle: true,
            elevation: 0.0,
          ),
          bottomNavigationBar: isBannerAdLoaded ?
          Container(
            padding: EdgeInsets.symmetric(vertical: 5),
            width: _bannerAd.size.width.toDouble(),
            height: _bannerAd.size.height.toDouble(),
            child: AdWidget(ad: _bannerAd ),


          ):SizedBox(),
          body:  WillPopScope(
            onWillPop: () async {
              if (_scaffoldKey.currentState!.isDrawerOpen) {
                // if drawer is open, close it and consume the back button
                _scaffoldKey.currentState!.openEndDrawer();
                return false;
              } else {
                // if drawer is not open, allow the back button to close the app
                return await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                  title: Text('Confirm Exit'),
                  content: Text('Are you sure you want to exit?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text('No'),
                    ),
                    TextButton(
                      onPressed: () =>  exit(0),
                      /* exit(0) will close the app */
                      child: Text('Yes'),
                    ),
                  ],
                )
                );
              }
            },
            child: Container(
              child: Column(
                children: [
                  // Load a Lottie file from your assets
                //  Lottie.asset('assets/liquid.json'),
                  Expanded(child: Container()),
                  Container(
                    color: Colors.black12,
                    alignment: Alignment.topRight,
                    padding: EdgeInsets.only(left: 20.0, right: 20.0),
                    child: SingleChildScrollView(
                      child: !scientificKeyboard
                          ? Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _inOutExpression(firstOperand, equationFontSize),
                          operators != ''
                              ? _inOutExpression(operators, equationFontSize)
                              : Container(),
                          secondOperand != ''
                              ? _inOutExpression(secondOperand, equationFontSize)
                              : Container(),
                          result != ''
                              ? _inOutExpression(result, resultFontSize)
                              : Container(),
                        ],
                      )
                          : Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          _inOutExpression(equation, equationFontSize),
                          result != ''
                              ? _inOutExpression(result, resultFontSize)
                              : Container(),
                        ],
                      ),
                    ),
                  ),
                  Keyboard(
                    keyboardSigns: (scientificKeyboard)
                        ? keyboardScientificCalculator
                        : keyboardSingleCalculator,
                    onTap: _onPressed,
                  ),
                ],
              ),
            ),
          ),
        ),

    );
  }

  Widget _inOutExpression(text, size) {
    return SingleChildScrollView(
      reverse: true,
      scrollDirection: Axis.horizontal,
      child: Text(
        text is double ? text.toStringAsFixed(2) : text.toString(),
        style: TextStyle(
          color: Color(0xFF444444),
          fontSize: size,
        ),
        textAlign: TextAlign.end,
      ),
    );
  }
}
