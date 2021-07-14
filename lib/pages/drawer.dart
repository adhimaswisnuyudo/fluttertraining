import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'home.dart';

class MainDrawer extends StatefulWidget{
  _MainDrawerState createState()=> _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer>{

  Widget build(BuildContext context){
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text("Selamat Datang, ",style: TextStyle(fontSize: 12,color: Colors.white),),
                Text("Adhimas",style: TextStyle(fontSize: 20,color: Colors.white,letterSpacing: 2),)
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

            },
          ),
          Divider(color:Colors.grey),

        ],
      ),
    );
  }
}