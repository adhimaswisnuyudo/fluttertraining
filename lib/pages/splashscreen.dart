
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:training/pages/login.dart';
import 'package:training/helpers/mycolors.dart' as mycolor;

class SplashScreen extends StatefulWidget{
  @override
  _SplashScreenState createState()=> _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>{
  @override
  void initState(){
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
    redirect();
  }

  void redirect(){
    Timer(Duration(seconds: 2),()=>
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder:(context)=>
            Login())
        )
    );
  }


  Widget build(BuildContext){
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeigth = MediaQuery.of(context).size.height;
    double containerWidth = deviceWidth * 0.8;

    return Scaffold(
      backgroundColor: mycolor.WARNAUTAMA,
      body: Center(
        child: Container(
          padding: EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset("assets/images/logoinix.png",
                  width: containerWidth,
                  height: 100
              ),
              SizedBox(height: 10),
              Text("Mobile Apps 2.0",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                    letterSpacing: 0.8),
              ),
              SizedBox(height: 30),
              SpinKitCircle(
                color: Colors.white,
                size: 30.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}