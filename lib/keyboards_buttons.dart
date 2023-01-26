import 'constants.dart';
import 'package:flutter/material.dart';

typedef void CallbackButtonTap({String buttonText});

class KeyboardButtons extends StatelessWidget {
  KeyboardButtons({required this.buttons,  this.onTap});

  final String buttons;
  final CallbackButtonTap? onTap;

  bool _colorTextButtons() {
    return (buttons == DEL_SIGN ||
        buttons == DECIMAL_POINT_SIGN ||
        buttons == CLEAR_ALL_SIGN ||
        buttons == MODULAR_SIGN ||
        buttons == PLUS_SIGN ||
        buttons == MINUS_SIGN ||
        buttons == MULTIPLICATION_SIGN ||
        buttons == DIVISION_SIGN ||
        buttons == EXCHANGE_CALCULATOR ||
        buttons == PI ||
        buttons == SQUARE_ROOT_SIGN ||
        buttons == POWER_SIGN ||
        buttons == LN_SIGN ||
        buttons == LG_SIGN ||
        buttons == SIN_SIGN ||
        buttons == COS_SIGN ||
        buttons == TAN_SIGN ||
        buttons == RAD_SIGN ||
        buttons == DEG_SIGN ||
        buttons == ARCSIN_SIGN ||
        buttons == ARCCOS_SIGN ||
        buttons == ARCTAN_SIGN ||
        buttons == LN2_SIGN ||
        buttons == E_NUM ||
        buttons == LEFT_QUOTE_SIGN ||
        buttons == RIGHT_QUOTE_SIGN ||
        buttons == SINH_SIGN ||
        buttons == COSH_SIGN ||
        buttons == TANH_SIGN ||
        buttons == ARCSINH_SIGN ||
        buttons == ARCCOSH_SIGN ||
        buttons == ARCTANH_SIGN ||
        buttons == CUBE_ROOT_SIGN ||
        buttons ==  Phi ||
        buttons == AbSOLUTE_VALUE ||
        buttons == ZERO_ZERO
    );
  }

  bool _fontSize(){
    return (
        buttons == LN_SIGN ||
            buttons == LG_SIGN ||
            buttons == SIN_SIGN ||
            buttons == COS_SIGN ||
            buttons == TAN_SIGN ||
            buttons == RAD_SIGN ||
            buttons == DEG_SIGN ||
            buttons == ARCSIN_SIGN ||
            buttons == ARCCOS_SIGN ||
            buttons == ARCTAN_SIGN ||
            buttons == LN2_SIGN ||
            buttons == LEFT_QUOTE_SIGN ||
            buttons == RIGHT_QUOTE_SIGN ||
            buttons == SINH_SIGN ||
            buttons == COSH_SIGN ||
            buttons == TANH_SIGN ||
            buttons == ARCSINH_SIGN ||
            buttons == ARCCOSH_SIGN ||
            buttons == ARCTANH_SIGN
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: (buttons == EQUAL_SIGN)
                ? Theme.of(context).primaryColorDark
                : Color(0xFFFFFFFF),
            padding: EdgeInsets.all(16),
          ),
          child: Text(
            buttons,
            style: TextStyle(
                color: (_colorTextButtons())
                    ? Colors.blueAccent
                    : (buttons == EQUAL_SIGN)
                    ? Theme.of(context).buttonColor
                    : Color(0xFF444444),
                fontSize: _fontSize() ? 14 : 20.0),
          ),
          onPressed: () => onTap!(buttonText: buttons),
        ),
      ),
    );
  }
}
