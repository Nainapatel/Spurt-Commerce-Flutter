import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:spurtcommerce/config.dart' as config;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:spurtcommerce/screens/categoryProductlist.dart';
import 'package:spurtcommerce/screens/login.dart';
import 'package:spurtcommerce/services.dart';

const String _AccountName = 'Spurt Commerce';
const String _AccountEmail = 'abc@gmail.com';

class DrawerScreen extends StatefulWidget {
  @override
  DrawerScreenState createState() => DrawerScreenState();
}

class DrawerScreenState extends State<DrawerScreen> {
  List categoryData;
  bool loader = false;
  @override
  void initState() {
    super.initState();
    this.getCategoty(); // Function for category display
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
    loader = true;
    return "Successfull";
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: new ListView(
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
        new Container(
          margin: const EdgeInsets.only(left: 15.0),
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed("/dashboard");
                },
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'HOME',
                    style:
                        TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
        ),
        loader == true
            ? new Container(
                child: Column(
                    children: categoryData.map((i) {
                  return ListTile(
                      title: new Text('${i['name']}'),
                      onTap: () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CategoryProductlistScreen(
                                    id: '${i["categoryId"]}',
                                    name:'${i['name']}',
                                  ),
                                ))
                          });
                }).toList()),
              )
            : Align(
                alignment: Alignment.center,
                child: SpinKitCircle(color: Colors.deepPurple),
              ),
        Container(
          margin: const EdgeInsets.only(left: 15.0),
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  _logout();
                },
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'LOGOUT',
                    style:
                        TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    ));
  }

  Future<String> _logout() async {
    print('in logout');
    String data = await logout();
    print(data);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
    return data;
  }
}
