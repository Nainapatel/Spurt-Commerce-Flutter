import 'package:flutter/material.dart';
import 'package:spurtcommerce/screens/home.dart';
import 'package:spurtcommerce/screens/login.dart';
import 'package:spurtcommerce/screens/signup.dart';
import 'package:spurtcommerce/screens/cart.dart';
import 'package:spurtcommerce/screens/profile.dart';
import 'package:spurtcommerce/screens/wishlist.dart';
import 'package:spurtcommerce/screens/subCategory.dart';


class Routes {
  var routes = <String, WidgetBuilder>{
    "/dashboard": (BuildContext context) => new HomeScreen(),
    "/login": (BuildContext context) => new LoginScreen(),
    "/signup": (BuildContext context) => new SignupScreen(),
    "/wishlist":(BuildContext context) => new WishlistScreen(),
    "/cart":(BuildContext context) => new CartScreen(),
    "/profile":(BuildContext context) => new ProfileScreen(),
    "/subCategory":(BuildContext context) => new SubCategoryScreen(),
    
  };

  
  Routes() {
    runApp(new MaterialApp(
      title: "Flutter Flat App",
      home: new HomeScreen(),
      theme: ThemeData(
        primaryColor: Colors.blueAccent[300],
      ),
      routes: routes,
    ));
  }
}

// class BottomTab extends StatefulWidget {
//   @override
//  BottomTabScreenState createState() => BottomTabScreenState();
// }
// class BottomTabScreenState extends State<BottomTab> {
// List Tabs = [HomeScreen(), WishlistScreen(), CartScreen(), ProfileScreen()];
//   _onTap(int index) {
//     Navigator.of(context)
//         .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
//       return Tabs[index];
//     }));
//   }
//  @override
//   Widget build(BuildContext context) {
//     return new Scaffold(
//        bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         items: <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             title: Text("Home"),
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.favorite),
//             title: Text("Wishlist"),
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             title: Text("Cart"),
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.settings),
//             title: Text("Profile"),
//           ),
//         ],
//         onTap: _onTap,
//       ),
//     );
//     }
// }
