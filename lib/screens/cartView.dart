import 'dart:async';
import 'dart:convert';
import 'package:spurtcommerce/config.dart' as config;
import 'package:flutter/material.dart';
import 'package:spurtcommerce/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:toast/toast.dart';
import 'package:spurtcommerce/screens/placeorder.dart';

class Cart {
  final int id;
  final String name;
  final int price;
  final String shipping;
  final List<Product> productImage;
  final String productId;
  dynamic qty;
  final String metaTagTitle;

  Cart(
      {this.id,
      this.name,
      this.price,
      this.shipping,
      this.productImage,
      this.productId,
      this.qty,
      this.metaTagTitle});

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
        qty: json['qty'],
        metaTagTitle: json['metaTagTitle']);
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

/*
 This function for addition of price 
*/
  priceCount() async {
    print("call price count");
    final prefs = await SharedPreferences.getInstance();

    show_obj = prefs.getStringList('obj_list') ??
        List<String>(); // show_obj contains id, qty and price.

    if (show_obj.length != 0) {
      print("in if price====${jsonDecode(show_obj.toString())[0]['price']}");

      var result = show_obj
          .map<int>((m) =>
              jsonDecode(m.toString())['price'].runtimeType == String
                  ? int.parse(jsonDecode(m.toString())['updatedPrice'])
                  : jsonDecode(m.toString())['updatedPrice'])
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

/*
 * @params {object} data contains instance  of Cart class
 * @params {int} index of product
 * @params {String} id of produce
 */
  decremateQtyProduct(data, index, id) async {
    print("==========================");

    final prefs = await SharedPreferences.getInstance();
    List show_obj = prefs.getStringList('obj_list');

    var prodLists = jsonDecode(show_obj.toString())
        .where((prod) => prod["productId"] == id)
        .toList();

    oldPriceValue = jsonDecode(show_obj.toString())[index]['price'];

    dynamic value = prodLists[0]['quantity'];
    value--;

    var updatedqty = jsonDecode(show_obj.toString())[index]['quantity'] = value;
    if (jsonDecode(show_obj.toString())[index]['price'].runtimeType == String) {
      updateprice = jsonDecode(show_obj.toString())[index]['price'] =
          int.parse(jsonDecode(show_obj.toString())[index]['updatedPrice']) -
              int.parse(oldPriceValue);
    } else {
      updateprice = jsonDecode(show_obj.toString())[index]['price'] =
          jsonDecode(show_obj.toString())[index]['updatedPrice'] -
              oldPriceValue;
    }
    obj = {
      'productId': id,
      'quantity': updatedqty,
      'price': data[index].price,
      'updatedPrice': updateprice,
      'name': data[index].name,
      'model': data[index].metaTagTitle
    };
    if (obj['productId'] == id) {
      indexofremoveobj = show_obj
          .indexWhere((prod) => jsonDecode(prod.toString())['productId'] == id);

      show_obj.removeWhere(
          (item) => jsonDecode(item.toString())['productId'] == id);
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

/*
 * @params {object} data contains instance  of Cart class
 * @params {int} index of product
 * @params {String} id of produce
 */
  incremateQtyProduct(data, index, id) async {
    print("==========================");

    final prefs = await SharedPreferences.getInstance();
    List show_obj = prefs.getStringList('obj_list');

    var prodLists = jsonDecode(show_obj.toString())
        .where((prod) => prod["productId"] == id)
        .toList();

    oldPriceValue = jsonDecode(show_obj.toString())[index]['price'];

    dynamic value = prodLists[0]['quantity'];
    value++;

    var updatedqty = jsonDecode(show_obj.toString())[index]['quantity'] = value;
    if (jsonDecode(show_obj.toString())[index]['price'].runtimeType == String) {
      updateprice = jsonDecode(show_obj.toString())[index]['price'] =
          int.parse(oldPriceValue) * updatedqty;
    } else {
      updateprice = jsonDecode(show_obj.toString())[index]['price'] =
          oldPriceValue * updatedqty;
    }
    obj = {
      'productId': id,
      'quantity': updatedqty,
      'price': data[index].price,
      'updatedPrice': updateprice,
      'name': data[index].name,
      'model': data[index].metaTagTitle
    };
    if (obj['productId'] == id) {
      indexofremoveobj = show_obj
          .indexWhere((prod) => jsonDecode(prod.toString())['productId'] == id);

      show_obj.removeWhere(
          (item) => jsonDecode(item.toString())['productId'] == id);
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

/*
 * @params {String} id of Product 
*/
  deleteCartItem(id) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> show_obj = prefs.getStringList('obj_list') ??
        List<String>(); // show_obj contains id, qty and price.
    List<String> show_id = prefs.getStringList('id_list') ??
        List<String>(); // show_obj contains id.
// delete product id wisw
    show_obj
        .removeWhere((item) => jsonDecode(item.toString())['productId'] == id);
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
    var response = await fetchcartItem(); // call from services
    return response;
  }

  /*
   cartItem fetch all cart item 
   */
  Widget cartItem() {
    return FutureBuilder<List<Cart>>(
      future: _fetchcartItem(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Cart> data = snapshot.data;
          print("call cart item=====${data.length}=");

          return ListView.builder(
              shrinkWrap: true,
              itemCount: data.length,
              itemBuilder: (context, i) {
                print("main loop in widget===${data.length}===$i");
                return Card(
                    child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 2,
                          vertical: 2,
                        ),
                        child: Row(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                new Container(
                                  margin: const EdgeInsets.only(
                                      bottom: 20.0, top: 10.0),
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
                                    margin: const EdgeInsets.only(
                                        top: 10.0, left: 15.0),
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
                                            '\u20B9 ${jsonDecode(show_obj.toString())[i]['updatedPrice']}',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontSize: 15.0,
                                                color: Colors.red),
                                          ),
                                        ),
                                        new Divider(),
                                        Row(children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Text(
                                                'Qty. :  ',
                                                style:
                                                    TextStyle(fontSize: 15.0),
                                              ),
                                              jsonDecode(show_obj.toString())[i]
                                                          ['quantity'] ==
                                                      1
                                                  ? GestureDetector(
                                                      onTap: () {},
                                                      child: Text(
                                                        '     ',
                                                        style: TextStyle(
                                                            fontSize: 20),
                                                      ))
                                                  : GestureDetector(
                                                      onTap: () async {
                                                        decremateQtyProduct(
                                                            data,
                                                            i,
                                                            data[i].productId);
                                                      },
                                                      child: Text(
                                                        '-     ',
                                                        style: TextStyle(
                                                            fontSize: 20),
                                                      )),
                                              Text(
                                                '${jsonDecode(show_obj.toString())[i]['quantity']}',
                                                style:
                                                    TextStyle(fontSize: 15.0),
                                              ),
                                              GestureDetector(
                                                  onTap: () async {
                                                    incremateQtyProduct(data, i,
                                                        data[i].productId);
                                                  },
                                                  child: Text(
                                                    '     +',
                                                    style:
                                                        TextStyle(fontSize: 20),
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
                                                    alignment:
                                                        Alignment.centerLeft,
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
                            ),
                          ],
                        )));
              });
        } else if (snapshot.hasError) {
          return Text("======${snapshot.error}");
        }
        return SpinKitCircle(color: Colors.deepPurple);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: show_obj.length == 0
              ? Column(
                
                   mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                     Image.asset(
                              'assets/cart_wish.jpeg',
                              width: 200,
                              height: 200,
                            ),
                  
                    Text(
                      "Your Cart is empty",
                      style: TextStyle(color: Colors.grey),
                    ),
                    RaisedButton(
                      color: Colors.deepPurple,
                      onPressed: () {
                        Navigator.of(context).pushNamed("/dashboard");
                      },
                      child: Text(
                        'Countinue Shopping',
                        style: TextStyle(color: Colors.white, fontSize: 18.0),
                      ),
                    ),
                  ],
                )
              : CustomScrollView(
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
                                          child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 5,
                                                vertical: 5,
                                              ),
                                              child: Column(
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      lengthofitems == 1
                                                          ? Text(
                                                              'PRICE DETAILS ($lengthofitems Item)',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold))
                                                          : Text(
                                                              'PRICE DETAILS ($lengthofitems Items)',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold))
                                                    ],
                                                  ),
                                                  new Divider(),
                                                  Row(
                                                    children: <Widget>[
                                                      Text(
                                                        'Sub total',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 15),
                                                      ),
                                                      Spacer(),
                                                      Text('\u20B9 $price ',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 15))
                                                    ],
                                                  ),
                                                  new Divider(),
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
                                                            color: Colors.green,
                                                            fontSize: 15,
                                                          ))
                                                    ],
                                                  ),
                                                  new Divider(
                                                      color: Colors.black),
                                                  Row(
                                                    children: <Widget>[
                                                      Text(
                                                        'Total',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Spacer(),
                                                      Text('\u20B9 $price',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 20))
                                                    ],
                                                  )
                                                ],
                                              )))),
                                ])
                              : null)
                    ]))
                  ],
                ),
        ),
        bottomNavigationBar: loader == true
            ? new Container(
                height: 45.0,
                color: Color.fromRGBO(94, 199, 182, 0.9),
                child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 5,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Text(
                              '\u20B9 $price',
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            )
                          ],
                        ),
                        new VerticalDivider(color: Colors.black),
                        Column(
                          children: <Widget>[
                            GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            PlaceorderScreen(),
                                      ));
                                },
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Place order",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 20),
                                    )))
                          ],
                        )
                      ],
                    )))
            : null);
  }
}
