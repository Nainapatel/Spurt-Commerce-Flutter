import 'package:flutter/material.dart';
import 'package:spurtcommerce/screens/drawer.dart';
import 'package:spurtcommerce/screens/bottomTab.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:spurtcommerce/config.dart' as config;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

void main() {
  runApp(new WishlistScreen());
}

class WishlistScreen extends StatefulWidget {
  @override
  WishlistScreenState createState() => WishlistScreenState();
}

class WishlistScreenState extends State<WishlistScreen> {
  List wishlist;
  bool loader = false;
  @override
  void initState() {
    super.initState();
    this.getWishlist(); // Function for get product details
  }

  /*
 *  Fetch Product get by id
 */
  Future<String> getWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    var show_token = prefs.getString('jwt_token');

    if (show_token == null) {
      print('call if');
      Navigator.of(context).pushNamed("/login");
    } else {
      var response = await http.get(
        Uri.encodeFull(config.baseUrl + 'customer/wishlist-product-list'),
        headers: {"Authorization": json.decode(show_token)},
      );

      setState(() {
        wishlist = json.decode(response.body)['data'];
      });
      loader = true;
      return "Successfull";
    }
  }

/*
 * @params {String} id for remove product
 * This Function contains remove product from wishlist
 */
  removeWishlistProduct(id) async {
    final prefs = await SharedPreferences.getInstance();
    var show_token = prefs.getString('jwt_token');
    var response = await http.delete(
      Uri.encodeFull(config.baseUrl + 'customer/wishlist-product-delete/$id'),
      headers: {"Authorization": json.decode(show_token)},
    );
    getWishlist();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: DrawerScreen(),
      // bottomNavigationBar: BottomTabScreen(),
      appBar: new AppBar(
        title: new Text('Wishlist'),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed("/cart");
            },
            child: Icon(
              Icons.shopping_cart,
              color: Colors.white,
              size: 24.0,
            ),
          ),
        ],
      ),
      body: Center(
          child: wishlist.length == 0
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Your Wish List is empty",
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
              : loader == true
                  ? Column(
                      children: wishlist.map((i) {
                      return Card(
                        child: Row(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Image.network(
                                  config.mediaUrl +
                                      '${i['productImage']['containerName']}' +
                                      '${i['productImage']['image']}',
                                  width: 100,
                                  height: 100,
                                ),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    SizedBox(
                                        width: 250,
                                        child: Column(
                                          children: <Widget>[
                                            Align(
                                              child: Text(
                                                  '${i['product']['name']}'),
                                            ),
                                            new Divider(),
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                'Rs. ${i['product']['price']}',
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                            ),
                                            Row(
                                              children: <Widget>[
                                                new Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 30.0),
                                                  child: FlatButton(
                                                    color: Colors.grey[200],
                                                    textColor: Colors.grey,
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    splashColor:
                                                        Colors.blueAccent,
                                                    onPressed: () {
                                                      removeWishlistProduct(
                                                          '${i['_id']}');
                                                    },
                                                    child: Text(
                                                      'Remove',
                                                      style: TextStyle(
                                                          fontSize: 12.0),
                                                    ),
                                                  ),
                                                ),
                                                new Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 30.0),
                                                  child: FlatButton(
                                                    color: Colors.deepPurple,
                                                    textColor: Colors.white,
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    splashColor:
                                                        Colors.blueAccent,
                                                    onPressed: () {
                                                      // Navigator.push(
                                                      //     context,
                                                      //     MaterialPageRoute(
                                                      //       builder: (context) =>
                                                      //           SubCategoryScreen(
                                                      //               id: '${i["categoryId"]}',
                                                      //               name: '${i["name"]}'),
                                                      //     ));
                                                    },
                                                    child: Text(
                                                      'Add To Cart',
                                                      style: TextStyle(
                                                          fontSize: 12.0),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ))
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      );
                    }).toList())
                  : Align(
                      alignment: Alignment.center,
                      child: SpinKitCircle(color: Colors.deepPurple),
                    )),
    );
  }
}
