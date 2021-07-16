import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:photo_view/photo_view.dart';
import 'package:training/helpers/constanta.dart' as myconst;
import 'package:intl/intl.dart';
import 'package:training/pages/addproduct.dart';
class Products extends StatefulWidget{
  _ProductsState createState()=>_ProductsState();
}

class _ProductsState extends State<Products>{

  bool isLoading = true;
  late List products;
  final formatCurrency = new NumberFormat.simpleCurrency();
  final formatter = new NumberFormat("#,###");

  initState(){
    getallproducts();
    super.initState();
  }

  Future<void> getallproducts() async{
    try{
      final request = await http.get(Uri.parse(myconst.GETALLPRODUCTS));
      if(request.statusCode==200){
        setState(() {
          var responseBody = jsonDecode(request.body);
          products = responseBody['products'];
          isLoading = false;
        });
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

  Future<void> deleteproduct(String id) async{
    setState((){
      isLoading = true;
    });
    try{
      final request = await http.post(
          Uri.parse(myconst.DELETEPRODUCT),
          headers: {'token':myconst.TOKENHEADER},
          body: {'productid':id}
      );
      print(request.statusCode);
      if(request.statusCode==200){
        setState((){
          isLoading = false;
          final response = jsonDecode(request.body);
          // Fluttertoast.showToast(msg: response.message.toString());
          print(response['message']);
          getallproducts();
        });
      }
      else{
        setState(() async {
          isLoading = false;
          print(request.body.toString());
        });
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

  Widget androidBody(){
    return RefreshIndicator(onRefresh: getallproducts,child: productContent());
  }

  Widget iosBody(){
    return Padding(
      padding: const EdgeInsets.all(10),
      child: CustomScrollView(
        slivers: [
          CupertinoSliverRefreshControl(
            onRefresh: getallproducts,
          ),
          productContent()
        ],
      ),
    );
  }

  Widget build(BuildContext context){
    return Scaffold(
    body:
        Platform.isIOS?iosBody():androidBody()
    );
  }

  Widget productContent(){
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeiht = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Daftar Produk",style: TextStyle(color:Colors.white)),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
        onPressed: (){
          Navigator.push(context,MaterialPageRoute(builder: (context)=>AddProduct()));
        },
      ),
      body: isLoading?Center(child: SpinKitCircle(color:Colors.blue),):
      products.length<1?Center(child: Text("Tidak ada produk")):
      ListView.builder(
          itemCount: products == null ?0:products.length,
          itemBuilder: (context,i){
            final item = products[i];
            print(products[i]['productimage']);
            return Dismissible(
              key: Key(products[i]['productid']),
              onDismissed: (direction){
                setState(() {
                  deleteproduct(products[i]['productid'].toString());
                });
              },
              background: Container(
                  child: Icon(Icons.delete,color: Colors.white,),
                  color: Colors.blueAccent
              ),
              child: Container(
                constraints: BoxConstraints(
                    maxHeight: double.infinity
                ),
                child: Card(
                  elevation: 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(3),
                            width: deviceWidth / 4,
                            height: deviceHeiht / 10,
                            child: Image.network(products[i]['productimage']),
                          )
                        ],
                      ),
                      InkWell(
                        child: Container(
                          padding: EdgeInsets.all((3)),
                          width: (deviceWidth * 0.5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(products[i]['productname'],
                                style: TextStyle(fontSize: 16),),
                              SizedBox(height: 2),
                              Text(NumberFormat.currency(locale: 'id-ID').format(double.parse(products[i]['productprice'])),
                                  // Text("Rp. "+formatter.format(double.parse(products[i]['productprice'])) + ".,00",
                                  style: TextStyle(fontSize: 12))
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }
      ),
    );
  }
}