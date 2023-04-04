import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:share/share.dart';

import '../admob/admob_testingids.dart';
import '../buttons.dart';

class TipCalculator extends StatefulWidget {
  @override
  _TipCalculatorState createState() => _TipCalculatorState();
}

class _TipCalculatorState extends State<TipCalculator> with TickerProviderStateMixin{
  double billAmount = 0.0;
  double tipPercentage = 0;
  double tipAmount = 0.0;
  double totalAmount = 0.0;
  int noOfPeople = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  double amountPerPerson = 0;
  AnimationController? _animationController;
  Animation<Offset>? _animation;
  FocusNode _firstFocusNode = FocusNode();
  FocusNode _secondFocusNode = FocusNode();
  FocusNode _thirdFocusNode = FocusNode();
  final billAmountController = TextEditingController();
  final tipPercentageController = TextEditingController();
  final noOfPeopleController = TextEditingController();

  void calculateTip() {
    setState(() {

      tipAmount = (billAmount * tipPercentage) / 100;
      totalAmount = billAmount + tipAmount;
    });
  }

  void calculateAmountPerPerson(){
    setState(() {
      amountPerPerson = totalAmount / noOfPeople;
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
            title: Text("Tip Calculator"),
            actions: [
              IconButton(
                  onPressed: (){
                    setState(() {
                      billAmountController.clear();
                      tipPercentageController.clear();
                      noOfPeopleController.clear();
                      tipAmount = 0;
                      totalAmount = 0;
                      amountPerPerson = 0;
                      _firstFocusNode.requestFocus();
                    });
                  },
                  icon: Icon(Icons.delete)
              ),
              IconButton(
                icon: Icon(Icons.share),
                onPressed: () {
                  Share.share(
                          'Bill Amount : ${ billAmount} \n'
                          'Tip Percent : ${ tipPercentage} \n'
                          'Tip Amount : ${ tipAmount} \n'
                          'Number of People : ${ noOfPeople} \n'
                          'Total Amount : ${totalAmount} \n'
                          'Amount Per Person : ${amountPerPerson} \n'


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
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: SlideTransition(
                position: _animation!,
                child: Column(
                  children: [
                    Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Add a tip",
                          style: TextStyle(fontSize: 25),
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Container(
                              color: Colors.white,
                              height: 75,
                              child: Column(children: [
                                Container(
                                  child: Text("Bill Amount", style: TextStyle(fontSize: 20)),
                                ),
                                TextField(
                                  controller: billAmountController,
                                  focusNode: _firstFocusNode,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                      filled: true, fillColor: Colors.white),
                                  onChanged: (value) {
                                    billAmount = double.parse(value);
                                    calculateTip();
                                  },
                                ),
                              ]
                              ),
                            )
                        ),
                        SizedBox(width: 5,),
                        Expanded(
                            child: Container(
                              color: Colors.white,
                              height: 75,
                              child: Column(children: [
                                Container(
                                  child: Text("Tip Percent", style: TextStyle(fontSize: 20)),
                                ),
                                TextField(
                                  controller: tipPercentageController,
                                  focusNode: _secondFocusNode,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                      filled: true, fillColor: Colors.white),
                                  onChanged: (value) {
                                    if (value.isNotEmpty && !value.endsWith("%")) {
                                      tipPercentageController.text = value + "%";
                                      // Set the cursor position after the last entered digit
                                      tipPercentageController.selection = TextSelection.fromPosition(
                                          TextPosition(offset: tipPercentageController.text.length - 1));
                                    }
                                    String valueWithoutPercent = value.replaceAll("%", "");
                                    tipPercentage = double.tryParse(valueWithoutPercent) ?? 0.0;
                                    // tipPercentage = double.parse(value);
                                    calculateTip();
                                  },
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                              ]),
                            )
                        ),

                      ],
                    ),

                    SizedBox(height: 5,),


                    Row(
                      children: [
                        Expanded(
                            child: Container(
                              color: Colors.white,
                              height: 75,
                              child: Column(children: [
                                Container(
                                  child: Text("Tip Amount", style: TextStyle(fontSize: 20)),
                                ),
                                Container(child: Text("$tipAmount", style: TextStyle(fontSize: 20),),)
                              ]),
                            )
                        ),
                        SizedBox(width: 5,),

                        Expanded(
                            child: Container(
                              color: Colors.white,
                              height: 75,
                              child: Column(children: [
                                Container(
                                  child: Text("Number of people", style: TextStyle(fontSize: 20)),
                                ),
                                TextField(
                                  controller: noOfPeopleController,
                                  focusNode: _thirdFocusNode,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                      filled: true, fillColor: Colors.white),
                                  onChanged: (value) {
                                    noOfPeople = int.parse(value);
                                    calculateAmountPerPerson();
                                  },
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                              ]),
                            )
                        ),

                      ],
                    ),

                    SizedBox(height: 20,),

                    Align(alignment: Alignment.topLeft, child: Text("Results", style: TextStyle(fontSize: 20),)),

                    SizedBox(height: 10,),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            color: Colors.white,
                            height: 55,
                            child: Column(children: [
                              Container(
                                child: Text("Total Amount", style: TextStyle(fontSize: 20)),
                              ),
                              Container(child: Text("$totalAmount", style: TextStyle(fontSize: 20, color: Colors.indigo),),)
                            ]),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),

                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            color: Colors.white,
                            height: 55,
                            child: Column(children: [
                              Container(
                                child: Text("Amount Per Person", style: TextStyle(fontSize: 20)),
                              ),
                              Container(child: Text("$amountPerPerson", style: TextStyle(fontSize: 20, color: Colors.indigo),),)
                            ]),
                          ),
                        ),
                      ],
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