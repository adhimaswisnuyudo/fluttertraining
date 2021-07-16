import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:training/pages/products.dart';

import 'about.dart';
import 'home.dart';
import 'login.dart';

class MainDrawer extends StatefulWidget{
  _MainDrawerState createState()=> _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer>{

  void initState(){
    greeting();
    super.initState();
  }

  var sambutan,name="";
  void greeting() async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      name = sp.getString("fullname")!;
      var hour = DateTime.now().hour;
      if(hour < 12){
        sambutan = "Selamat Pagi,";
      }
      else if(hour < 18){
        sambutan = "Selamat Siang,";
      }
      else{
        sambutan = "Selamat Malam,";
      }
    });
  }

  void logout() async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.clear();
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder:(context)=>
            Login())
    );
  }

  Widget build(BuildContext context){
    void logoutDialog(){
        showDialog(
          context: context,
          builder: (BuildContext context){
            return AlertDialog(
              title: Text("Logout",style: TextStyle(fontWeight: FontWeight.bold),),
              content: Text("Yakin akan logout?"),
              actions: <Widget>[
                FlatButton(child:
                  Text(
                      "Ya",style: TextStyle(color: Colors.red)
                  ),
                  onPressed: (){
                    logout();
                  },
                ),
                FlatButton(child:
                  Text("Tidak",style: TextStyle(color: Colors.grey)
                  ),
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          }
        );
    }

    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(sambutan.toString(),style: TextStyle(fontSize: 12,color: Colors.white),),
                Text(name,style: TextStyle(fontSize: 20,color: Colors.white,letterSpacing: 2),)
              ],
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                image : AssetImage("assets/images/metrocolor1.png"),
                fit:BoxFit.cover
              )
            ),
          ),
          InkWell(
            child:Container(
              padding: EdgeInsets.only(top: 5, bottom: 5,right: 10,left: 10),
              child: Row(
                children: <Widget>[
                  Icon(Icons.home,color: Colors.black, size: 30,),
                  SizedBox(width: 15),
                  Text("Beranda",style: TextStyle(color: Colors.black,fontSize: 20)),
                ],
              ),
            ),
            onTap: (){
              Navigator.push(context,PageTransition(type: PageTransitionType.bottomToTop,child: Home()));
            },
          ),
          Divider(color:Colors.grey),
          InkWell(
            child:Container(
              padding: EdgeInsets.only(top: 5, bottom: 5,right: 10,left: 10),
              child: Row(
                children: <Widget>[
                  Icon(Icons.card_giftcard,color: Colors.black, size: 30,),
                  SizedBox(width: 15),
                  Text("Produk",style: TextStyle(color: Colors.black,fontSize: 20)),
                ],
              ),
            ),
            onTap: (){
              Navigator.push(context,PageTransition(type: PageTransitionType.bottomToTop,child: Products()));
            },
          ),
          Divider(color:Colors.grey),
          InkWell(
            child:Container(
              padding: EdgeInsets.only(top: 5, bottom: 5,right: 10,left: 10),
              child: Row(
                children: <Widget>[
                  Icon(Icons.info,color: Colors.black, size: 30,),
                  SizedBox(width: 15),
                  Text("Tentang",style: TextStyle(color: Colors.black,fontSize: 20)),
                ],
              ),
            ),
            onTap: (){
              Navigator.push(context,PageTransition(type: PageTransitionType.bottomToTop,child: About()));
            },
          ),
          Divider(color:Colors.grey),
          InkWell(
            child:Container(
              padding: EdgeInsets.only(top: 5, bottom: 5,right: 10,left: 10),
              child: Row(
                children: <Widget>[
                  Icon(Icons.exit_to_app,color: Colors.black, size: 30,),
                  SizedBox(width: 15),
                  Text("Logout",style: TextStyle(color: Colors.black,fontSize: 20)),
                ],
              ),
            ),
            onTap: (){
              logoutDialog();
            },
          ),
          Divider(color:Colors.grey),

        ],
      ),
    );
  }
}