import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../admob/admob_testingids.dart';
import '../buttons.dart';


class LoanCalculator extends StatefulWidget {
  @override
  _LoanCalculatorState createState() => _LoanCalculatorState();
}

class _LoanCalculatorState extends State<LoanCalculator> with TickerProviderStateMixin {
  double _loanAmount = 0;
  int _loanPeriod = 0;
  double _interestRate = 0;
  double _totalInterest = 0;
  double _totalPayment = 0;
  double _monthlyPayment = 0;
  double remainingbalance = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  AnimationController? _animationController;
  Animation<Offset>? _animation;
  List<Map<String, dynamic>> _monthlyData = [];
  final TextEditingController Loanamount = TextEditingController();
  final TextEditingController loanperiod= TextEditingController();
  final TextEditingController InterestRate = TextEditingController();
  final TextEditingController InterestonlyPeriod = TextEditingController();
  FocusNode _firstFocusNode = FocusNode();
  FocusNode _secondFocusNode = FocusNode();
  FocusNode _thirdFocusNode = FocusNode();


  void _calculate() {
    setState(() {
      _totalInterest = _loanAmount * (_interestRate / 100) * (_loanPeriod / 12);
      _totalPayment = _loanAmount + _totalInterest;
      remainingbalance = _totalPayment;
      _monthlyData = [];
      for(int i = 0; i<_loanPeriod; i++)
      {
        _monthlyPayment = _totalPayment / _loanPeriod;
        remainingbalance -= _monthlyPayment;
        _monthlyData.add({
          'month': i + 1,
          'monthlyPayment': _monthlyPayment,
          'remainingBalance': remainingbalance,
        });

        print("${i}  ${_monthlyPayment}  ${ remainingbalance }");


      }
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
    await prefs.setInt('lastScreenIndex', 9);// Set a key-value pair to indicate that the app is resumed
  }

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
          child: Scaffold(
            key: _scaffoldKey,
              drawer: MyDrawer(),
              appBar: AppBar(
                title: Text('Loan Calculator'),
                actions: [
                  IconButton(
                      onPressed: (){
                        setState(() {
                           _loanAmount = 0;
                           _loanPeriod = 0;
                           _interestRate = 0;
                           _totalInterest = 0;
                           _totalPayment = 0;
                           _monthlyPayment = 0;
                           remainingbalance = 0;
                           Loanamount.clear();
                           loanperiod.clear();
                           InterestRate.clear();
                           InterestonlyPeriod.clear();
                           _monthlyData = [];
                           _firstFocusNode.requestFocus();
                        });

                      },
                      icon: Icon(Icons.delete)
                  ),
                  IconButton(
                    icon: Icon(Icons.share),
                    onPressed: () {
                      Share.share(
                          ' Loan Amount : ${_loanAmount}\n'
                              'Loan Period (in months): ${ _loanPeriod}\n'
                              ' Interest Rate (%) : ${_interestRate}\n'
                              'Total Interest: ${_totalInterest.toStringAsFixed(2)} \n'

                              'Total Payment: ${_totalPayment.toStringAsFixed(2)} '

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
              body: SingleChildScrollView(
                child: WillPopScope(
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
                              child: SlideTransition(
                                position: _animation!,
                                    child: Column(
                                      children: [
                                        TextField(
                                            controller: Loanamount,
                                            focusNode: _firstFocusNode,
                                            decoration: InputDecoration(
                                              hintText: 'Loan Amount',
                                            ),
                                           // keyboardType: TextInputType.number,
                                            onChanged: (value) {
                                              _loanAmount = double.parse(value);
                                            },
                                          ),
                                    TextField(
                                          controller: loanperiod,
                                      focusNode: _secondFocusNode,
                                          decoration: InputDecoration(
                                            hintText: 'Loan Period (in months)',
                                          ),
                                         // keyboardType: TextInputType.number,
                                          onChanged: (value) {
                                            _loanPeriod = int.parse(value);
                                          },
                                        ),

                                        TextField(
                                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.,]+')),],

                                            controller: InterestRate,
                                          focusNode: _thirdFocusNode,
                                            decoration: InputDecoration(
                                              hintText: 'Interest Rate (%)',
                                            ),
                                            onChanged: (value) {
                                              setState(() {
                                                if (value.isNotEmpty && !value.endsWith("%")) {
                                                  InterestRate.text = value + "%";
                                                  // Set the cursor position after the last entered digit
                                                  InterestRate.selection = TextSelection.fromPosition(
                                                      TextPosition(offset: InterestRate.text.length - 1));
                                                }
                                                String valueWithoutPercent = value.replaceAll("%", "");
                                                _interestRate = double.tryParse(valueWithoutPercent) ?? 0.0;

                                              });
                                              // _interestRate = double.parse(value);
                                            },
                                          ),

                                        SizedBox(
                                          height: 15,
                                        ),

                                        ElevatedButton(
                                            onPressed: () {
                                              // Remove the focus from the text field and hide the keyboard
                                              FocusScope.of(context).unfocus();
                                              _calculate();
                                            },

                                          child: Text('Calculate'),
                                        ),

                                        SizedBox(
                                          height: 5,
                                        ),
                                       Text(
                                          'Total Interest: ${_totalInterest.toStringAsFixed(2)}',
                                          style: TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                            'Total Payment: ${_totalPayment.toStringAsFixed(2)}',
                                            style: TextStyle(
                                              fontSize: 20,
                                            ),

                                          ),

                                        SizedBox(
                                          height: 16,
                                        ),
                                        Table(
                                          border: TableBorder.all(),
                                          children: [
                                            TableRow(
                                              decoration: BoxDecoration(color: Colors.grey[200]),
                                              children: [
                                                TableCell(
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Text('Month'),
                                                  ),
                                                ),
                                                TableCell(
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Text('Monthly Payment'),
                                                  ),
                                                ),
                                                TableCell(
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Text('Remaining Balance'),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            for (var data in _monthlyData)
                                              TableRow(
                                                children: [
                                                  TableCell(
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text(data['month'].toString()),
                                                    ),
                                                  ),
                                                  TableCell(
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text(data['monthlyPayment'].toStringAsFixed(2)),
                                                    ),
                                                  ),
                                                  TableCell(
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text(data['remainingBalance'].toStringAsFixed(2)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                          ],
                                        ),

                                        // Expanded(
                                        //   child: ListView.builder(
                                        //       itemCount: _monthlyData.length,
                                        //       itemBuilder: (context, index) {
                                        //         return Container(
                                        //           margin: EdgeInsets.only(bottom: 16),
                                        //           child: Column(
                                        //             mainAxisAlignment: MainAxisAlignment.start,
                                        //             crossAxisAlignment: CrossAxisAlignment.start,
                                        //             children: [
                                        //               Text("Month    Monthly Payment     Remaining Balance"),
                                        //               Text('  ${_monthlyData[index]['month']}              ${_monthlyData[index]['monthlyPayment'].toStringAsFixed(2)}                  ${_monthlyData[index]['remainingBalance'].toStringAsFixed(2)}'),
                                        //
                                        //             ],
                                        //           ),
                                        //         );
                                        //       },
                                        //     ),
                                        // ),
                                      ],
                                    ),
                                  ),

                              ),
                ),
              ),
                        ),


    );
  }
}

