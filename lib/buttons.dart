import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scientificcal/hexadecimalcalculator/hexadecimalcal.dart';
import 'package:scientificcal/percentage%20calculator/percentagecalculator.dart';
import 'package:scientificcal/unitpricecalculator/unitprice.dart';
import 'DateCalculator/datecalculator.dart';
import 'DiscountCalculator/discountcalculator.dart';
import 'Fuelefficiencycalculator/fuelefficiency.dart';
import 'HealthCalculator/health calculator.dart';
import 'Savingscalculator/savingscal.dart';
import 'Tip Calculator/tipcalculator.dart';
import 'UnitConverter/unitconverter.dart';
import 'Usage tips/help.dart';
import 'ValueAddedTaxCalculator/VAT calculator.dart';
import 'basiccalculator/scientificcalculator.dart';
import 'fuelcostcalculator/fuelcostcalculator.dart';
import 'loanCalculator/loancalculator.dart';
import 'ovulution calculator/ovulution calculator.dart';

class MyButton extends StatelessWidget {
  final String title;
  final VoidCallback onPress;
  final Color color;
  final Color textColor;
  // final TextStyle textStyle = TextStyle(fontWeight: FontWeight.bold)

  const MyButton({Key? key, required this.title, this.color = Colors.white, this.textColor = Colors.black, required this.onPress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Expanded(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: InkWell(
            onTap: onPress,
            child: Container(
              height: 60,
              width: 40,
              color: color,
              child: Center(child: Text(title, style: TextStyle(fontSize: 20, color: textColor),)),
            ),
          ),
        ),

    );
  }
}

// For List Tile In Drawer
class MyListTile extends StatelessWidget {
  final VoidCallback onPress;
  final String title;
  const MyListTile({Key? key, required this.onPress, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return ListTile(
      onTap: onPress,
      title: Text(title, style: TextStyle(fontSize: 17),),
    );
  }
}
class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
                    child: ListView(
                    children: [
                      Container(
                        height: 200,
                        child: DrawerHeader(
                            decoration: BoxDecoration(
                              color: Colors.black87,
                            ),
                            child: Column(
                              children: [
                                ListTile(
                                  onTap: (){

                                  },
                                  leading: Icon(Icons.settings, color: Colors.white,),
                                  title: Text("Settings", style: TextStyle(color: Colors.white, fontSize: 15),),
                                ),
                                ListTile(
                                  onTap: (){},
                                  leading: Icon(Icons.lock_open, color: Colors.white,),
                                  title: Text("Remove Ads", style: TextStyle(color: Colors.white, fontSize: 15),),
                                ),
                                ListTile(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) =>Help()));
                                  },
                                  leading: Icon(Icons.question_mark_rounded, color: Colors.white,),
                                  title: Text("Usage tips", style: TextStyle(color: Colors.white, fontSize: 15),),
                                ),
                              ],
                            )
                        ),
                      ),

                     Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Favourites", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),),
                      ),
                      MyListTile(onPress: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ScientificCalculator()));
                      }, title: "Basic Calculator",),
                      MyListTile(onPress: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => UnitConverter()));
                      }, title: "Unit Converter",),
                      MyListTile(onPress: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) =>  DiscountCalculator()));
                      }, title: "Discount Calculator",),
                      MyListTile(onPress: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) =>  TipCalculator()));
                      }, title: "Tip Calculator",),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("All Calculators", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),),
                      ),
                      MyListTile(onPress: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => DateCalculator()));
                      }, title: "Date Calculator",),
                      MyListTile(onPress: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => FuelForm()));
                      }, title: "Fuel Cost Calculator",),
                      MyListTile(onPress: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => FuelEfficencyCalculator()));
                      }, title: "Fuel Efficiency Calculator",),
                      MyListTile(onPress: (){
                         Navigator.push(context, MaterialPageRoute(builder: (context) => BMICalculator()));
                      }, title: "BMI Calculator",),
                      MyListTile(onPress: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => HexCalculator()));
                      }, title: "Hexadecimal Calculator",),
                      MyListTile(onPress: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => LoanCalculator()));
                      },
                        title: "Loan Calculator",),
                      MyListTile(onPress: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => OvulationCalculator()));
                      }, title: "Ovulation Calculator",),
                      MyListTile(onPress: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => PercentageCalculator()));
                      }, title: "Percentage Calulator",),
                      MyListTile(onPress: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SavingsCalculator()));
                      }, title: "Savings Calculator",),
                      MyListTile(onPress: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => UnitPrice()));
                      }, title: "Unit Price Calculator",),
                      MyListTile(onPress: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => VatCalculator()));
                      }, title: "VAT Calculator",),
                      ]
                    )
      );


  }
}

