
const PLUS_SIGN = '+';
const MINUS_SIGN = '-';
const MULTIPLICATION_SIGN = '×';
const DIVISION_SIGN = '÷';
const DECIMAL_POINT_SIGN = '.';
const POWER_SIGN = 'X^';
const SQUARE_ROOT_SIGN = '√';
const CUBE_ROOT_SIGN = '∛';
const Phi = 'φ';
const AbSOLUTE_VALUE = '|X|';
const LG_SIGN = 'log';
const LN_SIGN = 'ln';
const LN2_SIGN = 'ln2';
const MODULAR_SIGN = '%';
const SIN_SIGN = 'sin';
const COS_SIGN = 'cos';
const TAN_SIGN = 'tan';
const SINH_SIGN = 'sinh';
const COSH_SIGN = 'cosh';
const TANH_SIGN = 'tanh';
const RAD_SIGN = 'rad';
const DEG_SIGN = 'deg';
const ARCSIN_SIGN = 'asin';
const ARCCOS_SIGN = 'acos';
const ARCTAN_SIGN = 'atan';
const ARCSINH_SIGN = 'asinh';
const ARCCOSH_SIGN = 'acosh';
const ARCTANH_SIGN = 'atanh';
const LEFT_QUOTE_SIGN = '(';
const RIGHT_QUOTE_SIGN = ')';
const EQUAL_SIGN = '=';
const CLEAR_ALL_SIGN = 'C';
const PI = 'π';
const E_NUM = 'e';
const DEL_SIGN = '⌫';
const CALCULATE_ERROR = 'Error';
const EXCHANGE_CALCULATOR = '⌞⌝';
const ONE = '1';
const TWO = '2';
const THREE = '3';
const FOR = '4';
const FIVE = '5';
const SIX = '6';
const SEVEN = '7';
const EIGHT = '8';
const NINE = '9';
const ZERO = '0';
const ZERO_ZERO = '00';

const keyboardSingleCalculator = [
  [CLEAR_ALL_SIGN, DEL_SIGN, MODULAR_SIGN, DIVISION_SIGN],
  [SEVEN, EIGHT, NINE, MULTIPLICATION_SIGN],
  [FOR, FIVE, SIX, MINUS_SIGN],
  [ONE, TWO, THREE, PLUS_SIGN],
  [EXCHANGE_CALCULATOR, ZERO, DECIMAL_POINT_SIGN, EQUAL_SIGN]
];

const keyboardScientificCalculator = [
  [ARCTANH_SIGN, CUBE_ROOT_SIGN, Phi, AbSOLUTE_VALUE, E_NUM],
  [SINH_SIGN, COSH_SIGN, TANH_SIGN, ARCSINH_SIGN, ARCCOSH_SIGN],
  [LG_SIGN, LN_SIGN, ARCSIN_SIGN, ARCCOS_SIGN, ARCTAN_SIGN],
  [LEFT_QUOTE_SIGN, RIGHT_QUOTE_SIGN, SIN_SIGN, COS_SIGN, TAN_SIGN],
  [LN2_SIGN, CLEAR_ALL_SIGN, DEL_SIGN, MODULAR_SIGN, DIVISION_SIGN],
  [POWER_SIGN, SEVEN, EIGHT, NINE, MULTIPLICATION_SIGN],
  [SQUARE_ROOT_SIGN, FOR, FIVE, SIX, MINUS_SIGN],
  [PI, ONE, TWO, THREE, PLUS_SIGN],
  [EXCHANGE_CALCULATOR, ZERO_ZERO, ZERO, DECIMAL_POINT_SIGN, EQUAL_SIGN]

];
