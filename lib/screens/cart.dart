import 'package:flutter/material.dart';
import 'package:spurtcommerce/screens/cartView.dart';
import 'package:spurtcommerce/screens/drawer.dart';
import 'package:spurtcommerce/screens/bottomTab.dart';


void main() {
  runApp(new CartScreen());
}

class CartScreen extends StatefulWidget {
  @override
  CartScreenState createState() => CartScreenState();
}

class CartScreenState extends State<CartScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: DrawerScreen(),
      bottomNavigationBar: BottomTabScreen(),
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
      body: Center(child: CartView()),
    );
  }
}
