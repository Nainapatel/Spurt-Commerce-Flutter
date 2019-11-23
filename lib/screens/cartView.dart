import 'dart:async';
import 'dart:convert';
import 'package:spurtcommerce/config.dart' as config;
import 'package:flutter/material.dart';
import 'package:spurtcommerce/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Cart {
  final int id;
  final String name;
  final int price;
  final String shipping;
  final List<Product> productImage;
  final String productId;
  dynamic qty;

  Cart(
      {this.id,
      this.name,
      this.price,
      this.shipping,
      this.productImage,
      this.productId,
      this.qty});

  factory Cart.fromJson(Map<String, dynamic> json) {
    var productImage = json['productImage'] as List;
    List<Product> cartProductImage =
        productImage.map((i) => Product.fromJson(i)).toList();
    return Cart(
        id: json['id'],
        name: json['name'],
        price: json['price'],
        shipping: json['shipping'],
        productImage: cartProductImage,
        productId: json['productId'],
        qty: json['qty']);
  }
}

class Product {
  final String image;
  final String containerName;

  Product({this.image, this.containerName});

  factory Product.fromJson(Map<String, dynamic> jsonTime) {
    return Product(
        image: jsonTime['image'], containerName: jsonTime['containerName']);
  }
}

class CartView extends StatefulWidget {
  @override
  CartViewScreenState createState() => CartViewScreenState();
}

class CartViewScreenState extends State<CartView> {
  int qtyData;
  List product;
  // List qtyArray = [];
  bool qty = true;

  @override
  void initState() {
    super.initState();
    // this.getQtyProduct(); // Function for get product details
  }

  getQtyProduct(data, index) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> show_cartData =
        prefs.getStringList('show_cartData') ?? List<String>(); // <-EDITED HERE
    List<String> cartData = data[index].qty++;
    prefs.setStringList('show_cartData', cartData);
    print('show_cartData-------$show_cartData');
    setState(() {
      qty = true;
    });
    print('data==$index======${data[index].qty}');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Cart>>(
      future: _fetchJobs(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Cart> data = snapshot.data;
          return _jobsListView(data);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
    );
  }

  Future<List<Cart>> _fetchJobs() async {
    var response = await fetchJobs();
    return response;
  }

  ListView _jobsListView(data) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, i) {
          return Row(
            children: <Widget>[
              Column(
                children: <Widget>[
                  new Container(
                    margin: const EdgeInsets.only(bottom: 20.0, top: 10.0),
                    child: Image.network(
                      config.mediaUrl +
                          '${data[i].productImage[0].containerName}' +
                          '${data[i].productImage[0].image}',
                      width: 100,
                      height: 100,
                    ),
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  new Container(
                      margin: const EdgeInsets.only(top: 10.0, left: 15.0),
                      width: 260,
                      child: SizedBox(
                          // height: 250,
                          child: Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '${data[i].name}',
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 15.0),
                            ),
                          ),
                          new Divider(),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Rs.${data[i].price}',
                              textAlign: TextAlign.left,
                              style:
                                  TextStyle(fontSize: 15.0, color: Colors.red),
                            ),
                          ),
                          new Divider(),
                          Row(
                            children: <Widget>[
                              Text(
                                'Qty. :  ',
                                style: TextStyle(fontSize: 15.0),
                              ),
                              GestureDetector(
                                  onTap: () async {
                                    data[i].qty--;
                                  },
                                  child: Text(
                                    '-     ',
                                    style: TextStyle(fontSize: 20),
                                  )),
                              qty == true
                                  ? Text(
                                      '${data[i].qty}',
                                      style: TextStyle(fontSize: 15.0),
                                    )
                                  : Text(
                                      '${data[i].qty}',
                                      style: TextStyle(fontSize: 15.0),
                                    ),
                              GestureDetector(
                                  onTap: () async {
                                    //  data[i].qty++;
                                    getQtyProduct(data, i);

                                    // final prefs =
                                    //     await SharedPreferences.getInstance();
                                    // List<String> show_qty =
                                    //     prefs.getStringList('cart_obj') ??
                                    //         List<String>();

                                    // List<String> qtyArray = show_qty;
                                    // var obj = {
                                    //   'index': i,
                                    //   'productId': data[i].productId,
                                    //   'qty': data[i].qty,
                                    //   'price': data[i].price,
                                    // };
                                    // print('array=====$qtyArray');
                                    // for (var i = 0; i < qtyArray.length; i++) {
                                    //   var n = qtyArray[i]
                                    //       .contains(data[i].productId);
                                    //   print('n=============$i=======$n');
                                    // }
                                    // qtyArray.add(obj.toString());
                                    // prefs.setStringList('cart_obj', qtyArray);
                                  },
                                  child: Text(
                                    '     +',
                                    style: TextStyle(fontSize: 20),
                                  )),
                            ],
                          )
                        ],
                      )))
                ],
              )
            ],
          );
        });
  }
}

// final prefs =
//                                         await SharedPreferences.getInstance();
//                                     prefs.setStringList('qtyData',
//                                         jsonDecode(qtyArray.toString()));
//                                     List<String> show_qty =
//                                         prefs.getString('qtyData') ??
//                                             List<String>();
//                                     print('show_qty==in onTap=$show_qty');

//  for (var i = 0; i < qtyArray.length; i++) {
//                                     var n = qtyArray
//                                         .contains(data[i].productId);
//                                     print('n====${qtyArray.length}===============$n');

//                                     if (n == true) {
//                                       print('i if');
//                                       Map<String, dynamic> data =
//                                           json.decode(qtyArray.toString());
//                                       (data["qtyArray"] as List<dynamic>)
//                                           .forEach((item) =>
//                                               item["productId"] =
//                                                   data[i].qty++);

//                                     } else {
//                                       print('in else');
//                                        obj = {
//                                         'index': i,
//                                         'productId': data[i].productId,
//                                         'qty': data[i].qty,
//                                         'price': data[i].price
//                                       };
//                                     }
//                                   }
