
// import 'package:flutter/material.dart';
// import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:hive/hive.dart';
// import 'package:intl/intl.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:scientificcal/DateCalculator/modelclass.dart';
// import '../admob/admob_testingids.dart';
// import '../buttons.dart';
//
//
// class DateCalculator extends StatefulWidget {
//
//   @override
//   _DateCalculatorState createState() => _DateCalculatorState();
// }
// class _DateCalculatorState extends State<DateCalculator> with TickerProviderStateMixin {
//   late BannerAd _bannerAd;
//   bool isBannerAdLoaded = false;
//   // List<Model> list = [];
//   final GlobalKey<AnimatedListState> _key = GlobalKey();
//   bool _showHintText = true;
//
//
//   // initBannerAd() {
//   //   _bannerAd = BannerAd(size: AdSize.banner,
//   //     adUnitId: AdmobManager.banner_id,
//   //     request: AdRequest(),
//   //     listener: BannerAdListener(onAdLoaded: (Ad ad) {
//   //       setState(() {
//   //         isBannerAdLoaded = true;
//   //       });
//   //     },
//   //         onAdFailedToLoad: (Ad ad, LoadAdError error) {
//   //           ad.dispose();
//   //           print("HelloAds Ad failed to load : $error");
//   //         },
//   //         onAdOpened: (Ad ad) {
//   //           return print("HelloAds Ad opened");
//   //         }
//   //     ),
//   //   );
//   //   _bannerAd.load();
//   // }
//
//   @override
//   void initState() {
//     super.initState();
//
//     // initBannerAd();
//     setState(() {
//       dateBox = Hive.box<Model>("date box");
//       dateController.text = "";
//     });
//   }
//
//   @override
//   void disposeState() {
//     super.dispose();
//     //
//     // _bannerAd.dispose();
//   }
//
//   Box<Model>? dateBox;
//   final TextEditingController eventController = TextEditingController();
//   final TextEditingController dateController = TextEditingController();
//
//   _deleteInfo(int index) {
//     dateBox!.deleteAt(index);
//     print('Item deleted from box at index: $index');
//   }
//   String _difference = '';
//   void _calculateDifference() {
//     final userInput = dateController.text;
//     final userDate = DateFormat('yyyy-MM-dd').parse(userInput);
//     final currentDate = DateTime.now();
//     final difference = currentDate.difference(userDate);
//
//
//     setState(() {
//       _difference = ' ${difference.inDays} ';
//       if (difference.isNegative) {
//         print("${_difference} days left");
//       }
//
//
//       print('.................${_difference}');
//     });
//   }
//
//   // void removeItem(int index, BuildContext context) {
//   //   dateBox!.deleteAt(index);
//   //   print('Item deleted from box at index: $index');
//   //   AnimatedList.of(context).removeItem(index, (context, animation) {
//   //     const Duration(seconds: 100);
//   //     return FadeTransition(
//   //       opacity: animation,
//   //       child: SizeTransition(
//   //         sizeFactor: animation,
//   //         child: Card(
//   //           elevation: 0.7,
//   //           color: Colors.indigo,
//   //
//   //           shape: RoundedRectangleBorder(
//   //             borderRadius: BorderRadius.circular(16),
//   //             side: BorderSide(
//   //               color: Colors.indigo,
//   //
//   //             ),
//   //           ),
//   //           child: ListTile(
//   //             title: Text(list[index].eventname,
//   //               style: TextStyle(fontSize: 20,
//   //                   fontWeight: FontWeight
//   //                       .bold),),
//   //             subtitle: Text(list[index].date,
//   //               style: TextStyle(fontSize: 15,),),
//   //             trailing: Text(
//   //                 '${list[index].days} days'),
//   //             leading: IconButton(
//   //               onPressed: () {
//   //                 _deleteInfo(index);
//   //                 removeItem(index, context);
//   //               },
//   //               icon: Icon(
//   //                 Icons.delete,
//   //                 color: Colors.indigo,
//   //               ),
//   //             ),
//   //           ),
//   //         ),
//   //       ),
//   //     );
//   //   }
//   //   );
//   // }
//   void _hideHintText() {
//     setState(() {
//       _showHintText = false;
//     });
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//         child: Scaffold(
//           drawer: MyDrawer(),
//           appBar: AppBar(
//             title: Text("Date Calculator"),
//
//           ),
//           // bottomNavigationBar: isBannerAdLoaded ?
//           // Container(
//           //   padding: EdgeInsets.symmetric(vertical: 5),
//           //   width: _bannerAd.size.width.toDouble(),
//           //   height: _bannerAd.size.height.toDouble(),
//           //   child: AdWidget(ad: _bannerAd),
//           //
//           //
//           // ) : SizedBox(),
//
//           body: Column(
//             children: [
//               // if (_showHintText)
//               //    Padding(
//               //      padding: const EdgeInsets.only(top:270),
//               //      child: Text(
//               //         'Click on the Floating Action Button to add data',
//               //         style: TextStyle(fontSize: 15, color: Colors.grey),
//               //       ),
//               //    ),
//               ValueListenableBuilder(
//                   valueListenable: dateBox!.listenable(),
//                   builder: (context, Box<Model> dateBox, _) {
//                     List<Model> list = [];
//                     dateBox.values.forEach((Model element) {
//                       list.add(element);
//                       print("Print : element  ${element.eventname.toString()}");
//                       print("Print : element  ${element.date.toString()}");
//                       print("Print : element  ${element.days.toString()}");
//                     });
//
//                     return Expanded(
//                         child: Padding(
//                             padding: const EdgeInsets.all(3.0),
//                             child: AnimationLimiter(
//                               child: AnimatedList(
//                                   key: _key,
//                                   initialItemCount: list.length,
//                                   itemBuilder: (((context, index, animation) {
//                                     return AnimationConfiguration.staggeredList(
//                                         position: index,
//                                         duration: const Duration(
//                                             milliseconds: 375),
//                                         child: SlideAnimation(
//                                             verticalOffset: 150.0,
//                                             child: FadeInAnimation(
//                                               child: FadeTransition(
//                                                   opacity: animation,
//                                                   child: SizeTransition(
//                                                     key: UniqueKey(),
//                                                     sizeFactor: animation,
//                                                     child: Card(
//                                                         elevation: 0.7,
//                                                         shadowColor: Colors
//                                                             .indigo,
//                                                         shape: RoundedRectangleBorder(
//                                                           borderRadius: BorderRadius
//                                                               .circular(
//                                                               16),
//                                                           side: BorderSide(
//                                                             color: Colors
//                                                                 .indigo,
//                                                           ),
//                                                         ),
//
//                                                         child: Column(
//                                                           children: [
//                                                             ListTile(
//                                                               title: Text(
//                                                                 list[index]
//                                                                     .eventname,
//                                                                 style: TextStyle(
//                                                                     fontSize: 20,
//                                                                     fontWeight: FontWeight
//                                                                         .bold),),
//                                                               subtitle: Text(
//                                                                 list[index]
//                                                                     .date,
//                                                                 style: TextStyle(
//                                                                   fontSize: 15,),),
//                                                               trailing: Text(
//                                                                   '${list[index]
//                                                                       .days} days'),
//                                                               leading: IconButton(
//                                                                 onPressed: () {
//                                                                    _deleteInfo(index);
//                                                                   // removeItem(
//                                                                   //     index,
//                                                                   //     context);
//                                                                 },
//                                                                 icon: Icon(
//                                                                   Icons.delete,
//                                                                   color: Colors
//                                                                       .indigo,
//                                                                 ),
//                                                               ),
//
//                                                             ),
//
//
//                                                           ],
//                                                         )
//                                                     ),
//                                                   )
//                                               ),
//                                             )
//                                         )
//                                     );
//
//                                     //  )
//                                   }
//                                   )
//
//                                   )
//                               ),
//                             )
//                         )
//
//
//                     );
//                   }
//               )
//
//             ],
//           ),
//           floatingActionButton: FloatingActionButton(
//             onPressed: () {
//               _hideHintText();
//               showDialog(
//                   context: context, builder: (_) {
//                 return Dialog(
//                     child: Container(
//                       padding: EdgeInsets.all(16),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           TextField(
//                             decoration: InputDecoration(
//                                 hintText: "Enter Event Name"),
//                             controller: eventController,
//
//                           ),
//                           SizedBox(
//                             height: 8,
//                           ),
//                           TextFormField(
//                             decoration: InputDecoration(
//                                 hintText: "Date  (yyyy-MM-dd)"),
//                             readOnly: true,
//                             controller: dateController,
//                             onTap: () async {
//                               DateTime? pickedDate = await showDatePicker(
//                                   context: context,
//                                   initialDate: DateTime.now(),
//                                   firstDate: DateTime(1950),
//                                   //DateTime.now() - not to allow to choose before today.
//                                   lastDate: DateTime(2100));
//
//                               if (pickedDate != null) {
//                                 print(
//                                     pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
//                                 String formattedDate =
//                                 DateFormat('yyyy-MM-dd').format(pickedDate);
//                                 print(
//                                     formattedDate); //formatted date output using intl package =>  2021-03-16
//                                 dateController.text = formattedDate;
//                                 //   print('dateeeeeeeeeeeeeeeeeeeee  ${dateController.text}');
//
//                                 //set output date to TextField value.
//
//                               } else {
//
//                               }
//                             },
//
//
//                           ),
//                           SizedBox(
//                             height: 8,
//                           ),
//                           TextButton(
//                             child: Text("Add "),
//                             onPressed: () {
//                               _calculateDifference();
//                               dateBox!.put(
//                                 "", Model(  //${DateTime.now().toString()} in double quoted commas
//                                 eventname: eventController.text.toString(),
//                                 date: dateController.text.toString(),
//                                 days: _difference.toString(),
//                               ),
//
//                               );
//                               _key.currentState!.insertItem(
//                                   0, duration: const Duration(seconds: 1));
//                               Navigator.pop(context);
//
//                             },
//                           )
//
//                         ],
//                       ),
//                     )
//                 );
//               }
//               );
//             },
//             child: Icon(Icons.add),
//           ), // This trailing comma makes auto-formatting nicer for build methods.
//         )
//     );
//   }
// }


import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';

import '../buttons.dart';
import 'modelclass.dart';


class DateCalculator extends StatefulWidget {
  const DateCalculator({Key? key}) : super(key: key);

  @override
  State<DateCalculator> createState() => _DateCalculatorState();
}

class _DateCalculatorState extends State<DateCalculator> {
  Box<Model>? dateBox;
  final TextEditingController eventController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _difference = '';

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
        child:  Scaffold(
            key:  _scaffoldKey,
              drawer: MyDrawer(),
              appBar: AppBar(
                title: Text("Date Calculator"),
              ),
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
                child: Column(
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
                            if (dateBox.isEmpty) {
                              return Padding(
                                padding: const EdgeInsets.only(top:280),
                                child: Center(
                                  child: Text('Click on the plus icon to add data',
                                    style: TextStyle(color: Colors.grey,fontSize: 20),),
                                ),
                              );
                            }
                            else {
                              return Expanded(
                                child: ListView.builder(
                                    itemCount: list.length,
                                    itemBuilder: (context, index) {
                                      return AnimationLimiter(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: AnimationConfiguration
                                              .staggeredList(
                                              position: index,
                                              duration: const Duration(
                                                  milliseconds: 375),
                                              child: SlideAnimation(
                                                  verticalOffset: 150.0,
                                                  child: FadeInAnimation(
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
                                                                  _deleteInfo(
                                                                      index);
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
                                                  )
                                              )
                                          ),
                                        ),
                                      );
                                    }
                                ),
                              );
                            }
                          }
                      )


                    ]
                ),
              ),



              floatingActionButton: FloatingActionButton(
                onPressed:(){

                  ShowDialog();
                },
                child: Icon(Icons.add),
              )
          ),

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













