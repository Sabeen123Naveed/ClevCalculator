import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../admob/admob_testingids.dart';
import '../buttons.dart';

class FuelEfficencyCalculator extends StatefulWidget {
  @override
  _FuelEfficencyCalculatorState createState() => _FuelEfficencyCalculatorState();
}

class _FuelEfficencyCalculatorState extends State<FuelEfficencyCalculator> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  AnimationController? _animationController;
  Animation<Offset>? _animation;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  double _mileageBeforeRefueling = 0;
  double _remainingFuelBeforeRefueling = 0;
  double _amountRefueled = 0;
  double _mileageAfterDriving = 0;
  double _fuelEfficiency = 0;
  final TextEditingController mileberef = TextEditingController();
  final TextEditingController remainfuel= TextEditingController();
  final TextEditingController amountrefuled = TextEditingController();
  final TextEditingController mileafter = TextEditingController();
  FocusNode _firstFocusNode = FocusNode();
  FocusNode _secondFocusNode = FocusNode();
  FocusNode _thirdFocusNode = FocusNode();
  FocusNode _fourthFocusNode = FocusNode();
  String _selectedMileageUnit = 'miles';
  String _amountrefuled = 'gallons';
  void _calculateFuelEfficiency() {
    double totalDistanceDriven = _mileageAfterDriving - _mileageBeforeRefueling;
    _fuelEfficiency = totalDistanceDriven / _amountRefueled;
  }
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
  Future<void> _saveAppState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lastScreenIndex', 6);// Set a key-value pair to indicate that the app is resumed
  }

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          drawer: MyDrawer(),
            appBar: AppBar(
              title: Text('Fuel Efficiency Calculator'),
              actions: [
                IconButton(
                    onPressed: (){
                      setState(() {

                         _mileageBeforeRefueling = 0;
                         _remainingFuelBeforeRefueling = 0;
                         _amountRefueled = 0;
                         _mileageAfterDriving = 0;
                        _fuelEfficiency = 0;
                        mileberef.clear();
                        remainfuel.clear();
                        amountrefuled.clear();
                        mileafter.clear();
                        _firstFocusNode.requestFocus();

                      });

                    },
                    icon: Icon(Icons.delete)
                ),
                IconButton(
                  icon: Icon(Icons.share),
                  onPressed: () {
                    Share.share(
                        'Mileage before refueling ${_mileageBeforeRefueling}\n'
                            'Remaining fuel before refueling ${_remainingFuelBeforeRefueling}\n'
                            'Amount refueled ${_amountRefueled}\n'
                            'Mileage after driving ${_mileageAfterDriving}\n'
                        'Fuel efficiency: $_fuelEfficiency'


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
                            onPressed: () async {
                              Navigator.pop(context, true); // close the dialog
                              SystemNavigator.pop();
                              await _saveAppState();// exit the app
                            },
                            /* exit(0) will close the app */
                            child: Text('Yes'),
                          ),
                        ],
                      )
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child:  SingleChildScrollView(
                    child: SlideTransition(
                      position: _animation!,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: mileberef,
                                  focusNode: _firstFocusNode,
                                  decoration: InputDecoration(
                                    labelText: 'Mileage before refueling',
                                    suffix: Text(_selectedMileageUnit), // Display the selected unit as suffix
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      _mileageBeforeRefueling = double.parse(value);
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a mileage';
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              SizedBox(width: 66), // Add some spacing between the TextFormField and DropdownButton
                              DropdownButton<String>(
                                value: _selectedMileageUnit,
                                items: [
                                  DropdownMenuItem<String>(
                                    value: 'miles',
                                   // Set the height of the dropdown menu item
                                   child: Text('miles')
                              ),

                                  DropdownMenuItem<String>(
                                    value: 'Km',
                                   child: Text('Km')
                                  ),

                                ],
                                onChanged: (value) {
                                  setState(() {
                                    _selectedMileageUnit = value!;
                                  });
                                },

                              ),
                            ],
                          ),
                          // TextFormField(
                          //   controller: remainfuel,
                          //   focusNode: _secondFocusNode,
                          //   decoration: InputDecoration(labelText: 'Remaining fuel before refueling'),
                          // //  keyboardType: TextInputType.number,
                          //   onChanged: (value) {
                          //     setState(() {
                          //       if (value.isNotEmpty && !value.endsWith("%")) {
                          //         remainfuel.text = value + "%";
                          //         // Set the cursor position after the last entered digit
                          //         remainfuel.selection = TextSelection.fromPosition(
                          //             TextPosition(offset: remainfuel.text.length - 1));
                          //       }
                          //       String valueWithoutPercent = value.replaceAll("%", "");
                          //       _remainingFuelBeforeRefueling = double.tryParse(valueWithoutPercent) ?? 0.0;
                          //
                          //     });
                          //     // setState(() {
                          //     //   _remainingFuelBeforeRefueling = double.parse(value);
                          //     // });
                          //   },
                          // ),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: amountrefuled,
                                  focusNode: _thirdFocusNode,
                                  decoration: InputDecoration(
                                    labelText: 'Amount refueled',
                                    suffix: Text(_amountrefuled), // Display the selected unit as suffix
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      _amountRefueled = double.parse(value);
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter amount refuled';
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              SizedBox(width: 55), // Add some spacing between the TextFormField and DropdownButton
                              DropdownButton<String>(
                                value: _amountrefuled,
                                items: [
                                  DropdownMenuItem<String>(
                                      value: 'gallons',
                                      // Set the height of the dropdown menu item
                                      child: Text('gallons')
                                  ),

                                  DropdownMenuItem<String>(
                                      value: 'litres',
                                      child: Text('litres')
                                  ),

                                ],
                                onChanged: (value) {
                                  setState(() {
                                    _amountrefuled = value!;
                                  });
                                },

                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller:  mileafter,
                                  focusNode: _fourthFocusNode,
                                  decoration: InputDecoration(
                                    labelText: 'Mileage after driving',
                                    suffix: Text(_selectedMileageUnit), // Display the selected unit as suffix
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      _mileageAfterDriving  = double.parse(value);
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a mileage';
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              SizedBox(width: 66), // Add some spacing between the TextFormField and DropdownButton
                              DropdownButton<String>(
                                value: _selectedMileageUnit,
                                items: [
                                  DropdownMenuItem<String>(
                                      value: 'miles',
                                      child: Text('miles')
                                  ),

                                  DropdownMenuItem<String>(
                                      value: 'Km',
                                      child: Text('Km')
                                  ),

                                ],
                                onChanged: (value) {
                                  setState(() {
                                    _selectedMileageUnit = value!;
                                  });
                                },

                              ),
                            ],
                          ),

                          SizedBox(height: 20,),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _calculateFuelEfficiency();
                              });
                            }
                            ,
                            child: Text('Calculate'),
                          ),

                          SizedBox(height: 20,),

                          Text('Fuel efficiency: ${_fuelEfficiency.toStringAsFixed(2)} ${_selectedMileageUnit}/${ _amountrefuled}')
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),


    );
  }
}

