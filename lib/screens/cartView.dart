import 'dart:async';

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
  final int qty;

  Cart(
      {this.id,
      this.name,
      this.price,
      this.shipping,
      this.productImage,
      this.productId,
      this.qty = 0});

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
  int _counter = 0;
  countDecrement(id) async {
    print("call countDecrement");
    setState(() {
      _counter--;
    });
  }

  countIncrement(data) async {
   
    // data.qty++;
    print("call countIncrement${data.qty}");
    setState(() {
      _counter++;
    });
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
    print('cart view screen ====>>>>>>>');
    return response;
  }

  ListView _jobsListView(data) {
    return ListView.builder(
      
        itemCount: data.length,
        itemBuilder: (context, i) {
         
          print('in cart view====${data[i].productImage[0].image}');
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
                      margin: const EdgeInsets.only(top: 10.0),
                      width: 280,
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
                                  onTap: () {
                                    countDecrement('${data[i].productId}');
                                  },
                                  child: Text(
                                    '-     ',
                                    style: TextStyle(fontSize: 20),
                                  )),
                              Text(
                                '${data[i].qty}',
                                style: TextStyle(fontSize: 15.0),
                              ),
                              GestureDetector(
                                  onTap: () {
                                    countIncrement('${data[i]}');
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
