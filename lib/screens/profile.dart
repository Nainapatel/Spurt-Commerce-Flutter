import 'package:flutter/material.dart';
import 'package:spurtcommerce/screens/drawer.dart';
import 'package:spurtcommerce/screens/bottomTab.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:spurtcommerce/config.dart' as config;
import 'package:spurtcommerce/screens/editprofile.dart';

void main() {
  runApp(new ProfileScreen());
}

class ProfileScreen extends StatefulWidget {
  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  var email;
  var name;
  var number;
  var username;
  var id;
  var avtar;
  var avatarPath;
  bool isavtar = true;

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

      print('profile======${json.decode(response.body)['data']['firstName']}');
      setState(() {
        email = json.decode(response.body)['data']['email'];
        name = json.decode(response.body)['data']['firstName'];
        number = json.decode(response.body)['data']['mobileNumber'];
        username = json.decode(response.body)['data']['username'];
        id = json.decode(response.body)['data']['id'];
        avtar = json.decode(response.body)['data']['avatar'];
        avatarPath = json.decode(response.body)['data']['avatarPath'];
      });
      if (avtar == '') {
        setState(() {
          isavtar = false;
        });
      } else {
        setState(() {
          isavtar = true;
        });
      }
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
          actions: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditprofileScreen(
                        id: '$id',
                      ),
                    ));
              },
              child: Icon(
                Icons.edit,
                color: Colors.white,
                size: 24.0,
              ),
            )
          ],
        ),
        body: Center(
            child: Container(
          // decoration: new BoxDecoration(
          //   image: new DecorationImage(
          //     image: new AssetImage("profilebg.jpg"),
          //     colorFilter: new ColorFilter.mode(
          //         Colors.red.withOpacity(0.3), BlendMode.dstATop),
          //     fit: BoxFit.cover,
          //   ),
          // ),
          child: Column(children: <Widget>[
            Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                Container(
                    child:
                        Image.asset('assets/profilebg.jpg', fit: BoxFit.fill),
                    width: MediaQuery.of(context).size.width / 0.5,
                    height: 200),
                FractionalTranslation(
                    translation: Offset(0.0, 0.5),
                    child: Container(
                      child: ClipRRect(
                        borderRadius: new BorderRadius.circular(90.0),
                        child: isavtar == true
                            ? Image.network(
                                config.mediaUrl + '$avatarPath' + '$avtar',
                                width: MediaQuery.of(context).size.width / 3.0,
                                height: MediaQuery.of(context).size.width / 3.0,
                                fit: BoxFit.fill)
                            : Image.asset('assets/user.png',
                                width: MediaQuery.of(context).size.width / 3.0,
                                height: MediaQuery.of(context).size.width / 3.0,
                                fit: BoxFit.fill),
                      ),
                    ))
              ],
            ),
            Container(
                margin: const EdgeInsets.only(top: 60.0, left: 10.0),
                child: Column(children: <Widget>[
                  Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Name',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          '$name',
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      ),
                      Divider(),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Username',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          '$username',
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      ),
                      Divider(),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Email',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          '$email',
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      ),
                      Divider(),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Phone number',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          '$number',
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      ),
                      Divider(),
                    ],
                  ),
                ]))
          ]),
        )));
  }
}
