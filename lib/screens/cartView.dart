import 'dart:async';
import 'dart:convert';
import 'package:spurtcommerce/config.dart' as config;
import 'package:flutter/material.dart';
import 'package:spurtcommerce/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:toast/toast.dart';

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
  bool qty = false;
  List<String> listobj = [];
  var obj;
  bool loader = false;
  var updateprice;
  var oldPriceValue;
  int indexofremoveobj;
  var price;
  List priceCartItem;
  var lengthofitems;
  List<String> show_obj;

  @override
  void initState() {
    super.initState();
    priceCount();
  }

  priceCount() async {
    print("call price count");
    final prefs = await SharedPreferences.getInstance();

    show_obj = prefs.getStringList('obj_list') ?? List<String>();

    if (show_obj.length != 0) {
      print("in if price====${jsonDecode(show_obj.toString())[0]['price']}");

      var result = show_obj
          .map<int>((m) =>
              jsonDecode(m.toString())['price'].runtimeType == String
                  ? int.parse(jsonDecode(m.toString())['price'])
                  : jsonDecode(m.toString())['price'])
          .reduce(
            (a, b) => a + b,
          );
      price = result;
      loader = true;
      print("result==========$price=========");
    } else {
      loader = false;
    }
    setState(() {
      lengthofitems = show_obj.length;
    });
    print("price======$lengthofitems");
  }

  decremateQtyProduct(data, index, id) async{
    print("==========================");

    final prefs = await SharedPreferences.getInstance();
    List show_obj = prefs.getStringList('obj_list');

    var prodLists = jsonDecode(show_obj.toString())
        .where((prod) => prod["id"] == id)
        .toList();

    oldPriceValue = jsonDecode(show_obj.toString())[index]['price'];

    dynamic value = prodLists[0]['qty'];
    value--;

    var updatedqty = jsonDecode(show_obj.toString())[index]['qty'] = value;
    if (jsonDecode(show_obj.toString())[index]['price'].runtimeType == String) {
      updateprice = jsonDecode(show_obj.toString())[index]['price'] =
        int.parse(jsonDecode(show_obj.toString())[index]['updatedPrice'] ) - int.parse(oldPriceValue) ;
    } else {
      updateprice = jsonDecode(show_obj.toString())[index]['price'] =
         jsonDecode(show_obj.toString())[index]['updatedPrice'] -  oldPriceValue ;
    }
    obj = {
      'id': id,
      'qty': updatedqty,
      'price': data[index].price,
      'updatedPrice': updateprice
    };
    if (obj['id'] == id) {
      indexofremoveobj = show_obj
          .indexWhere((prod) => jsonDecode(prod.toString())['id'] == id);

      show_obj.removeWhere((item) => jsonDecode(item.toString())['id'] == id);
    }
    var idx = indexofremoveobj;
    show_obj.insert(idx, json.encode(obj));

    prefs.setStringList('obj_list', show_obj);
    List<String> show_objnew =
        prefs.getStringList('obj_list') ?? List<String>();
    print("show_===at last time==$show_objnew");
    qty = true;

    priceCount();
  }

  incremateQtyProduct(data, index, id) async {
    print("==========================");

    final prefs = await SharedPreferences.getInstance();
    List show_obj = prefs.getStringList('obj_list');

    var prodLists = jsonDecode(show_obj.toString())
        .where((prod) => prod["id"] == id)
        .toList();

    oldPriceValue = jsonDecode(show_obj.toString())[index]['price'];

    dynamic value = prodLists[0]['qty'];
    value++;

    var updatedqty = jsonDecode(show_obj.toString())[index]['qty'] = value;
    if (jsonDecode(show_obj.toString())[index]['price'].runtimeType == String) {
      updateprice = jsonDecode(show_obj.toString())[index]['price'] =
          int.parse(oldPriceValue) * updatedqty;
    } else {
      updateprice = jsonDecode(show_obj.toString())[index]['price'] =
          oldPriceValue * updatedqty;
    }
    obj = {
      'id': id,
      'qty': updatedqty,
      'price': data[index].price,
      'updatedPrice': updateprice
    };
    if (obj['id'] == id) {
      indexofremoveobj = show_obj
          .indexWhere((prod) => jsonDecode(prod.toString())['id'] == id);

      show_obj.removeWhere((item) => jsonDecode(item.toString())['id'] == id);
    }
    var idx = indexofremoveobj;
    show_obj.insert(idx, json.encode(obj));

    prefs.setStringList('obj_list', show_obj);
    List<String> show_objnew =
        prefs.getStringList('obj_list') ?? List<String>();
    print("show_===at last time==$show_objnew");
    qty = true;

    priceCount();
  }

  deleteCartItem(id) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> show_obj = prefs.getStringList('obj_list') ?? List<String>();
    List<String> show_id = prefs.getStringList('id_list') ?? List<String>();

    show_obj.removeWhere((item) => jsonDecode(item.toString())['id'] == id);
    cartProductArray.removeWhere((item) => item['productId'] == id);
    prefs.setStringList('obj_list', show_obj);
    Toast.show("Remove item Successfully", context,
        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    priceCount();
    print("after delete show===${cartProductArray.length}==${show_obj.length}");
    var listid = show_id.contains(id);
    if (listid == true) {
      show_id.remove(id);
      await prefs.setStringList('id_list', show_id);
    }
  }

  Future<List<Cart>> _fetchcartItem() async {
    var response = await fetchcartItem();
    return response;
  }

  Widget cartItem() {
    print("call cart item======");
    return FutureBuilder<List<Cart>>(
      future: _fetchcartItem(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Cart> data = snapshot.data;
          return ListView.builder(
              shrinkWrap: true,
              itemCount: data.length,
              itemBuilder: (context, i) {
                return Row(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        new Container(
                          margin:
                              const EdgeInsets.only(bottom: 20.0, top: 10.0),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Container(
                            margin:
                                const EdgeInsets.only(top: 10.0, left: 15.0),
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
                                    style: TextStyle(
                                        fontSize: 15.0, color: Colors.red),
                                  ),
                                ),
                                new Divider(),
                                Row(children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        'Qty. :  ',
                                        style: TextStyle(fontSize: 15.0),
                                      ),
                                      GestureDetector(
                                          onTap: () async {
                                            decremateQtyProduct(
                                                data, i, data[i].productId);
                                          },
                                          child: Text(
                                            '-     ',
                                            style: TextStyle(fontSize: 20),
                                          )),
                                      Row(
                                          children: show_obj.map((item) {
                                        return Text(
                                          '${jsonDecode(item.toString())['qty']}',
                                          style: TextStyle(fontSize: 15.0),
                                        );
                                      }).toList()),
                                      GestureDetector(
                                          onTap: () async {
                                            incremateQtyProduct(
                                                data, i, data[i].productId);
                                          },
                                          child: Text(
                                            '     +',
                                            style: TextStyle(fontSize: 20),
                                          )),
                                    ],
                                  ),
                                  Spacer(),
                                  Column(
                                    children: <Widget>[
                                      GestureDetector(
                                          onTap: () {
                                            deleteCartItem(
                                              '${data[i].productId}',
                                            );
                                          },
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Icon(
                                              Icons.delete,
                                              color: Colors.deepPurple,
                                              size: 30.0,
                                            ),
                                          ))
                                    ],
                                  )
                                ])
                              ],
                            )))
                      ],
                    )
                  ],
                );
              });
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return SpinKitCircle(color: Colors.deepPurple);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: <Widget>[
        SliverList(
            delegate: SliverChildListDelegate(
          [
            Column(
              children: <Widget>[cartItem()],
            ),
            new Divider(),
          ],
        )),
        SliverList(
            delegate: SliverChildListDelegate([
          Container(
              child: loader == true
                  ? Column(children: <Widget>[
                      new Container(
                          margin: EdgeInsets.all(3.0),
                          child: Card(
                              color: Colors.grey[300],
                              child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 5,
                                    vertical: 5,
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Text(
                                              'PRICE DETAILS ($lengthofitems Items)',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold))
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            'Sub total',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15),
                                          ),
                                          Spacer(),
                                          Text('Rs. $price',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15))
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            'Shipping',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15),
                                          ),
                                          Spacer(),
                                          Text('Free',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15))
                                        ],
                                      ),
                                      new Divider(),
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            'Total',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Spacer(),
                                          Text('Rs. $price',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20))
                                        ],
                                      )
                                    ],
                                  ))))
                    ])
                  : null)
        ]))
      ],
    ));
  }
}
