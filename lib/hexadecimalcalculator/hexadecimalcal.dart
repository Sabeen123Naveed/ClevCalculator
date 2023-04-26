import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../admob/admob_testingids.dart';
import '../buttons.dart';


class HexCalculator extends StatefulWidget {
  @override
  _HexCalculatorState createState() => _HexCalculatorState();
}

class _HexCalculatorState extends State<HexCalculator> with TickerProviderStateMixin {

  final TextEditingController controller1 = TextEditingController();
  final TextEditingController controller3 = TextEditingController();
  FocusNode _firstFocusNode = FocusNode();
  FocusNode _secondFocusNode = FocusNode();
  AnimationController? _animationController;
  Animation<Offset>? _animation;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String hexx = '';
  String decc = '';
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
    await prefs.setInt('lastScreenIndex', 8);// Set a key-value pair to indicate that the app is resumed
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(

        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.grey.shade300,
          drawer: MyDrawer(),
          appBar: AppBar(
            title: Text('Hex Calculator'),
            centerTitle: true,
              actions: [
              IconButton(
              onPressed: (){
               setState(() {
                 controller1.clear();
                 controller3.clear();
                 hexx = '';
                 decc = '';
                 _firstFocusNode.requestFocus();
                 });

                 },
            icon: Icon(Icons.delete)
            ),
                IconButton(
                  icon: Icon(Icons.share),
                  onPressed: () {
                    Share.share(
                        ' Hex value :  ${hexx}\n'
                            " Decimal value :  ${decc}"

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
            child: SlideTransition(
              position: _animation!,
              child: SingleChildScrollView(
                child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Text("Decimal to Hex",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                  //  SizedBox(height: 5),
                     Padding(
                       padding: const EdgeInsets.only(left: 15 , right: 15),
                       child: TextFormField(
                         focusNode: _firstFocusNode,
                        controller: controller1,
                         maxLength: 19,
                        decoration:InputDecoration(
                          hintText: 'Enter decimal value',
                          hoverColor:  Colors.cyan,

                        ),
                  ),
                     ),

                  SizedBox(
                    height: 10,
                  ),
                      ElevatedButton(
                        onPressed: Convert,
                        child: Text('Convert'),
                      ),

                      SizedBox(
                        height: 10,
                      ),

                  Text(" Hex value :  ${hexx}",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),

                  ),


                  SizedBox(
                    height: 10,
                  ),
                      Text("Hex to Decimal",style:TextStyle(fontSize: 25,fontWeight: FontWeight.bold)),
                     // SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.only(left: 15 , right: 15),
                        child: TextFormField(
                          controller: controller3,
                          maxLength: 16,
                          focusNode: _secondFocusNode,
                          decoration:InputDecoration(
                               hintText: 'Enter hex value',
                              hoverColor:  Colors.cyan
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: convert1,
                        child: Text('Convert'),
                      ),

                      SizedBox(
                        height: 10,
                      ),
                      Text(" Decimal value :  ${decc}",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),

                      ),


                  ]
                  ),
              ),
            ),
          ),
          ),

    );
  }
  void Convert() {
    String userInput = controller1.text.toString();
    int decimal = int.parse(userInput);
    String hex = decimal.toRadixString(16).toUpperCase();
    setState(() {
      hexx = hex;
    });

    print(hex);
  }
  void convert1(){
  String userInput1 = controller3.text.toString();
  int decimal = int.parse(userInput1, radix: 16);
  String decimalString = decimal.toString();
  setState(() {
    decc = decimalString;
  });

  print(decimalString);
  }
}







