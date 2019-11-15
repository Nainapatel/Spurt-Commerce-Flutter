import 'package:flutter/material.dart';
import 'package:spurtcommerce/screens/drawer.dart';
import 'package:spurtcommerce/screens/bottomTab.dart';

void main() {
  runApp(new WishlistScreen());
}

class WishlistScreen extends StatefulWidget {
  @override
  WishlistScreenState createState() => WishlistScreenState();
}

class WishlistScreenState extends State<WishlistScreen> {
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
    );
  }
}




