//HIve data base code without animations

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';

import '../buttons.dart';
import 'DateCalculator/modelclass.dart';

class DateCalculator extends StatefulWidget {
  const DateCalculator({Key? key}) : super(key: key);

  @override
  State<DateCalculator> createState() => _DateCalculatorState();
}

class _DateCalculatorState extends State<DateCalculator> {
  Box<Model>? dateBox;
  final TextEditingController eventController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  String _difference = '';
  final GlobalKey<AnimatedListState> _key = GlobalKey();
  @override
  void initState() {
    super.initState();

    setState(() {
      dateBox = Hive.box<Model>("date box");

    });
  }
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
        child: Scaffold(
            drawer: MyDrawer(),
            appBar: AppBar(
              title: Text("Date Calculator"),
            ),
            body: Column(
                children:  [
                  ValueListenableBuilder(
                      valueListenable: dateBox!.listenable(),
                      builder: (context, Box<Model> dateBox, _) {
                        List<Model> list = [];
                        dateBox.values.forEach((Model element) {
                          list.add(element);
                          print("Print : element  ${element.eventname.toString()}");
                          print("Print : element  ${element.date.toString()}");
                          print("Print : element  ${element.days.toString()}");
                        });
                        return Expanded(
                          child: ListView.builder(
                              itemCount: list.length,
                              itemBuilder: (context, index) {
                            return Padding(
                                padding: const EdgeInsets.all(8.0),

                              child: Card(
                                  elevation: 0.7,
                                  shadowColor: Colors
                                      .indigo,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius
                                        .circular(
                                        16),
                                    side: BorderSide(
                                      color: Colors
                                          .indigo,
                                    ),
                                  ),

                                  child: Column(
                                    children: [
                                      ListTile(
                                        title: Text(
                                          list[index]
                                              .eventname,
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight
                                                  .bold),),
                                        subtitle: Text(
                                          list[index]
                                              .date,
                                          style: TextStyle(
                                            fontSize: 15,),),
                                        trailing: Text(
                                            '${list[index]
                                                .days} days'),
                                        leading: IconButton(
                                          onPressed: () {
                                            _deleteInfo(index);

                                          },
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors
                                                .indigo,
                                          ),
                                        ),

                                      ),


                                    ],
                                  )
                              ),
                            );
                              }
                          ),
                        );
                      }
                  )


                ]
            ),



            floatingActionButton: FloatingActionButton(
              onPressed:(){
                ShowDialog();
              },
              child: Icon(Icons.add),
            )
        )
    );

  }
  void ShowDialog(){
    showDialog(
        context: context, builder: (_) {
      return Dialog(
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(
                      hintText: "Enter Event Name"),
                  controller: eventController,

                ),
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      hintText: "Date  (yyyy-MM-dd)"),
                  readOnly: true,
                  controller: dateController,
                  onTap: ()  {
                    datepicker();
                  },
                ),
                SizedBox(
                  height: 8,
                ),
                TextButton(
                  child: Text("Add "),
                  onPressed: () {
                    _calculateDifference();
                    final String event =  eventController.text.toString();
                    final String date = dateController.text.toString();
                    eventController.clear();
                    dateController.clear();
                    dateBox!.put(
                      "${DateTime.now().toString()}", Model(  //${DateTime.now().toString()} in double quoted commas
                      eventname:  event,
                      date: date,
                      days: _difference.toString(),
                    ),

                    );
                    Navigator.pop(context);


                  },
                )

              ],
            ),
          )
      );
    }
    );
  }
  Future<void> datepicker() async{
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950),
        //DateTime.now() - not to allow to choose before today.
        lastDate: DateTime(2100));

    if (pickedDate != null) {
      print(
          pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
      String formattedDate =
      DateFormat('yyyy-MM-dd').format(pickedDate);
      print(
          formattedDate); //formatted date output using intl package =>  2021-03-16
      dateController.text = formattedDate;

    }
  }
  void _calculateDifference() {
    final userInput = dateController.text;
    final userDate = DateFormat('yyyy-MM-dd').parse(userInput);
    final currentDate = DateTime.now();
    final difference = currentDate.difference(userDate);


    setState(() {
      _difference = ' ${difference.inDays} ';
      if (difference.isNegative) {
        print("${_difference} days left");
      }


      print('.................${_difference}');
    });
  }
  _deleteInfo(int index) {
    dateBox!.deleteAt(index);
    print('Item deleted from box at index: $index');
  }

}






