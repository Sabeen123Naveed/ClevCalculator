import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:scientificcal/buttons.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<void> _saveAppState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lastScreenIndex', 12);// Set a key-value pair to indicate that the app is resumed
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
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.,]+')),],

                        focusNode: _secondFocusNode,
                       controller: InterestRate,
                        onChanged: (value) {
                          setState(() {
                            if (value.isNotEmpty && !value.endsWith("%")) {
                              InterestRate.text = value + "%";
                              // Set the cursor position after the last entered digit
                              InterestRate.selection = TextSelection.fromPosition(
                                  TextPosition(offset: InterestRate.text.length - 1));
                            }
                            String valueWithoutPercent = value.replaceAll("%", "");
                            _interestRate   = double.tryParse(valueWithoutPercent) ?? 0.0;

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
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.,]+')),],

                        decoration: InputDecoration(labelText: 'Interest Income Tax Rate'),
                        focusNode: _fourthFocusNode,
                        controller: tax,
                        onChanged: (String value) {
                          setState(() {
                            if (value.isNotEmpty && !value.endsWith("%")) {
                              tax.text = value + "%";
                              // Set the cursor position after the last entered digit
                              tax.selection = TextSelection.fromPosition(
                                  TextPosition(offset: tax.text.length - 1));
                            }
                            String valueWithoutPercent = value.replaceAll("%", "");
                            _interestIncomeTaxRate   = double.tryParse(valueWithoutPercent) ?? 0.0;

                          });

                        },
                      ),
                      SizedBox(height:10),
                      ElevatedButton(

                        onPressed: () {

                          setState(() {
                            _calculateInterest();
                          });
                        },
                        child: Text('Calculate'),
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
