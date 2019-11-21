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
                    child: isavtar == true
                        ? Container(
                            width: MediaQuery.of(context).size.width / 3.0,
                            height: MediaQuery.of(context).size.width / 3.0,
                            decoration: new BoxDecoration(
                              color: const Color(0xff7c94b6),
                              image: new DecorationImage(
                                image: new NetworkImage(
                                    config.mediaUrl + '$avatarPath' + '$avtar'),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: new BorderRadius.all(
                                  new Radius.circular(90.0)),
                              border: new Border.all(
                                color: Colors.deepPurple,
                                width: 3.0,
                              ),
                            ),
                          )
                        : Container(
                            width: MediaQuery.of(context).size.width / 3.0,
                            height: MediaQuery.of(context).size.width / 3.0,
                            decoration: new BoxDecoration(
                              color: const Color(0xff7c94b6),
                              image: new DecorationImage(
                                image: new ExactAssetImage('assets/user.png'),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: new BorderRadius.all(
                                  new Radius.circular(90.0)),
                              border: new Border.all(
                                color: Colors.deepPurple,
                                width: 3.0,
                              ),
                            ),
                          ))
              ],
            ),
            Container(
                margin: const EdgeInsets.only(top: 60.0, left: 25.0),
                child: Column(children: <Widget>[
                  Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Name',
                          style: TextStyle(
                              fontSize: 18, color: Colors.deepPurple[300]),
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
                          style: TextStyle(
                              fontSize: 18, color: Colors.deepPurple[300]),
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
                          style: TextStyle(
                              fontSize: 18, color: Colors.deepPurple[300]),
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
                          style: TextStyle(
                              fontSize: 18, color: Colors.deepPurple[300]),
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
