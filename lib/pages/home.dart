import 'package:flutter/material.dart';
import 'package:training/pages/drawer.dart';

class Home extends StatefulWidget{
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home>{
  Widget build(BuildContext context){
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.all(5),
          child: Image(
            image: AssetImage("assets/images/logoinix.png",),height: 40,width: 120,
          ),
        ),
        backgroundColor: const Color(0xFFF5F5F5),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search,color: Colors.blueAccent,),
            onPressed: (){},
          ),
          IconButton(
            icon: Icon(Icons.person,color:Colors.blueAccent),
            onPressed: (){},
          )
        ],
      ),
    );
  }
}