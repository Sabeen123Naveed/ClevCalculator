import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:scientificcal/buttons.dart';
import 'package:share/share.dart';

import '../admob/admob_testingids.dart';
class SavingsCalculator extends StatefulWidget {
  double targetAmount = 0.0;
  @override
  _SavingsCalculatorState createState() => _SavingsCalculatorState();
}

class _SavingsCalculatorState extends State<SavingsCalculator> with TickerProviderStateMixin {
  final TextEditingController TargetAmount = TextEditingController();
  final TextEditingController InterestRate= TextEditingController();
  final TextEditingController SavingsPeriod = TextEditingController();
  final TextEditingController tax= TextEditingController();
  String _selectedOption = 'simple interest';
  double targetAmount = 0.0;
  double _interestRate = 0.0;
  int _savingsPeriod = 0;
  double _interestIncomeTaxRate = 0.0;
  double _compoundInterest = 0.0;
  double _interestAfterTax = 0.0;
  double _requiredDeposit = 0.0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  AnimationController? _animationController;
  Animation<Offset>? _animation;
  FocusNode _firstFocusNode = FocusNode();
  FocusNode _secondFocusNode = FocusNode();
  FocusNode _thirdFocusNode = FocusNode();
  FocusNode _fourthFocusNode = FocusNode();
  void _calculateInterest() {
    switch (_selectedOption) {
      case 'simple interest':
        _compoundInterest  = targetAmount * (_interestRate / 100) * (_savingsPeriod / 12);
        break;
      case 'compounded monthly':
        _compoundInterest = targetAmount * pow((1 + _interestRate / (12 * 100)), (_savingsPeriod * 12)) - targetAmount;
        break;
      case 'compounded quarterly':
        _compoundInterest = targetAmount * pow((1 + _interestRate / (4 * 100)), (_savingsPeriod * 4)) - targetAmount;
        break;
      case 'compounded half-yearly':
        _compoundInterest = targetAmount * pow((1 + _interestRate / (2 * 100)), (_savingsPeriod * 2)) - targetAmount;
        break;
      case 'compounded yearly':
        _compoundInterest = targetAmount * pow((1 + _interestRate / 100), _savingsPeriod) - targetAmount;
        break;
    }
    _interestAfterTax = _compoundInterest * (1 - _interestIncomeTaxRate / 100);
    _requiredDeposit = targetAmount / (_savingsPeriod * 12);
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
      duration: Duration(milliseconds: 1100),
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
            title: Text('Savings Calculator'),
              actions: [
                IconButton(
                    onPressed: (){
                      setState(() {
                         targetAmount = 0.0;
                         _interestRate = 0.0;
                        _savingsPeriod = 0;
                         _interestIncomeTaxRate = 0.0;
                        _compoundInterest = 0.0;
                         _interestAfterTax = 0.0;
                        _requiredDeposit = 0.0;
                        TargetAmount.clear();
                        InterestRate.clear();
                        SavingsPeriod.clear();
                        tax.clear();
                         _firstFocusNode.requestFocus();

                      });

                    },
                    icon: Icon(Icons.delete)
                ),
                IconButton(
                  icon: Icon(Icons.share),
                  onPressed: () {
                    Share.share(
                        'Target Amount:  ${targetAmount} \n'
                            'Interest Rate:  ${_interestRate}\n'
                            'Savings Period (in months):  ${_savingsPeriod} \n'
                            'Interest Income Tax Rate:  ${_interestIncomeTaxRate} \n'
                               "\n"
                              "Calculated Values are : \n"
                               "\n"
                            "Simple Interest:  ${_compoundInterest.toStringAsFixed(4)}\n"
                            ' Interest After Tax:  ${_interestAfterTax.toStringAsFixed(4)}\n'
                            ' Required Deposit:  ${_requiredDeposit.toStringAsFixed(4)}\n'


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
                          onPressed: () => exit(0),
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
              child: SingleChildScrollView(
                child:  SlideTransition(
                  position: _animation!,
                  child: Column(
                    children: [
                      DropdownButton<String>(
                        value: _selectedOption,
                        items: <String>['simple interest', 'compounded monthly', 'compounded quarterly', 'compounded half-yearly', 'compounded yearly']
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            _selectedOption = value!;
                          });
                        },
                      ),
                      TextField(
                        decoration: InputDecoration(labelText: 'Target Amount'),
                        focusNode: _firstFocusNode,
                       controller: TargetAmount,
                        onChanged: (String value) {
                          setState(() {
                            targetAmount = double.parse(value);
                          });
                        },
                      ),
                      TextField(
                        decoration: InputDecoration(labelText: 'Interest Rate'),
                        focusNode: _secondFocusNode,
                       controller: InterestRate,
                        onChanged: (value) {
                          setState(() {
                            if (!InterestRate.text.endsWith("%")) {
                              InterestRate.text = value + "%";
                            }
                            _interestRate = double.parse(value);
                          });
                        },

                      ),
                      TextField(
                        decoration: InputDecoration(labelText: 'Savings Period (in months)'),
                        focusNode: _thirdFocusNode,
                        controller: SavingsPeriod,
                        onChanged: (String value) {
                          setState(() {
                            _savingsPeriod = int.parse(value);
                          });
                        },
                      ),
                      TextField(
                        decoration: InputDecoration(labelText: 'Interest Income Tax Rate'),
                        focusNode: _fourthFocusNode,
                        controller: tax,
                        onChanged: (String value) {
                          setState(() {
                            if (!tax.text.endsWith("%")) {
                              tax.text = value + "%";
                            }
                            _interestIncomeTaxRate = double.parse(value);
                          });
                        },
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 16.0),
                        child: TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.cyan,
                              padding: EdgeInsets.all(18)
                          ),
                          child: Text('Calculate'),
                          onPressed: () {
                            _calculateInterest();
                            setState(() {});
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 16.0),
                     child: Text(
                         _selectedOption == 'simple interest' ?
                         "Simple Interest: ${_compoundInterest.toStringAsFixed(4)}" :'Compound Interest: ${_compoundInterest.toStringAsFixed(4)}',
                            ),
                      ),

                      Container(
                        margin: EdgeInsets.only(top: 16.0),
                        child: Text('Interest After Tax: ${_interestAfterTax.toStringAsFixed(4)}'),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 16.0),
                        child: Text('Required Deposit: ${_requiredDeposit.toStringAsFixed(4)}'),
                      ),
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
