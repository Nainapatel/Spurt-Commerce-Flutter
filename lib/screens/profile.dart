import 'package:flutter/material.dart';
import 'package:spurtcommerce/screens/drawer.dart';
import 'package:spurtcommerce/screens/bottomTab.dart';

void main() {
  runApp(new ProfileScreen());
}

class ProfileScreen extends StatefulWidget {
  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: DrawerScreen(),
      bottomNavigationBar: BottomTabScreen(),
      appBar: new AppBar(
        title: new Text('Profile'),
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
