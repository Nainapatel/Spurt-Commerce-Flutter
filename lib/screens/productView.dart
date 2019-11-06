import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:spurtcommerce/config.dart' as config;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

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
  int _counter = 1;

  @override
  void initState() {
    super.initState();
    this.getProduct(); // Function for get product details
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

    print(product[0]['productImage']);
    setState(() {
      productImage = product[0]['productImage'];
    });

    return "Successfull";
  }

/** For Qty Decrement */
  countDecrement() {
    setState(() {
      _counter--;
    });
  }

  /** For Qty Increment */
  countIncrement() {
    setState(() {
      _counter++;
    });
  }

  _saveQtyValue() async {
   
    final prefs = await SharedPreferences.getInstance();
    final key = 'my_int_key';
    final value = _counter;
    prefs.setInt(key, value);
    Toast.show("Added in cart", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
    print('saved $value');
  }

  @override
  Widget build(BuildContext context) {
    print(this.widget.id);
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
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: <Widget>[
                Column(children: [
                  CarouselSlider(
                    height: 200.0,
                    items: productImage.map((i) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                              margin: EdgeInsets.symmetric(horizontal: 5.0),
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
                new Row(children: <Widget>[
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
                                  padding:
                                      EdgeInsets.only(right: 5.0, left: 5.0),
                                  child: new Container(
                                      margin: EdgeInsets.all(10),
                                      child: Column(
                                        children: <Widget>[
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              '${product[i]['name']}',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(fontSize: 15.0),
                                            ),
                                          ),
                                          new Divider(),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              'Category: ${product[i]['Category'][0]['categoryName']}',
                                              textAlign: TextAlign.right,
                                              style: TextStyle(fontSize: 15.0),
                                            ),
                                          ),
                                          new Divider(),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              'Availability : ${product[i]['price']}',
                                              textAlign: TextAlign.right,
                                              style: TextStyle(fontSize: 15.0),
                                            ),
                                          ),
                                          new Divider(),
                                          Align(
                                              child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Column(
                                                children: <Widget>[
                                                  Text(
                                                    'Rs. : ${product[i]['price']}',
                                                    textAlign: TextAlign.right,
                                                    style: TextStyle(
                                                        fontSize: 15.0,
                                                        color: Colors.red),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Text(
                                                    'Qty. :  ',
                                                    style: TextStyle(
                                                        fontSize: 15.0),
                                                  ),
                                                  GestureDetector(
                                                      onTap: () {
                                                        countDecrement();
                                                      },
                                                      child: Text(
                                                        '-     ',
                                                        style: TextStyle(
                                                            fontSize: 20),
                                                      )),
                                                  Text(
                                                    '$_counter',
                                                    style: TextStyle(
                                                        fontSize: 15.0),
                                                  ),
                                                  GestureDetector(
                                                      onTap: () {
                                                        countIncrement();
                                                        
                                                      },
                                                      child: Text(
                                                        '     +',
                                                        style: TextStyle(
                                                            fontSize: 20),
                                                      )),
                                                ],
                                              )
                                            ],
                                          )),
                                          new Divider(),
                                          Align(
                                            alignment: Alignment.center,
                                            child: Icon(
                                              Icons.favorite,
                                              color: Colors.deepPurple,
                                              size: 40.0,
                                            ),
                                          ),
                                          new Divider(),
                                          Align(
                                            child: Card(
                                              elevation: 3,
                                              child: FlatButton(
                                                onPressed: () => {_saveQtyValue()},
                                                color: Color.fromRGBO(
                                                    94, 199, 182, 0.9),
                                                padding: EdgeInsets.all(10.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Icon(Icons.shopping_cart),
                                                    Text(
                                                      "   Add to Cart",
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          new Divider(),
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              'Description',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Align(
                                              alignment: Alignment.center,
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
              ],
            )));
  }
}
