import 'package:flutter/material.dart';
import 'package:spurtcommerce/screens/cart.dart';
import 'package:spurtcommerce/screens/profile.dart';
import 'package:spurtcommerce/screens/wishlist.dart';
import 'package:spurtcommerce/screens/home.dart';

const String _AccountName = 'Spurt Commerce';
const String _AccountEmail = 'abc@gmail.com';

class BottomTabScreen extends StatefulWidget {
  @override
  BottomTabScreenState createState() => BottomTabScreenState();
}

class BottomTabScreenState extends State<BottomTabScreen> {
  List Tabs = [HomeScreen(), WishlistScreen(), CartScreen(), ProfileScreen()];
  _onTap(int index) {
    Navigator.of(context)
        .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
      return Tabs[index];
    }));
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
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
    );
  }
}
