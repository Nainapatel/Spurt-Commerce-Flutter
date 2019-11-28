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
  int qtyData;
  List product;
  bool qty = true;
  List<String> listobj = [];
  var obj;
  bool loader = false;

  var price;
  List priceCartItem;
  var lengthofitems;

  @override
  void initState() {
    super.initState();
    priceCount();
  }

  priceCount() async {
    print("call price count");
    final prefs = await SharedPreferences.getInstance();
    List<String> show_price =
        prefs.getStringList('show_price') ?? List<String>();

    var result =
        show_price.map<int>((m) => int.parse(m)).reduce((a, b) => a + b);
    price = result;
    // var lengthofitems = show_price.length;
    setState(() {
      lengthofitems = show_price.length;
    });
    print("price======$lengthofitems");
    print("result===================$result");
  }

  getQtyProduct(data, index, id) async {
    // print("==========================");
    // print('index===$index=====${data[index].qty++}======');
    // final prefs = await SharedPreferences.getInstance();
    // List show_obj = prefs.getStringList('obj_list').toList();
    // print('before=first time=====$show_obj');
    // var prodLists = jsonDecode(show_obj.toString())
    //     .where((prod) => prod["id"] == id)
    //     .toList();
    // print("prodLists-====old=$prodLists");
    // dynamic value = prodLists[0]['qty'];
    // value++;
    // print("in==$index== cart view sorted value ====$value");
    // var updatedqty = jsonDecode(show_obj.toString())[index]['qty'] = value;
    // print('updatedqty=======$updatedqty');
    // obj = {'id': data[index].productId, 'qty': updatedqty};
    // print('obj=before if=show_obj==$show_obj');

    // if (obj['id'] == id) {
    //   print("in if==${obj['id']}====$id");
    //   show_obj.removeWhere((item) => item['id'] == id);
    //   print("after removing object=$show_obj");
    // }

    // show_obj.add(json.encode(obj));
    // print("=after added===show_obj=====$show_obj");

    // prefs.setStringList('obj_list', show_obj);
    // List show_objnew = prefs.getStringList('obj_list').toList();
    // print("show_===at last time==$show_objnew");
// -------------------------------------------------------------------
    // var n = show_id.contains(data[index].productId);
    // dynamic show_cartData = prefs.getInt('show_cartData');
    // if (n == true) {
    // if (show_cartData != null && show_cartData != 1) {
    //   show_cartData = show_cartData + 1;
    //   prefs.setInt('show_cartData', show_cartData);
    //   print('in if===$show_cartData');
    // } else {
    //   prefs.setInt('show_cartData', data[index].qty++);
    //   print('in else===$show_cartData');
    // }
    // print("$index==show_cartData====$show_cartData");
    // }
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
    // setState(() {
    //   loader = true;
    // });
    return response;
  }

  Widget cartItem() {
    print("CART ITEM RECALL==============");
    return FutureBuilder<List<Cart>>(
      future: _fetchcartItem(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Cart> data = snapshot.data;

          return ListView.builder(
              shrinkWrap: true,
              itemCount: data.length,
              itemBuilder: (context, i) {
                loader = true;

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
                                Row(
                                  children: <Widget>[
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
                                        Text(
                                          '${data[i].qty}',
                                          style: TextStyle(fontSize: 15.0),
                                        ),
                                        GestureDetector(
                                            onTap: () async {
                                              //  data[i].qty++;
                                              getQtyProduct(
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
                                  ],
                                )
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
              // child: loader == false
                 child:  Column(children: <Widget>[
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
                    ]))
                  // : null)
        ]))
      ],
    ));
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

// ======================================

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
