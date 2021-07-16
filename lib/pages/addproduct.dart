import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:training/helpers/constanta.dart' as myconst;
import 'package:http/http.dart' as http;
import 'package:training/pages/products.dart';

class AddProduct extends StatefulWidget{

  _AddProductState createState()=>_AddProductState();

}

class _AddProductState extends State<AddProduct>{
  bool isLoading = false;
  TextEditingController productnameCtrl = new TextEditingController();
  TextEditingController productpriceCtrl = new TextEditingController();
  final picker = ImagePicker();
  late File productImage;
  late bool isImageReady = false;

  void showPicker(context){
    showModalBottomSheet(
      context: context,
      builder: (BuildContext){
        return Container(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.photo_library,color: Colors.grey),
                title: Text("Pilih dari gallery"),
                onTap: (){
                  showGallery();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera,color:Colors.grey),
                title: Text("Pilih dari kamera"),
                onTap: (){
                  showCamera();
                },
              )
            ],
          ),
        );
      }
    );
  }

  void showCamera() async{
    var image = await picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.rear
    );
    if(image != null){
      setState(() {
        productImage = File(image.path);
        isImageReady = true;
      });
    }
  }

  void showGallery() async{
    var image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
    );
    if(image != null){
      setState(() {
        productImage = File(image.path);
        isImageReady = true;
      });
    }
  }

  Future<void> uploadProduct() async{
    final Map<String,String> headers = {
      'token':myconst.TOKENHEADER,
      'Content-Type':'multipart/form-data'
    };
    try{
      setState(() {
        isLoading = true;
      });
      var request = http.MultipartRequest("POST",Uri.parse(myconst.ADDPRODUCT));
      var fileToUpload = await http.MultipartFile.fromPath("productimage",productImage.path);
      request.files.add(fileToUpload);
      request.headers.addAll(headers);
      request.fields['productname'] = productnameCtrl.text.toString();
      request.fields['productprice'] = productpriceCtrl.text.toString();
      await request.send().then((response) async{
        response.stream.transform(utf8.decoder).listen((value){
          var data = jsonDecode(value);
          setState(() {
            isLoading=false;
            if(data['status'].toString() == "success"){
              Fluttertoast.showToast(msg: data['message'].toString());
              Timer(Duration(seconds: 2),()=>
                  Navigator.push(context,MaterialPageRoute(builder: (context)=>Products()))
              );
            }
            else{
              Fluttertoast.showToast(msg: data['message'].toString());
            }
          });
        });
      });
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
    double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Tambah Produk",style: TextStyle(color:Colors.white)),
      ),
        body: isLoading?Center(child: SpinKitCircle(color:Colors.white)):ListView(
            children: <Widget>[
              SizedBox(height: 100),
              Center(
                child: Column(
                  children: [
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
                              controller: productnameCtrl,
                              decoration: InputDecoration(
                                hintText: "Nama Produk",
                                prefixIcon: Icon(Icons.card_giftcard),
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
                                controller: productpriceCtrl,
                                decoration: InputDecoration(
                                    hintText: "Harga",
                                    prefixIcon: Icon(Icons.monetization_on),
                                    border: InputBorder.none,
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                              )
                          ),
                          SizedBox(height: 20),

                          Container(
                              decoration: BoxDecoration(
                                  color:Colors.grey[200],
                                  borderRadius: BorderRadius.circular(20)
                              ),
                              child: isImageReady?Image.file(productImage):Container(
                                  child:
                                  Text("Belum ada gambar")
                              )
                          ),
                          SizedBox(height: 20),
                          
                          Container(
                            width: (deviceWidth * 0.8),
                            child:
                            ElevatedButton.icon(
                              icon:Icon(Icons.image),
                              label: Text("Pilih Gambar"),
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular((10))
                                  )
                              ),
                              onPressed: (){
                                showPicker(context);
                              },
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            width: (deviceWidth * 0.8),
                            child:
                              ElevatedButton.icon(
                                icon:Icon(Icons.upload),
                                label: Text("Simpan Produk"),
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular((10))
                                    )
                                ),
                                onPressed: (){
                                  uploadProduct();
                                },
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
    );
  }
}