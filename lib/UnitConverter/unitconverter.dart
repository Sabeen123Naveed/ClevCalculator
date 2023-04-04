import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../admob/admob_testingids.dart';
import '../buttons.dart';

class UnitConverter extends StatefulWidget {
  @override
  _UnitConverterState createState() => _UnitConverterState();
}

class _UnitConverterState extends State<UnitConverter> with TickerProviderStateMixin {
  final TextStyle labelStyle = TextStyle(
    fontSize: 16.0,
  );
  final TextStyle resultSyle = TextStyle(
    color: Colors.indigo,
    fontSize: 25.0,
    fontWeight: FontWeight.w700,
  );
  AnimationController? _animationController;
  Animation<Offset>? _animation;

  final List<String> _mesaures = [
    'Meters',
    'Kilometers',
    'Grams',
    'Kilograms',
    'Feet',
    'Miles',
    'Pounds',
    'Ounces'
  ];

  late double _value;
  String _fromMesaures = 'Meters';
  String _toMesaures = 'Kilometers';
  String _results = "";
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final Map<String, int> _mesauresMap = {
    'Meters': 0,
    'Kilometers': 1,
    'Grams': 2,
    'Kilograms': 3,
    'Feet': 4,
    'Miles': 5,
    'Pounds': 6,
    'Ounces': 7,
  };

  dynamic _formulas = {
    '0': [1, 0.001, 0, 0, 3.28084, 0.000621371, 0, 0],
    '1': [1000, 1, 0, 0, 3280.84, 0.621371, 0, 0],
    '2': [0, 0, 1, 0.0001, 0, 0, 0.00220462, 0.035274],
    '3': [0, 0, 1000, 1, 0, 0, 2.20462, 35.274],
    '4': [0.3048, 0.0003048, 0, 0, 1, 0.000189394, 0, 0],
    '5': [1609.34, 1.60934, 0, 0, 5280, 1, 0, 0],
    '6': [0, 0, 453.592, 0.453592, 0, 0, 1, 16],
    '7': [0, 0, 28.3495, 0.0283495, 3.28084, 0, 0.0625, 1],
  };
  late BannerAd _bannerAd;
  bool isBannerAdLoaded = false;
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
  double screenHeight = 0;
  double screenWidth = 0;
  bool startAnimation = false;
  int index = 3;
  @override
  void initState()  {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _animation = Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0)).animate(_animationController!);
    _animationController!.forward();

    initBannerAd();
  }

  @override
  void disposeState(){
    super.dispose();
    _animationController!.dispose();
    _bannerAd.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          drawer: MyDrawer(),
          appBar: AppBar(
            title: Text('Unit Converter'),
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
           child: Center(
               child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: SlideTransition(
                  position: _animation!,
                  child: Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Enter the Value',
                        ),
                        onChanged: (value) {
                          setState(() {
                            _value = double.parse(value);
                          });
                        },
                      ),
                      SizedBox(height: 25.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'From',
                                style: labelStyle,
                              ),
                              DropdownButton(
                                items: _mesaures
                                    .map((String value) => DropdownMenuItem<String>(
                                  child: Text(value),
                                  value: value,
                                ))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _fromMesaures = value!;
                                  });
                                },
                                value: _fromMesaures,
                              )
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('To', style: labelStyle),
                              DropdownButton(
                                items: _mesaures
                                    .map((String value) => DropdownMenuItem<String>(
                                  child: Text(value),
                                  value: value,
                                ))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _toMesaures = value!;
                                  });
                                },
                                value: _toMesaures,
                              )
                            ],
                          ),
                        ],
                      ),
                        MaterialButton(
                          minWidth: double.infinity,
                          onPressed: _convert,
                          child: Text(
                            'Convert',
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Theme.of(context).primaryColor,
                        ),
                      SizedBox(height: 25.0),
                      Text(
                        _results,
                        style: resultSyle,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
        ),
             ),
         ),
         ),


    );
  }

  void _convert() {
    print('Button Clicked');
    print(_value);

    if (_value != 0 && _fromMesaures.isNotEmpty && _toMesaures.isNotEmpty) {
      int from = _mesauresMap[_fromMesaures]!;
      int to = _mesauresMap[_toMesaures]!;

      var multiplier = _formulas[from.toString()][to];

      setState(() {
        _results =
        "$_value $_fromMesaures = ${_value * multiplier} $_toMesaures";
      });
    } else {
      setState(() {
        _results = "Please enter a non zero value";
      });
    }
  }
}