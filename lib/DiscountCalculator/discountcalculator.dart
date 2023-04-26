
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../admob/admob_testingids.dart';
import '../buttons.dart';


class DiscountCalculator extends StatefulWidget {
  const DiscountCalculator({Key? key}) : super(key: key);

  @override
  State<DiscountCalculator> createState() => _DiscountCalculatorState();
}

class _DiscountCalculatorState extends State<DiscountCalculator> with TickerProviderStateMixin {
  // , AutomaticKeepAliveClientMixin
  // @override
  // bool get wantKeepAlive => true;
  double originalPrice = 0;
  int discountPercent = 0;
  double amountSaved = 0;
  double finalPrice = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  AnimationController? _animationController;
  Animation<Offset>? _animation;
  FocusNode _firstFocusNode = FocusNode();
  FocusNode _secondFocusNode = FocusNode();
  final originalPriceController = TextEditingController();
  final discountPercentController = TextEditingController();

  calculatePrice(){
    setState(() {
      amountSaved = (originalPrice * discountPercent)/100;
      finalPrice = originalPrice - amountSaved;
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


  Future<void> _saveAppState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lastScreenIndex', 2);// Set a key-value pair to indicate that the app is resumed
  }



  @override
  Widget build(BuildContext context) {
          return SafeArea(
            child: Scaffold(
              key: _scaffoldKey,
              drawer: MyDrawer(),
              appBar: AppBar(
                title: Text("Discount "),
                actions: [
                  IconButton(
                      onPressed: () {
                        setState(() {
                          originalPriceController.clear();
                          discountPercentController.clear();
                          _firstFocusNode.requestFocus();
                          amountSaved = 0;
                          finalPrice = 0;
                        });
                      },
                      icon: Icon(Icons.delete)
                  ),
                  IconButton(
                    icon: Icon(Icons.share),
                    onPressed: () {
                      Share.share(
                          'Orginal Price : ${originalPrice} \n'
                              'Discount Percent : ${ discountPercent} \n'
                              'Amount Saved : ${amountSaved } \n'
                              'Final Price : ${finalPrice } \n'

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
                child: AdWidget(ad: _bannerAd),


              ) : SizedBox(),

              body: WillPopScope(
                onWillPop: () async {
                  if (_scaffoldKey.currentState!.isDrawerOpen) {
                    // if drawer is open, close it and consume the back button
                    _scaffoldKey.currentState!.openEndDrawer();
                    return false;
                  } else {
                    // if drawer is not open, allow the back button to close the app
                    return await showDialog(
                        context: context,
                        builder: (context) =>
                            AlertDialog(
                              title: Text('Confirm Exit'),
                              content: Text('Are you sure you want to exit?'),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: Text('No'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    Navigator.pop(context, true); // close the dialog
                                    SystemNavigator.pop();
                                    await _saveAppState();// exit the app
                                  },
                                  // onPressed: () =>  exit(0),
                                  /* exit(0) will close the app */
                                  child: Text('Yes'),
                                ),
                              ],
                            )
                    );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: SlideTransition(
                    position: _animation!,
                    child: Column(
                      children: [

                        Row(
                          children: [
                            Expanded(child: Container(
                              height: 47,
                              color: Colors.white,
                              child: Center(child: Text("Original Price",
                                style: TextStyle(fontSize: 18),)),
                            ),
                            ),
                            SizedBox(width: 2,),
                            Expanded(
                              child: TextField(
                                controller: originalPriceController,
                                focusNode: _firstFocusNode,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white
                                ),
                                onChanged: (value) {
                                  originalPrice = double.parse(value);
                                  calculatePrice();
                                },
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 5,),

                        Row(
                          children: [
                            Expanded(child: Container(
                              height: 47,
                              color: Colors.white,
                              child: Center(child: Text("Discount Percent",
                                  style: TextStyle(fontSize: 18))),
                            ),
                            ),
                            SizedBox(width: 2,),
                            Expanded(
                              child: TextField(
                                keyboardType: TextInputType.numberWithOptions(decimal: true),
                                inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.,]+')),],

                                controller: discountPercentController,
                                focusNode: _secondFocusNode,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white
                                ),
                                onChanged: (value) {
                                  if (value.isNotEmpty &&
                                      !value.endsWith("%")) {
                                    discountPercentController.text =
                                        value + "%";
                                    // Set the cursor position after the last entered digit
                                    discountPercentController.selection =
                                        TextSelection.fromPosition(
                                            TextPosition(
                                                offset: discountPercentController
                                                    .text.length - 1));
                                  }
                                  String valueWithoutPercent = value.replaceAll(
                                      "%", "");
                                  discountPercent =
                                      int.tryParse(valueWithoutPercent) ?? 0;
                                  // discountPercent = int.parse(value);
                                  calculatePrice();
                                },
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 5,),

                        Row(
                          children: [
                            Expanded(child: Container(
                              height: 47,
                              color: Colors.white,
                              child: Center(child: Text("Amount Saved",
                                  style: TextStyle(fontSize: 18))),
                            ),
                            ),
                            SizedBox(width: 2,),
                            Expanded(
                                child: Container(
                                  height: 47,
                                  color: Colors.white,
                                  child: Center(child: Text("$amountSaved",
                                    style: TextStyle(fontSize: 20),)),
                                )
                            )
                          ],
                        ),
                        SizedBox(height: 5,),

                        Row(
                          children: [
                            Expanded(child: Container(
                              height: 47,
                              color: Colors.white,
                              child: Center(child: Text("Final Price",
                                  style: TextStyle(fontSize: 18))),
                            ),
                            ),
                            SizedBox(width: 2,),
                            Expanded(
                                child: Container(
                                  height: 47,
                                  color: Colors.white,
                                  child: Center(child: Text("$finalPrice",
                                    style: TextStyle(fontSize: 20),)),
                                )
                            )
                          ],
                        ),
                        SizedBox(height: 5,),


                      ],
                    ),
                  ),
                ),
              ),
            ),

          );

        }

}