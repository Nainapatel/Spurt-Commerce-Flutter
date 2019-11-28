import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:spurtcommerce/config.dart' as config;
import 'package:flutter_html/flutter_html.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spurtcommerce/screens/cart.dart';
import 'package:spurtcommerce/screens/wishlist.dart';
import 'package:toast/toast.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ProductViewScreen extends StatefulWidget {
  final id;
  final name;
  ProductViewScreen({Key key, @required this.id, this.name}) : super(key: key);
  @override
  ProductViewScreenState createState() => ProductViewScreenState();
}

class ProductViewScreenState extends State<ProductViewScreen> {
  List product;
  List productImage;
  bool isaddtocart = true;
  bool iswishlisted = true;
  bool loader = false;
  dynamic qty = 1;
  var obj;
  List<dynamic> listobj = [];
  @override
  void initState() {
    super.initState();
    this.getProduct(); // Function for get product details
    this.checkinCartid();
  }

  checkinCartid() async {
    var id = this.widget.id;
    final prefs = await SharedPreferences.getInstance();
    List<String> show_id = prefs.getStringList('id_list') ?? List<String>();
    List<String> list = show_id;
    List<String> show_wishlist =
        prefs.getStringList('id_wishlist') ?? List<String>();
    List<String> wishlist = show_wishlist;
    loader = true;
    var n = list.contains(id);
    if (n == true) {
      setState(() {
        isaddtocart = false;
      });
    } else {
      setState(() {
        iswishlisted = true;
      });
    }

    var listid = wishlist.contains(id);
    if (listid == true) {
      setState(() {
        iswishlisted = false;
      });
    } else {
      setState(() {
        iswishlisted = true;
      });
    }
  }

/*
 *  For Product get by id
 */
  Future<String> getProduct() async {
    var id = this.widget.id;
    var response = await http.get(
        Uri.encodeFull(config.baseUrl + 'product-store/productdetail/$id'),
        headers: {"Accept": "application/json"});
    setState(() {
      product = json.decode(response.body)['data'];
    });

    setState(() {
      productImage = product[0]['productImage'];
    });
    // final prefs = await SharedPreferences.getInstance();
    loader = true;
    return "Successfull";
  }

  _saveQtyValue(id, price) async {
    print(id);
    final prefs = await SharedPreferences.getInstance();
    List<String> show_obj = prefs.getStringList('obj_list') ?? List<String>();
    listobj = show_obj;
    print('price===$price');
    obj = {'id': id, 'qty': qty, 'price' : price};
    print('obj====$obj');
    listobj.add(json.encode(obj));
    prefs.setStringList('obj_list', listobj);
    print("in product view ===$show_obj");



  List<String> show_price = prefs.getStringList('show_price') ?? List<String>();
    List<String> listPrice = show_price;
    listPrice.add(price);
    prefs.setStringList('show_price', listPrice);



    List<String> show_id = prefs.getStringList('id_list') ?? List<String>();
    List<String> list = show_id;
    list.add(id);
    prefs.setStringList('id_list', list);
    Toast.show("Added to cart", context,
        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    loader = true;
    setState(() {
      isaddtocart = false;
    });
  }

  addtowishlist(id) async {
    final prefs = await SharedPreferences.getInstance();
    var show_token = prefs.getString('jwt_token');

    if (show_token == null) {
      print('call if');
      Navigator.of(context).pushNamed("/login");
    } else {
      List<String> show_wishid =
          prefs.getStringList('id_wishlist') ?? List<String>(); // <-EDITED HERE

      List<String> wishlist = show_wishid;
      wishlist.add(id);
      prefs.setStringList('id_wishlist', wishlist);

      var response = await http.post(
        config.baseUrl + 'customer/add-product-to-wishlist',
        headers: {"Authorization": json.decode(show_token)},
        body: {'productId': id},
      );
      loader = true;
      setState(() {
        iswishlisted = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(this.widget.name),
          actions: [
            Icon(
              Icons.notifications,
              color: Colors.yellowAccent,
              size: 24.0,
            ),
          ],
        ),
        body: Center(
            child: loader == true
                ? CustomScrollView(
                    slivers: <Widget>[
                      SliverList(
                          delegate: SliverChildListDelegate([
                        Column(children: [
                          CarouselSlider(
                            height: 200.0,
                            items: productImage.map((i) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 5.0),
                                      child: Image.network(
                                          config.mediaUrl +
                                              '${i['containerName']}' +
                                              '${i['image']}',
                                          width: 200,
                                          height: 200,
                                          fit: BoxFit.fill));
                                },
                              );
                            }).toList(),
                          ),
                        ]),
                      ])),
                      SliverList(
                          delegate: SliverChildListDelegate([
                        Row(children: <Widget>[
                          Expanded(
                            child: SizedBox(
                                height: 700.0,
                                child: new ListView.builder(
                                  itemCount: product.length,
                                  itemBuilder: (BuildContext ctxt, int i) {
                                    return SizedBox(
                                      child: Card(
                                        color: Colors.grey[200],
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              right: 5.0, left: 5.0),
                                          child: new Container(
                                              margin: EdgeInsets.all(10),
                                              child: Column(
                                                children: <Widget>[
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      '${product[i]['name']}',
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                          fontSize: 15.0),
                                                    ),
                                                  ),
                                                  new Divider(),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      'Category: ${product[i]['Category'][0]['categoryName']}',
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: TextStyle(
                                                          fontSize: 15.0),
                                                    ),
                                                  ),
                                                  new Divider(),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      'Availability : ${product[i]['price']}',
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: TextStyle(
                                                          fontSize: 15.0),
                                                    ),
                                                  ),
                                                  new Divider(),
                                                  Align(
                                                      child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Column(
                                                        children: <Widget>[
                                                          Text(
                                                            'Rs. : ${product[i]['price']}',
                                                            textAlign:
                                                                TextAlign.right,
                                                            style: TextStyle(
                                                                fontSize: 15.0,
                                                                color:
                                                                    Colors.red),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  )),
                                                  new Divider(),
                                                  iswishlisted == true
                                                      ? GestureDetector(
                                                          onTap: () {
                                                            addtowishlist(
                                                                '${product[i]['productId']}');
                                                          },
                                                          child: Align(
                                                            alignment: Alignment
                                                                .center,
                                                            child: Icon(
                                                              Icons.favorite,
                                                              color: Colors
                                                                  .deepPurple,
                                                              size: 40.0,
                                                            ),
                                                          ),
                                                        )
                                                      : GestureDetector(
                                                          onTap: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          WishlistScreen(),
                                                                ));
                                                          },
                                                          child: Align(
                                                            alignment: Alignment
                                                                .center,
                                                            child: Icon(
                                                              Icons.favorite,
                                                              color: Colors.red,
                                                              size: 40.0,
                                                            ),
                                                          ),
                                                        ),
                                                  new Divider(),
                                                  Align(
                                                    child: Card(
                                                        child:
                                                            isaddtocart == true
                                                                ? FlatButton(
                                                                    onPressed:
                                                                        () => {
                                                                      _saveQtyValue(
                                                                          '${product[i]['productId']}','${product[i]['price']}')
                                                                    },
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            94,
                                                                            199,
                                                                            182,
                                                                            0.9),
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            10.0),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: <
                                                                          Widget>[
                                                                        Icon(Icons
                                                                            .shopping_cart),
                                                                        Text(
                                                                          "   Add to Cart",
                                                                        )
                                                                      ],
                                                                    ),
                                                                  )
                                                                : FlatButton(
                                                                    onPressed:
                                                                        () => {
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                CartScreen(),
                                                                          ))
                                                                    },
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            94,
                                                                            199,
                                                                            182,
                                                                            0.9),
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            10.0),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: <
                                                                          Widget>[
                                                                        Icon(Icons
                                                                            .shopping_basket),
                                                                        Text(
                                                                          "   Go to Cart",
                                                                        )
                                                                      ],
                                                                    ),
                                                                  )),
                                                  ),
                                                  new Divider(),
                                                  Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Text(
                                                      'Description',
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Html(
                                                        data:
                                                            '${product[i]['description']}',
                                                      )),
                                                ],
                                              )),
                                        ),
                                      ),
                                    );
                                  },
                                )),
                          ),
                        ]),
                      ])),
                    ],
                  )
                : Align(
                    alignment: Alignment.center,
                    child: SpinKitCircle(color: Colors.deepPurple),
                  )));
  }
}
