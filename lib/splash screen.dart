import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:scientificcal/Savingscalculator/savingscal.dart';
import 'package:scientificcal/Tip%20Calculator/tipcalculator.dart';
import 'package:scientificcal/UnitConverter/unitconverter.dart';
import 'package:scientificcal/hexadecimalcalculator/hexadecimalcal.dart';
import 'package:scientificcal/loanCalculator/loancalculator.dart';
import 'package:scientificcal/ovulution%20calculator/ovulution%20calculator.dart';
import 'package:scientificcal/percentage%20calculator/percentagecalculator.dart';
import 'package:scientificcal/unitpricecalculator/unitprice.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'BMICalculator/bmi calculator.dart';
import 'DateCalculator/datecalculator.dart';
import 'DiscountCalculator/discountcalculator.dart';
import 'Fuelefficiencycalculator/fuelefficiency.dart';

import 'Usage tips/help.dart';
import 'ValueAddedTaxCalculator/VAT calculator.dart';
import 'basiccalculator/scientificcalculator.dart';
import 'buttons.dart';
import 'fuelcostcalculator/fuelcostcalculator.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({Key? key}) : super(key: key);

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  bool _isFirstLaunch = true;

  @override
  void initState() {
    _checkAppState().then((value) {
      setState(() {
        _isFirstLaunch = value;
      });
    });

    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return SafeArea(
            child: Scaffold(
              drawer: MyDrawer(),
              body: ScientificCalculator(),
            ));
      }));
    });
    super.initState();
  }
  Future<bool> _checkAppState() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

    if (isFirstLaunch) {
      // First launch, set the flag and show splash screen
      await prefs.setBool('isFirstLaunch', false);
      return true;
    }

    // Get the last opened screen index from shared preferences
    final lastScreenIndex = prefs.getInt('lastScreenIndex') ?? 0;

    // Open the last screen that was open when the app was closed
    switch (lastScreenIndex) {
      case 1:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => UnitConverter()),
        );
        break;
      case 2:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => DiscountCalculator()),
        );
        break;
      case 3:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => TipCalculator()),
        );
        break;
      case 4:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => DateCalculator()),
        );
        break;
      case 5:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => FuelCostCalculator()),
        );
        break;
      case 6:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => FuelEfficencyCalculator()),
        );
        break;
      case 7:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => BMICalculator()),
        );
        break;
      case 8:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HexCalculator()),
        );
        break;
      case 9:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoanCalculator()),
        );
        break;
      case 10:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => OvulationCalculator()),
        );
        break;
      case 11:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => PercentageCalculator()),
        );
        break;
      case 12:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => SavingsCalculator()),
        );
        break;
      case 13:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => UnitPrice()),
        );
        break;
      case 14:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => VatCalculator()),
        );
        break;
      case 15:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => Help()),
        );
        break;
      case 16:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => ScientificCalculator()),
        );
        break;

      default:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => ScientificCalculator()),
        );
        break;
    }

    return false;
  }




  @override
  Widget build(BuildContext context) {
    if (_isFirstLaunch) {
      // Show splash screen
      return Container(
        color: Colors.indigo,
        // Load a Lottie file from your assets
        child: Lottie.asset('assets/loading-screen.json'),
      );
    }

    // Otherwise, return an empty container to prevent the splash screen from showing
    return Container();
  }
}