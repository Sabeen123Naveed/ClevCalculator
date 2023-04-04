import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../admob/admob_testingids.dart';
import '../buttons.dart';


class HexCalculator extends StatefulWidget {
  @override
  _HexCalculatorState createState() => _HexCalculatorState();
}

class _HexCalculatorState extends State<HexCalculator> with TickerProviderStateMixin {

  final TextEditingController controller1 = TextEditingController();
  final TextEditingController controller3 = TextEditingController();
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
                 });

                 },
            icon: Icon(Icons.delete)
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
            child: SlideTransition(
              position: _animation!,
              child: Column(
                  children: [
                    Text("Decimal to Hex",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                //  SizedBox(height: 5),
                   Padding(
                     padding: const EdgeInsets.only(left: 15 , right: 15),
                     child: TextFormField(
                      controller: controller1,
                      decoration:InputDecoration(
                        // hintText: '10',
                        hoverColor:  Colors.cyan,

                      ),
                ),
                   ),

                SizedBox(
                  height: 10,
                ),
                TextButton(
                    onPressed: (){
                      Convert();
                    },
                    child: Text("Convert"),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.cyan,
                    padding: EdgeInsets.all(18)
                  ),
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
                        decoration:InputDecoration(
                            // hintText: '16',
                            hoverColor:  Colors.cyan
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextButton(
                        onPressed: (){
                          convert1();
                        },
                        child: Text("Convert"),
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.cyan,
                          padding: EdgeInsets.all(18)
                      ),
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







