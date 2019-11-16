import 'package:flutter/material.dart';
import 'package:spurtcommerce/screens/drawer.dart';
import 'package:spurtcommerce/screens/bottomTab.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:spurtcommerce/config.dart' as config;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(new WishlistScreen());
}

class WishlistScreen extends StatefulWidget {
  @override
  WishlistScreenState createState() => WishlistScreenState();
}

class WishlistScreenState extends State<WishlistScreen> {
  List wishlist;
  @override
  void initState() {
    super.initState();
    this.getWishlist(); // Function for get product details
  }

  /*
 *  For Product get by id
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
      print("in wishlist==0${response.body}");
      setState(() {
        wishlist = json.decode(response.body)['data'];
      });
      return "Successfull";
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        drawer: DrawerScreen(),
        bottomNavigationBar: BottomTabScreen(),
        appBar: new AppBar(
          title: new Text('Wishlist'),
          actions: [
            Icon(
              Icons.notifications,
              color: Colors.yellowAccent,
              size: 24.0,
            ),
          ],
        ),
        body: Center(
          child: Card(
            child:Row(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text("hey Happy")
                ],
              ),
              Column(children: <Widget>[
                Text("Bhalodiya")
              ],)
            ],
          ),
          )
        ));
  }
}
