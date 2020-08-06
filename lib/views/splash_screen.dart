import 'dart:async';

import 'package:TakeNote/utils/navigation.dart';
import 'package:TakeNote/views/all_task.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() { 
    super.initState();
    Timer(const Duration(seconds: 4), () {
      pushUntil(context, const AllTasks());
    });  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Image.asset('assets/images/file.png', height: 100.0, width: 100.0),
          ),

          const Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'TakeNote',
                style: TextStyle(letterSpacing: 1.0, fontSize: 20.0)
              ),
            ),
          )
        ],
      ),
    );
  }
}