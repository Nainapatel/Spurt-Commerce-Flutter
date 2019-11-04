import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:spurtcommerce/config.dart' as config;
import 'package:spurtcommerce/screens/cart.dart';
import 'package:spurtcommerce/screens/profile.dart';
import 'package:spurtcommerce/screens/subCategory.dart';
import 'package:spurtcommerce/screens/wishlist.dart';

const String _AccountName = 'Spurt Commerce';
const String _AccountEmail = 'abc@gmail.com';

void main() {
  runApp(new HomeScreen());
}

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  List Tabs = [HomeScreen(), WishlistScreen(), CartScreen(), ProfileScreen()];
  _onTap(int index) {
    Navigator.of(context)
        .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
      return Tabs[index];
    }));
  }

  List bannreData;
  List categoryData;
  @override
  void initState() {
    super.initState();
    this.getJSONData();
    this.getCategoty();
  }

/*
 *  For Banner
 */
  Future<String> getJSONData() async {
    var response = await http.get(
        Uri.encodeFull(config.baseUrl + 'list/banner-list'),
        headers: {"Accept": "application/json"});
    setState(() {
      bannreData = json.decode(response.body)['data'];
    });

    return "Successfull";
  }

  /*
 *  For Category
 */
  Future<String> getCategoty() async {
    var response = await http.get(
        Uri.encodeFull(config.baseUrl + 'list/category-list'),
        headers: {"Accept": "application/json"});
    setState(() {
      categoryData = json.decode(response.body)['data'];
    });
    
    return "Successfull";
  }

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
                        style: TextStyle(fontSize: 15.0, color: Colors.black87),
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
        title: new Text('Home'),
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
            icon: Icon(Icons.person),
            title: Text("Cart"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text("Profile"),
          ),
        ],
        onTap: _onTap,
      ),
      body: Container(
          child: Column(
        children: <Widget>[
          Column(children: [
            CarouselSlider(
              height: 200.0,
              items: bannreData.map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        child: Image.network(
                            config.mediaUrlBanner + '${i['image']}',
                            width: MediaQuery.of(context).size.width,
                            height: 200,
                            fit: BoxFit.fill));
                  },
                );
              }).toList(),
            ),
          ]),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categoryData.map((i) {
                return FlatButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  disabledColor: Colors.grey,
                  disabledTextColor: Colors.black,
                  padding: EdgeInsets.all(8.0),
                  splashColor: Colors.blueAccent,
                  
                  onPressed: () {
                    print('${i["categoryId"]}');
                    Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SubCategoryScreen(
                                    id: '${i["categoryId"]}',
                                    name: '${i["name"]}'),
                              ));
                  },
                 
                  child: Text(
                    '${i['name']}',
                    style: TextStyle(fontSize: 12.0),
                  ),
                );
              }).toList(),
            ),
          ),

          Column(children: <Widget>[
           Text('hiiiiii'),
          ],)
        ],
      )),
    );
  }
}
