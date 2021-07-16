import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:training/helpers/mycolors.dart' as mycolor;
import 'package:http/http.dart' as http;
import 'package:training/helpers/constanta.dart' as myconstanta;

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
  bool isLoading = false;
  String loginInfo="";

  Future<void> loginAction() async{
    String username = usernameCtrl.text??"";
    String password = passwordCtrl.text??"";
    try{
      setState(() {
        isLoading = true;
        loginInfo = "Tunggu Sebentar...";
      });
      final request = await http.post(
        Uri.parse(myconstanta.LOGINURL),
        headers: {'token':myconstanta.TOKENHEADER},
        body: {'username':username,'password':password}
      );
      // print(request.body.toString());
      if(request.statusCode==200){
        setState(() {
          isLoading = false;
          loginInfo = "";
        });
        final response = jsonDecode(request.body);
        bool isLogin = response['isLogin'];
        if(isLogin==true){
          String username = response['username'];
          String userid = response['userid'];
          String fullname = response['fullname'];
          SharedPreferences sp = await SharedPreferences.getInstance();
          setState(() {
            sp.setBool('isLogin',isLogin);
            sp.setString('username', username);
            sp.setString('fullname', fullname);
            sp.setString('userid', userid);
            Navigator.pushReplacement(context,PageTransition(type: PageTransitionType.bottomToTop,child: Home()));
          });
        }
        else{
          setState(() {
            loginInfo = response['message'];
          });
        }

      }
      else{
        Fluttertoast.showToast(msg:"HTTP REQUEST ERROR");
      }
    }
    on HttpException{
      print("MAAF, HTTP ERROR");
    }
    on SocketException{
      print("MAAF, SOCKET ERROR");
    }
    on FormatException{
      print("MAAF, FORMAT ERROR");
    }
  }


  Widget build(BuildContext context){
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: mycolor.WARNAUTAMA,
      body: isLoading?Center(child: SpinKitCircle(color:Colors.white)):WillPopScope(
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
                        SizedBox(height: 20),
                        Container(child:
                          Text(loginInfo,style: TextStyle(color:Colors.red,fontSize: 12))
                        )
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