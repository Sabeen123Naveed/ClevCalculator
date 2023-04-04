

import 'dart:io';

import 'package:flutter/material.dart';

class Help extends StatefulWidget {
  const Help({Key? key}) : super(key: key);

  @override
  State<Help> createState() => _HelpState();
}

class _HelpState extends State<Help> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
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
                            onPressed: () =>  exit(0),
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
