import 'package:flutter/material.dart';
import 'package:spurtcommerce/screens/drawer.dart';
import 'package:spurtcommerce/screens/bottomTab.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:spurtcommerce/config.dart' as config;

void main() {
  runApp(new ProfileScreen());
}

class ProfileScreen extends StatefulWidget {
  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  List<dynamic> profile;
  var email;
  var name;

  @override
  void initState() {
    super.initState();
    this.getProfile(); // Function for get product details
  }

  Future<String> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    var show_token = prefs.getString('jwt_token');

    if (show_token == null) {
      print('call if');
      Navigator.of(context).pushNamed("/login");
    } else {
      print('call else');
      var response = await http.get(
        Uri.encodeFull(config.baseUrl + 'customer/get-profile'),
        headers: {"Authorization": json.decode(show_token)},
      );
      setState(() {
        profile = json.decode(response.body)['data'];
      });
      print('profile======${json.decode(response.body)['data']['firstName']}');
      setState(() {
        email = json.decode(response.body)['data']['email'];
      });
      setState(() {
        name = json.decode(response.body)['data']['firstName'];
      });


      return "Successfull";
    }
  }

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
        body: Center(
          child: Column(children: <Widget>[
            Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                Container(
                    child: Image.asset('assets/favicon.png',
                        width: 100, height: 100),
                    color: Colors.deepPurple[300],
                    width: MediaQuery.of(context).size.width / 0.5,
                    height: 200),
                FractionalTranslation(
                  translation: Offset(0.0, 0.5),
                  child: Container(
                    child: Image.asset('assets/user.png',
                        width: MediaQuery.of(context).size.width / 3.0,
                        height: MediaQuery.of(context).size.width / 3.0,
                        fit: BoxFit.fill),
                  ),
                )
              ],
            ),
            Container(
                margin: const EdgeInsets.only(top: 60.0, left: 10.0),
                child: ListView.builder(
                    itemCount: profile.length,
                    itemBuilder: (BuildContext ctxt, int i) {
                      print('in widget${profile.length}');
                     return Row(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'First Name',
                              style: TextStyle(
                                  fontSize: 15, color: Colors.grey[300]),
                            ),
                          ),
                          Divider(),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              '${profile[i]['email']}',
                              style:
                                  TextStyle(fontSize: 15, color: Colors.black),
                            ),
                          )
                        ],
                      );
                    }))
          ]),
        ));
  }
}
