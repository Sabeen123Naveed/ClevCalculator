
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../admob/admob_testingids.dart';
import '../buttons.dart';

class OvulationCalculator extends StatefulWidget {
  @override
  _OvulationCalculatorState createState() => _OvulationCalculatorState();
}

class _OvulationCalculatorState extends State<OvulationCalculator> with TickerProviderStateMixin {
   DateTime _startDate = DateTime.now();
  int _averageCycle = 0;
  int _averagePeriod = 0;
   DateTime ovulationDate = DateTime.now();
  // bool _reminder = false;
   AnimationController? _animationController;
   Animation<Offset>? _animation;
   FocusNode _firstFocusNode = FocusNode();
   FocusNode _secondFocusNode = FocusNode();
   final TextEditingController Averagecycle = TextEditingController();
   final TextEditingController AveragePeriod= TextEditingController();
   final TextEditingController date= TextEditingController();
   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _startDate)
      setState(() {
        _startDate = picked;
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
     await prefs.setInt('lastScreenIndex', 10);// Set a key-value pair to indicate that the app is resumed
   }
    void ovulationdate(){
      ovulationDate = _startDate.add(Duration(
          days: (_averageCycle - _averagePeriod * 2).toInt()));
    }

   @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
            appBar: AppBar(
              title: Text('Ovulation Calculator'),
                actions: [
                  IconButton(
                      onPressed: (){
                        setState(() {
                        Averagecycle.clear();
                        AveragePeriod.clear();
                          _firstFocusNode.requestFocus();
                        });

                      },
                      icon: Icon(Icons.delete)
                  ),
                  IconButton(
                    icon: Icon(Icons.share),
                    onPressed: () {
                      Share.share(
                          'Start date of last period :  ${DateFormat.yMMMMd().format(_startDate)}\n'
                              'Average cycle (days) :   ${_averageCycle}\n'
                              'Average period (days) :  ${_averagePeriod}\n'
                               'Ovulation date : ${DateFormat.yMMMMd().format(ovulationDate)}\n'


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
          drawer: MyDrawer(),
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
                padding: EdgeInsets.all(16.0),
                child:  SlideTransition(
                  position: _animation!,
                  child: Column(
                      children:[
                  TextField(
                  decoration: InputDecoration(labelText: 'Start date of last period'),
                  onTap: () => _selectStartDate(context),
                  readOnly: true,
                  controller: TextEditingController(
                      text: _startDate == null
                          ? ''
                          : DateFormat.yMMMMd().format(_startDate)),
              ),
              TextField(
                  decoration: InputDecoration(labelText: 'Average cycle (days)'),
                controller: Averagecycle,
                focusNode: _firstFocusNode,
                  keyboardType: TextInputType.number,
                  onChanged: (value) =>
                      setState(() => _averageCycle = int.parse(value)),
              ),
              TextField(
                  decoration: InputDecoration(labelText: 'Average period (days)'),
                controller: AveragePeriod,
                focusNode: _secondFocusNode,
                  keyboardType: TextInputType.number,
                  onChanged: (value) =>
                      setState(() => _averagePeriod = int.parse(value)),
              ),
              // CheckboxListTile(
              //     value: _reminder,
              //     onChanged: (value) => setState(() => _reminder = value!),
              //     title: Text('Reminder'),
              // ),
                         SizedBox(height: 16),
                        ElevatedButton(
                       onPressed: () {
                         ovulationdate();
                         showDialog(
                        context: context,
                        builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Ovulation date'),
                          content: Text(DateFormat.yMMMMd().format(ovulationDate)),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text('Close'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                  ,
                  child: Text('Calculate'),
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
