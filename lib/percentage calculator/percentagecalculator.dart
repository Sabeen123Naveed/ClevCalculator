import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:share/share.dart';

import '../admob/admob_testingids.dart';
import '../buttons.dart';

class PercentageCalculator extends StatefulWidget {
  @override
  _PercentageCalculatorState createState() => _PercentageCalculatorState();
}

class _PercentageCalculatorState extends State<PercentageCalculator> with TickerProviderStateMixin{
  final _formKey = GlobalKey<FormState>();
  AnimationController? _animationController;
  Animation<Offset>? _animation;
  final TextEditingController totalmrks = TextEditingController();
  final TextEditingController percentage= TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  double _totalAmount = 0.0;
  double _percentage = 0.0;
  double _result = 0.0;
  FocusNode _firstFocusNode = FocusNode();
  FocusNode _secondFocusNode = FocusNode();

  void _calculateResult() {
    setState(() {
      _result = _totalAmount * (_percentage / 100);
    });
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


  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          drawer: MyDrawer(),
          appBar: AppBar(
            title: Text("Percentage Cal"),
              actions: [
                IconButton(
                    onPressed: (){
                      setState(() {
                         _totalAmount = 0.0;
                         _percentage = 0.0;
                         _result = 0.0;
                         totalmrks.clear();
                         percentage.clear();
                         _firstFocusNode.requestFocus();
                      });

                    },
                    icon: Icon(Icons.delete)
                ),
                IconButton(
                  icon: Icon(Icons.share),
                  onPressed: () {
                    Share.share(
                        'Total Amount ${_totalAmount} \n'
                            'Percentage ${ _percentage}\n'
                             'Result: $_result \n'


                    );
                  },
                ),
              ]
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
              child: Form(
                key: _formKey,
                child:   SlideTransition(
                  position: _animation!,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15 , right: 15),
                        child: TextFormField(
                          focusNode: _firstFocusNode,
                          controller: totalmrks,
                          decoration: InputDecoration(labelText: 'Total Amount'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a value';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _totalAmount = double.parse(value!);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15 , right: 15),
                        child: TextFormField(
                          focusNode: _secondFocusNode,
                          controller: percentage,
                          decoration: InputDecoration(labelText: 'Percentage'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a value';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _percentage = double.parse(value!);
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.cyan,
                              padding: EdgeInsets.all(18)
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              _calculateResult();
                            }
                          },
                          child: Text('Calculate'),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Text(
                          'Result: $_result',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
    );
  }
}



