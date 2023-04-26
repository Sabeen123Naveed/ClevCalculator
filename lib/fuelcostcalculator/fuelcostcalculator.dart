import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../admob/admob_testingids.dart';
import '../buttons.dart';
class FuelCostCalculator extends StatefulWidget {
  @override
  _FuelCostCalculatorState createState() => _FuelCostCalculatorState();
}


class _FuelCostCalculatorState extends State<FuelCostCalculator> with TickerProviderStateMixin{
  AnimationController? _animationController;
  Animation<Offset>? _animation;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool startAnimation = false;
  double _fuelEfficiency = 0;
  double _fuelPrice = 0;
  double _distance = 0;
  final TextEditingController fueleffi = TextEditingController();
  final TextEditingController fueprice= TextEditingController();
  final TextEditingController distance = TextEditingController();
  FocusNode _firstFocusNode = FocusNode();
  FocusNode _secondFocusNode = FocusNode();
  FocusNode _thirdFocusNode = FocusNode();
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
  Future<void> _saveAppState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lastScreenIndex', 5);// Set a key-value pair to indicate that the app is resumed
  }

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
            drawer: MyDrawer(),
          appBar: AppBar(
            title: Text('Fuel Cost'),
           // centerTitle: true,
            elevation: 0.0,
            actions: [
              IconButton(
                  onPressed: (){
                    setState(() {
                      _fuelEfficiency = 0;
                      _fuelPrice = 0;
                      _distance = 0;
                      fueleffi.clear();
                      fueprice.clear();
                      distance.clear();
                      _firstFocusNode.requestFocus();
                    });

                  },
                  icon: Icon(Icons.delete)
              ),
              IconButton(
                icon: Icon(Icons.share),
                onPressed: () {
                  Share.share(
                      'Fuel Efficiency (miles per gallon) : ${_fuelEfficiency} \n'
                          'Fuel Price (per gallon) :  ${_fuelPrice} \n'
                          'Distance (miles) :  ${_distance} \n'
                      'Estimated Cost  :  \$${( (_distance / _fuelEfficiency) * _fuelPrice).toStringAsFixed(2)} \n'
                      'Estimated Fuel Amount : ${(_distance / _fuelEfficiency).toStringAsFixed(2)}gallons'

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
                padding: EdgeInsets.all(16),

                    child: SlideTransition(
                      position: _animation!,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                                TextField(
                                controller: fueleffi,
                                  focusNode: _firstFocusNode,
                                decoration: InputDecoration(hintText: 'Fuel Efficiency (miles per gallon)'),
                            //  keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  setState(() {
                                    _fuelEfficiency = double.parse(value);
                                  });
                                },


                            ),

                          SizedBox(height: 16),

                            TextField(
                              controller: fueprice,
                              focusNode: _secondFocusNode,
                              decoration: InputDecoration(hintText: 'Fuel Price (per gallon)'),
                             // keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  _fuelPrice = double.parse(value);
                                });
                              },
                            ),

                          SizedBox(height: 16),

                             TextField(
                              controller: distance,
                               focusNode: _thirdFocusNode,
                              decoration: InputDecoration(hintText: 'Distance (miles)'),
                            //  keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  _distance = double.parse(value);
                                });
                              },
                            ),

                          SizedBox(height: 16),

                            Text(
                              'Estimated Cost: \$${( (_distance / _fuelEfficiency) * _fuelPrice).toStringAsFixed(2)}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),

                          SizedBox(height: 16),

                             Text(
                              'Estimated Fuel Amount: ${(_distance / _fuelEfficiency).toStringAsFixed(2)} gallons',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),


                        ],
                       ),
                    )
                     ),
            )
                   ),


    );
  }
}



