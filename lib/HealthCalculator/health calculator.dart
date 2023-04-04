import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:share/share.dart';

import '../admob/admob_testingids.dart';
import '../buttons.dart';

enum Gender { male, female }

class BMICalculator extends StatefulWidget {
  @override
  _BMICalculatorState createState() => _BMICalculatorState();
}

class _BMICalculatorState extends State<BMICalculator> with TickerProviderStateMixin {
  int _feet = 5;
  int _inches = 5;
  double _weight = 0.0;
  int _age = 0 ;
  Gender _gender = Gender.male;
  double _bmi = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  FocusNode _firstFocusNode = FocusNode();
  FocusNode _secondFocusNode = FocusNode();
  final TextEditingController weightcontroller = TextEditingController();
  final TextEditingController agecontroller = TextEditingController();
  AnimationController? _animationController;
  Animation<Offset>? _animation;
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
  @override
  void initState()  {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
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

  void _calculateBMIAndBMR() {
    // Convert height to inches
    int heightInInches = ((_feet * 12) + _inches);
    // Calculate BMI
    _bmi = _weight / pow(heightInInches / 39.37, 2);

  }
  String getWeightStatus(double bmi) {
    if (bmi < 18.5) {
      return 'Underweight';
    } else if (bmi >= 18.5 && bmi < 25) {
      return 'Normal weight';
    } else if (bmi >= 25 && bmi < 30) {
      return 'Overweight';
    } else {
      return 'Obese';
    }
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          drawer: MyDrawer(),
          appBar: AppBar(
            title: Text('BMI Calculator'),
            actions: [
              IconButton(
                  onPressed: (){
                    setState(() {
                      weightcontroller.clear();
                      agecontroller.clear();
                       _weight = 0.0;
                       _bmi = 0.0;
                      _firstFocusNode.requestFocus();

                    });

                  },
                  icon: Icon(Icons.delete)
              ),
              IconButton(
                icon: Icon(Icons.share),
                onPressed: () {
                  Share.share(
                          'BMI (Body Mass Index) \n'
                          '${_bmi.toStringAsFixed(2)} : ${getWeightStatus(_bmi)}\n'

                  );
                },
              ),
            ],
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
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SlideTransition(
                  position: _animation!,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                         Center(child: Text("Height", style: TextStyle(fontSize: 18),)),
                      SizedBox(height: 15,),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<int>(
                              decoration: InputDecoration(
                                labelText: 'Feet',
                              ),
                              value: _feet,
                              onChanged: (value) {
                                setState(() {
                                  _feet = value!;
                                });
                              },
                              items: List.generate(8, (index) {
                                return DropdownMenuItem<int>(
                                  value: index + 1,
                                  child: Text('${index + 1} ft'),
                                );
                              }),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: DropdownButtonFormField<int>(
                              decoration: InputDecoration(
                                labelText: 'Inches',
                              ),
                              value: _inches,
                              onChanged: (value) {
                                setState(() {
                                  _inches = value!;
                                });
                              },
                              items: List.generate(12, (index) {
                                return DropdownMenuItem<int>(
                                  value: index,
                                  child: Text('${index} in'),
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: weightcontroller,
                        focusNode: _firstFocusNode,
                        decoration: InputDecoration(
                          labelText: 'Weight (kg)',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your weight';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            _weight = double.parse(value);
                          });
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: agecontroller,
                          focusNode: _secondFocusNode,
                          decoration: InputDecoration(
                            labelText: 'Age',
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your age';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              _age = int.parse(value);
                            });
                          }),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ListTile(
                              title: Text('Male'),
                              leading: Radio<Gender>(
                                value: Gender.male,
                                groupValue: _gender,
                                onChanged: (value) {
                                  setState(() {
                                    _gender = value!;
                                  });
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              title: Text('Female'),
                              leading: Radio<Gender>(
                                value: Gender.female,
                                groupValue: _gender,
                                onChanged: (value) {
                                  setState(() {
                                    _gender = value!;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _calculateBMIAndBMR();
                          });
                        }
                        ,
                        child: Text('Calculate'),
                      ),
                      SizedBox(height: 25),
                      Text('BMI  (Body Mass Index)',style: TextStyle(fontSize: 20 , fontWeight: FontWeight.w500),),
                        SizedBox(height: 10),
                      Text('${_bmi.toStringAsFixed(2)} : ${getWeightStatus(_bmi)}',
                        style: TextStyle(fontSize: 20 , fontWeight: FontWeight.w500),),

                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

    );

  }


}









