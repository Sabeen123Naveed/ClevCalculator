import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:share/share.dart';

import '../admob/admob_testingids.dart';
import '../buttons.dart';
class VatCalculator extends StatefulWidget {
  const VatCalculator({Key? key}) : super(key: key);

  @override
  State<VatCalculator> createState() => _VatCalculatorState();
}

class _VatCalculatorState extends State<VatCalculator> with TickerProviderStateMixin{
  final TextEditingController taxrate = TextEditingController();
  final TextEditingController originalprice= TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  AnimationController? _animationController;
  Animation<Offset>? _animation;
  double price = 0.0;
  double taxxrate = 0.0;
  double tax = 0.0;
  FocusNode _firstFocusNode = FocusNode();
  FocusNode _secondFocusNode = FocusNode();
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
              title: Text("VAT Calculator"),
              actions: [
                IconButton(
                    onPressed: (){
                      setState(() {
                        price = 0.0;
                        taxxrate = 0.0;
                        taxrate.clear();
                        originalprice.clear();
                        _firstFocusNode.requestFocus();
                      });

                    },
                    icon: Icon(Icons.delete)
                ),
                IconButton(
                  icon: Icon(Icons.share),
                  onPressed: () {
                    Share.share(
                        'Tax Rate:      ${taxxrate}\n'
                            'Original Price :  ${price}\n'
                        'Tax:    ${ tax = price * (taxxrate / 100) }  \n'
                            'Total Price:  ${ price + tax }  \n'

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
          body:   WillPopScope(
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
                  Padding(
                    padding: const EdgeInsets.only(left: 15 , right: 15),
                    child: TextFormField(
                      controller: taxrate,
                      focusNode: _firstFocusNode,
                      decoration: InputDecoration(labelText: 'Tax Rate'),
                      onChanged: (value) {
                        setState(() {
                          if (value.isNotEmpty && !value.endsWith("%")) {
                            taxrate.text = value + "%";
                            // Set the cursor position after the last entered digit
                            taxrate.selection = TextSelection.fromPosition(
                                TextPosition(offset: taxrate.text.length - 1));
                          }
                          String valueWithoutPercent = value.replaceAll("%", "");
                          taxxrate = double.tryParse(valueWithoutPercent) ?? 0.0;
                          print("...taxxrate ${taxxrate}");
                          // taxxrate = double.parse(value);
                          // print("...taxxrate ${taxxrate}");
                        });

                      },
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    child: TextFormField(
                      controller: originalprice,
                      focusNode: _secondFocusNode,
                      decoration: InputDecoration(labelText: 'Original Price'),

                      onChanged: (value) {
                        setState(() {
                          price = double.parse(value);
                        });

                      },

                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Tax:  ${ tax = price * (taxxrate / 100) }',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Total price:  ${ price + tax }',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ],
              ),
            ),
          ),
        ),

    );
  }
}
