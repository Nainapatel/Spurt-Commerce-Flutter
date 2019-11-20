import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:spurtcommerce/config.dart' as config;
import 'package:toast/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import 'package:spurtcommerce/screens/drawer.dart';

class LoginScreen extends StatefulWidget {
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  Map<String, dynamic> list;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _passwordController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  Future<http.Response> login() async {
    if (_emailController.text != '' && _passwordController.text != '') {
      final response =
          await http.post(config.baseUrl + 'customer/login', body: {
        'emailId': _emailController.text,
        'password': _passwordController.text,
      });
      Navigator.of(context).pushNamed("/dashboard");

      Toast.show("Login Successfully", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      _emailController.text = '';
      _passwordController.text = '';
      list = json.decode(response.body)['data'];

      final prefs = await SharedPreferences.getInstance();
      prefs.setString('jwt_token', jsonEncode(list['token']));

      return response;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerScreen(),
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Container(
        child: Container(
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: new AssetImage("login.png"),
              colorFilter: new ColorFilter.mode(
                  Colors.red.withOpacity(0.3), BlendMode.dstATop),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                autovalidate: true,
                onWillPop: () async {
                  return false;
                },
                onChanged: () {},
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
                      autofocus: true,
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: "email",
                        //  color: Colors.white,
                        icon: Icon(
                          Icons.email,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: "password",
                        icon: Icon(
                          Icons.lock,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      obscureText: true,
                    ),
                    RaisedButton(
                      onPressed: () {
                        login();
                      },
                      child: Text(
                        'Login',
                        style:
                            TextStyle(color: Colors.blueAccent, fontSize: 18.0),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed("/signup");
                      },
                      child: const Text(
                        'New Here? Create Account',
                        style:
                            TextStyle(color: Colors.blueAccent, fontSize: 18.0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
