import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'basiccalculator/scientificcalculator.dart';
import 'buttons.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({Key? key}) : super(key: key);

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
   Timer(Duration(seconds: 3),(){
     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)
     {
       return SafeArea(
           child: Scaffold(
           drawer: MyDrawer(),
       body: ScientificCalculator(),
           )
       );

     }
     )
     );
   });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.indigo,
      // Load a Lottie file from your assets
       child: Lottie.asset('assets/loading-screen.json'),
    );
  }
}
