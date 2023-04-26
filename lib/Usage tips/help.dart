

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../buttons.dart';

class Help extends StatefulWidget {
  const Help({Key? key}) : super(key: key);

  @override
  State<Help> createState() => _HelpState();
}

class _HelpState extends State<Help> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Future<void> _saveAppState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lastScreenIndex', 15);// Set a key-value pair to indicate that the app is resumed
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
            drawer: MyDrawer(),
            appBar: AppBar(
              title: Text('Help'),
              centerTitle: true,
              elevation: 0.0,
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
              child: Center(
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10),

                  width: 500,
                  height: 200,
                  color: Colors.grey,
                  child: Text(" Press and hold the number input from any where in the app and use can use the Calculator.."
                    ,style: TextStyle(fontSize: 25 , fontWeight: FontWeight.bold),),
                ),
              ),
            )
        ),

    );
  }
}
