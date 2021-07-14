import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:training/pages/splashscreen.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
  .then((value) => runApp(MyApp()));
}

class MyApp extends StatelessWidget{
  Widget build(BuildContext context)=>MaterialApp(
    home:SplashScreen(),
    debugShowCheckedModeBanner: false,
  );
}
