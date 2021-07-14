import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:training/helpers/mycolors.dart' as mycolor;

import 'home.dart';

class Login extends StatefulWidget{
  @override
  _LoginState createState()=> _LoginState();
}

class _LoginState extends State<Login>{
  bool hidePassword = true;
  TextEditingController usernameCtrl = new TextEditingController();
  TextEditingController passwordCtrl = new TextEditingController();
  late DateTime currentBackPressTime;

  void loginAction(){
    String username = usernameCtrl.text??"";
    String password = passwordCtrl.text??"";
    Navigator.pushReplacement(context,PageTransition(type: PageTransitionType.bottomToTop,child: Home()));
  }


  Widget build(BuildContext context){
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: mycolor.WARNAUTAMA,
      body: WillPopScope(
        onWillPop: onWillPop,
        child: ListView(
          children: <Widget>[
            Center(
              child: Column(
                children: [
                  SizedBox(height: 50,),
                  Image.asset("assets/images/logoinix.png",width: (0.8 * deviceWidth),),
                  SizedBox(height: 25),
                  Container(
                    width: (deviceWidth * 0.8),
                    padding: EdgeInsets.only(
                      top:20,bottom: 20,right: 10,left: 10
                    ),
                    decoration: BoxDecoration(
                      color: Colors.lightBlueAccent,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.white,
                            blurRadius: 3),
                      ]
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                              color:Colors.grey[200],
                              borderRadius: BorderRadius.circular(20)
                          ),
                          child: TextField(
                            controller: usernameCtrl,
                            decoration: InputDecoration(
                              hintText: "Username",
                              prefixIcon: Icon(Icons.person),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                            color:Colors.grey[200],
                            borderRadius: BorderRadius.circular(20)
                          ),
                          child: TextField(
                            controller: passwordCtrl,
                            decoration: InputDecoration(
                              hintText: "Password",
                              prefixIcon: Icon(Icons.lock),
                              border: InputBorder.none,
                              suffixIcon: IconButton(
                                icon : Icon(Icons.remove_red_eye_outlined),
                                onPressed: ()=>setState((){hidePassword=!hidePassword;}),
                              )
                            ),
                            obscureText: hidePassword,
                          )
                        ),
                        SizedBox(height: 20),
                        Container(
                          width: (deviceWidth * 0.8),
                          child:
                          Material(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.blue,
                            shadowColor: Colors.blueAccent,
                            elevation: 10,
                            child: RaisedButton.icon(
                              elevation: 5,
                              onPressed: (){
                                loginAction();
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              color: Colors.blue,
                              icon: Icon(Icons.lock_open,color:Colors.white),
                              label: Text("Login",style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                letterSpacing: 1
                              ),)
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      )
    );
  }

  Future<bool> onWillPop(){
    DateTime now = DateTime.now();
    if(currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)){
      // Fluttertoast.showToast(msg: "Tekan sekali lagi untuk keluar",toastLength: Toast.LENGTH_SHORT)
      print("Tekan sekali lagi untuk keluar");
      return Future.value(false);
    }
    else{
      print('exit app');
      exit(0);
    }

  }
}