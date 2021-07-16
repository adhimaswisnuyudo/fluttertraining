import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:trust_fall/trust_fall.dart';
import 'drawer.dart';
import 'dart:io' as io;

class About extends StatefulWidget{
  _AboutState createState()=>_AboutState();
}

class _AboutState extends State<About>{

  late String appName="",packageName="",version="",buildNumber="";
  Future<void> getInformation() async {
    PackageInfo pi = await PackageInfo.fromPlatform();
    setState(() {
      appName = pi.appName.toString();
      packageName = pi.packageName.toString();
      version = pi.version.toString();
      buildNumber = pi.buildNumber.toString();
    });
  }

  late String platform="",deviceName="",deviceVersion="",deviceIdentifier="",brand="",fingerprint="";
  Future<void> getDeviceInformation() async{
    DeviceInfoPlugin dip = DeviceInfoPlugin();
    if(io.Platform.isAndroid){
      var pf = await dip.androidInfo;
      setState(() {
        platform = "Android";
        deviceName = pf.model.toString();
        deviceVersion = pf.version.toString();
        deviceIdentifier = pf.androidId.toString();
        brand =pf.brand.toString();
        fingerprint = pf.fingerprint.toString();
      });
    }
    else if(io.Platform.isIOS){
        var pf = await dip.iosInfo;
        setState(() {
          platform = "IOS";
          deviceName = pf.name.toString();
          deviceVersion = pf.systemVersion.toString() + " " + pf.model.toString() ;
          deviceIdentifier = pf.identifierForVendor.toString();
          brand ="Apple";
        });
    }
    else{
      setState(() {
        deviceName = "Other";
        deviceVersion = "Other";
        deviceIdentifier = "Other";
      });
    }

  }

  late bool isRooted=false,isRealDevice=false,isMockLocation=false,isOnExternalStorage=false;
  Future<void>getTrustDevice() async{
    setState(() async {
      isRooted = await TrustFall.isJailBroken;
      isRealDevice = await TrustFall.isRealDevice;
      isMockLocation = await TrustFall.canMockLocation;
      isOnExternalStorage = await TrustFall.isOnExternalStorage;
    });
  }

  void initState(){
    getInformation();
    getDeviceInformation();
    getTrustDevice();
    super.initState();
  }

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
        title:Text("Tentang Aplikasi",style: TextStyle(color: Colors.black),)
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Nama Aplikasi : "+appName),
            SizedBox(height: 10),
            Text("Nama Package : "+packageName),
            SizedBox(height: 10),
            Text("Versi : "+version),
            SizedBox(height: 10),
            Text("Build Number : "+ buildNumber),

            SizedBox(height: 10),
            Text("Platform : "+platform),
            SizedBox(height: 10),
            Text("Device : "+deviceName),
            SizedBox(height: 10),
            Text("Versi Device : "+ deviceVersion),
            SizedBox(height: 10),
            Text("Identifier : "+ deviceIdentifier),
            SizedBox(height: 10),
            Text("Merk : "+ brand),
            SizedBox(height: 10),
            Text("Fingerprint : "+ fingerprint),
            SizedBox(height: 10),
            isRooted?Text("Device sudah di Root"):Text("Tidak di Root"),
            SizedBox(height: 10),
            isRealDevice?Text("Handphone Asli"):Text("Pakai Emulator"),
            SizedBox(height: 10),
            isMockLocation?Text("Dapat Mocking Location"):Text("Tidak dapat Mocking Location"),
            SizedBox(height: 10),
            isOnExternalStorage?Text("Aplikasi disimpan di external storage"):Text("Aplikasi disimpan di Internal Storage"),
          ],
        ),
      ),
      drawer: MainDrawer(),
    );
  }
}