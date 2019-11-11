import 'package:flutter/material.dart';
import 'package:spurtcommerce/screens/wishlist.dart';
import 'package:spurtcommerce/screens/profile.dart';
import 'package:spurtcommerce/screens/home.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:spurtcommerce/config.dart' as config;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spurtcommerce/screens/cartView.dart';
const String _AccountName = 'Spurt Commerce';
const String _AccountEmail = 'abc@gmail.com';

void main() {
  runApp(new CartScreen());
}

class CartScreen extends StatefulWidget {
  @override
  CartScreenState createState() => CartScreenState();
}

class CartScreenState extends State<CartScreen> {
  List cartProduct;
  List cartProductArray = [];
  List cart = [];

  List Tabs = [HomeScreen(), WishlistScreen(), CartScreen(), ProfileScreen()];
  _onTap(int index) {
    Navigator.of(context)
        .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
      return Tabs[index];
    }));
  }

  @override
  void initState() {
    super.initState();
    // this.getCartProduct(); // Function for get product details
  }

  // Future<List> getCartProduct() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   List<String> show_id = prefs.getStringList('id_list') ?? List<String>();
  //   print('id==cart==$show_id');
  //   print(show_id.length);

  //   for (var i = 0; i <= show_id.length; i++) {
  //     var response = await http.get(
  //         Uri.encodeFull(
  //             config.baseUrl + 'product-store/productdetail/${show_id[i]}'),
  //         headers: {"Accept": "application/json"});

  //     cartProductArray.addAll({response.body});

  //     print(
  //         'cartProductArray=======${cartProductArray.length}=============$cartProductArray');
  //     cart = cartProductArray;
  //     print("cart=${cart.length}");
  //     print('==>>>>>>${cart[i]['status']}');
  //     // setState(() {
  //     //   cartProduct = cartProductArray;
  //     // });
  //   }
  //   print('cart====>>>>>$cartProduct');

  //   // return "Successfull";
  // }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        drawer: new Drawer(
            child: new ListView(
                padding: const EdgeInsets.only(top: 0.0),
                children: <Widget>[
              new UserAccountsDrawerHeader(
                  accountName: const Text(_AccountName),
                  accountEmail: const Text(_AccountEmail),
                  otherAccountsPictures: <Widget>[
                    new GestureDetector(
                      onTap: () => Navigator.of(context).pushNamed("/login"),
                      child: new Semantics(
                        label: 'Switch Account',
                        child: new Text(
                          "Login",
                          style:
                              TextStyle(fontSize: 15.0, color: Colors.black87),
                        ),
                      ),
                    )
                  ]),
              new ListTile(
                leading: new Icon(Icons.lightbulb_outline),
                title: new Text('Notes'),
                // onTap: () => _onListTileTap(context),
              ),
              new Divider(),
              new ListTile(
                leading: new Text('Label'),
                trailing: new Text('Edit'),
                // onTap: () => _onListTileTap(context),
              ),
              new ListTile(
                leading: new Icon(Icons.label),
                title: new Text('Expense'),
                // onTap: () => _onListTileTap(context),
              ),
              new ListTile(
                leading: new Icon(Icons.label),
                title: new Text('Inspiration'),
                // onTap: () => _onListTileTap(context),
              ),
              new ListTile(
                leading: new Icon(Icons.label),
                title: new Text('Personal'),
                // onTap: () => _onListTileTap(context),
              ),
              new ListTile(
                leading: new Icon(Icons.label),
                title: new Text('Work'),
                // onTap: () => _onListTileTap(context),
              ),
              new ListTile(
                leading: new Icon(Icons.add),
                title: new Text('Create new label'),
                // onTap: () => _onListTileTap(context),
              ),
              new Divider(),
              new ListTile(
                leading: new Icon(Icons.archive),
                title: new Text('Archive'),
                // onTap: () => _onListTileTap(context),
              ),
              new ListTile(
                leading: new Icon(Icons.delete),
                title: new Text('Trash'),
                // onTap: () => _onListTileTap(context),
              ),
              new Divider(),
              new ListTile(
                leading: new Icon(Icons.settings),
                title: new Text('Settings'),
                // onTap: () => _onListTileTap(context),
              ),
              new ListTile(
                leading: new Icon(Icons.help),
                title: new Text('Help & feedback'),
                // onTap: () => _onListTileTap(context),
              )
            ])),
        appBar: new AppBar(
          title: new Text('Cart'),
          actions: [
            Icon(
              Icons.notifications,
              color: Colors.yellowAccent,
              size: 24.0,
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text("Home"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              title: Text("Wishlist"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              title: Text("Cart"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text("Profile"),
            ),
          ],
          onTap: _onTap,
        ),
        
          body: Center(
          child: CartView()
        ),
        // body: SingleChildScrollView(          
        //   child: Column(
        //     children: <Widget>[
        //       Expanded(
        //           child: SizedBox(
        //           child: new ListView.builder(
        //         itemCount: cart.length,
        //         itemBuilder: (BuildContext ctxt, int i) {
        //           print(cartProduct.length);
        //           return SizedBox(
        //             child: Card(
        //               child: Text('aaaaaaaaaaa'),
        //             ),
        //           );
        //         },
        //       )))
        //     ],
        //   ),
        // )
        );
  }
}
