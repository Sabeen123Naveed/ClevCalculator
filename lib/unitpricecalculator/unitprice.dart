import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:share/share.dart';

import '../admob/admob_testingids.dart';
import '../buttons.dart';
class UnitPrice extends StatefulWidget {
  const UnitPrice({Key? key}) : super(key: key);

  @override
  State<UnitPrice> createState() => _UnitPriceState();
}

class _UnitPriceState extends State<UnitPrice> with TickerProviderStateMixin {
  final TextEditingController Price = TextEditingController();
  final TextEditingController numberofunits= TextEditingController();
  AnimationController? _animationController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Animation<Offset>? _animation;
  FocusNode _firstFocusNode = FocusNode();
  FocusNode _secondFocusNode = FocusNode();
  int price = 0;
  int quantity = 0;
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
              title: Text("Unit Calculator"),
              actions: [
                IconButton(
                    onPressed: (){
                      setState(() {
                         price = 0;
                         quantity = 0;
                         Price.clear();
                         numberofunits.clear();
                         _firstFocusNode.requestFocus();
                      });

                    },
                    icon: Icon(Icons.delete)
                ),
                IconButton(
                  icon: Icon(Icons.share),
                  onPressed: () {
                    Share.share(
                      'Price:      ${price}\n'
                      'Quantity :  ${quantity}\n'
                          'Unit Price:    \$${ (price / quantity) .toStringAsFixed(2)}\n'

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
            child: SlideTransition(
              position: _animation!,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15 , right: 15),
                    child: TextFormField(
                      controller: Price,
                      focusNode: _firstFocusNode,
                      decoration: InputDecoration(labelText: ' Price'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter price';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          price = int.parse(value!);
                        });

                      },
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15 , right: 15),
                    child: TextFormField(
                      controller: numberofunits,
                      focusNode: _secondFocusNode,
                      decoration: InputDecoration(labelText: 'Quantity'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter price';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          quantity = int.parse(value!);
                        });

                      },
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Unit Price:    ${ (price / quantity).toStringAsFixed(3) }',
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
