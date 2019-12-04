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
  bool autoValidate = false;

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

/*
 This Function contains validate Email. this call from widget
 */
  String validateEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Email is required";
    } else if (!regExp.hasMatch(value)) {
      return "Invalid Email";
    } else {
      return null;
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
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
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
                    Image.asset(
                      'assets/logo.png',
                      width: 200,
                      height: 200,
                    ),
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
                        validator: validateEmail),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: "password",
                        icon: Icon(
                          Icons.lock,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      validator: (String arg) {
                        if (!(arg.length > 8) && arg.isNotEmpty)
                          return 'Password must be less than 8 charater';
                        else
                          return null;
                      },
                      obscureText: true,
                    ),
                    RaisedButton(
                      color: Colors.deepPurple,
                      onPressed: () {
                        login();
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(color: Colors.white, fontSize: 18.0),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed("/signup");
                      },
                      child: const Text(
                        'New Here? Create Account',
                        style:
                            TextStyle(color: Colors.deepPurple, fontSize: 18.0),
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
