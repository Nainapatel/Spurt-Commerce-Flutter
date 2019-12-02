import 'package:flutter/material.dart';
import 'package:spurtcommerce/screens/drawer.dart';

void main() {
  runApp(new PlaceorderScreen());
}

class PlaceorderScreen extends StatefulWidget {
  @override
  PlaceorderScreenState createState() => PlaceorderScreenState();
}

class PlaceorderScreenState extends State<PlaceorderScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: DrawerScreen(),
      // bottomNavigationBar: BottomTabScreen(),
      appBar: new AppBar(
        title: new Text('Address'),
      ),
    );
  }
}
