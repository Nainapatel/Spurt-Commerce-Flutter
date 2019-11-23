import 'package:flutter/material.dart';
import 'package:spurtcommerce/screens/home.dart';
import 'package:spurtcommerce/screens/login.dart';
import 'package:spurtcommerce/screens/signup.dart';
import 'package:spurtcommerce/screens/cart.dart';
import 'package:spurtcommerce/screens/profile.dart';
import 'package:spurtcommerce/screens/wishlist.dart';
import 'package:spurtcommerce/screens/subCategory.dart';
import 'package:spurtcommerce/screens/featuredProduct.dart';
import 'package:spurtcommerce/screens/productView.dart';
import 'package:spurtcommerce/screens/categoryProductlist.dart';
import 'package:spurtcommerce/screens/editprofile.dart';

class Routes {
  var routes = <String, WidgetBuilder>{
    "/dashboard": (BuildContext context) => new HomeScreen(),
    "/wishlist": (BuildContext context) => new WishlistScreen(),
    "/cart": (BuildContext context) => new CartScreen(),
    "/profile": (BuildContext context) => new ProfileScreen(),
    "/subCategory": (BuildContext context) => new SubCategoryScreen(),
    "/featuredProduct": (BuildContext context) => new FeaturedProductScreen(),
    "/productView": (BuildContext context) => new ProductViewScreen(),
    "/categoryProductlist": (BuildContext context) =>
        new CategoryProductlistScreen(),
    "/login": (BuildContext context) => new LoginScreen(),
    "/signup": (BuildContext context) => new SignupScreen(),
    "/editprofile": (BuildContext context) => new EditprofileScreen(),
  };

  Routes() {
    runApp(new MaterialApp(
      title: "Flutter Flat App",
      home: HomeScreen(),
      theme: ThemeData(
        primaryColor: Colors.deepPurple,
      ),
      routes: routes,
    ));
  }
}
