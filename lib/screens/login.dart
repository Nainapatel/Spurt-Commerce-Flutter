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
  TextEditingController _forgotemailController = TextEditingController();
  bool autoValidate = false;
  bool isForgorpassword = false;

  Future<http.Response> login() async {
    final response = await http.post(config.baseUrl + 'customer/login', body: {
      'emailId': _emailController.text,
      'password': _passwordController.text,
    });
    print("res in login screen ====${json.decode(response.body)['message']}");

    if (json.decode(response.body)['message'] == 'Invalid Password') {
      print("invalid password call if");
      Toast.show("Invalid Password", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } else if (json.decode(response.body)['message'] == 'User not found'){
       Toast.show("User not found", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
    else {
      print("call else in login screen");

      Navigator.of(context).pushNamed("/dashboard");

      Toast.show("Login Successfully", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      _emailController.text = '';
      _passwordController.text = '';
      list = json.decode(response.body)['data'];

      final prefs = await SharedPreferences.getInstance();
      prefs.setString('jwt_token', jsonEncode(list['token']));
    }

    return response;
  }

/*
 This Function contains validate Email. this call from widget
 */
  String validateEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (!(regExp.hasMatch(value)) && value.isNotEmpty) {
      return "Invalid Email";
    } else {
      return null;
    }
  }

  forgotpassword() async {
    print("call====${_forgotemailController.text} ");

    final response =
        await http.post(config.baseUrl + 'customer/forgot-password', body: {
      'emailId': _forgotemailController.text,
    });
    print("res===login======${response.body}");
    Toast.show(
        "Thank you,Your password send to your mail id please check your email.",
        context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.BOTTOM);
    Navigator.of(context).pushNamed("/login");
    _forgotemailController.text = '';

    return response;
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
          child: isForgorpassword == false
              ? SingleChildScrollView(
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
                                  return 'Password must not be less than 8 charater';
                                else
                                  return null;
                              },
                              obscureText: true,
                            ),
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isForgorpassword = true;
                                  });
                                },
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 15.0),
                                  ),
                                )),
                            _emailController.text.isNotEmpty &&
                                    _passwordController.text.isNotEmpty
                                ? RaisedButton(
                                    color: Colors.deepPurple,
                                    onPressed: () {
                                      login();
                                    },
                                    child: Text(
                                      'Login',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18.0),
                                    ),
                                  )
                                : RaisedButton(
                                    color: Colors.grey,
                                    onPressed: () {
                                      null;
                                    },
                                    child: Text(
                                      'Login',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18.0),
                                    ),
                                  )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              : SingleChildScrollView(
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
                                controller: _forgotemailController,
                                decoration: InputDecoration(
                                  labelText: "email",
                                  //  color: Colors.white,
                                  icon: Icon(
                                    Icons.email,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                validator: validateEmail),
                            Row(
                              children: <Widget>[
                                RaisedButton(
                                  color: Colors.deepPurple,
                                  onPressed: () {
                                    setState(() {
                                      isForgorpassword = false;
                                    });
                                  },
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18.0),
                                  ),
                                ),
                                Spacer(),
                                RaisedButton(
                                  color: Colors.deepPurple,
                                  onPressed: () {
                                    forgotpassword();
                                  },
                                  child: Text(
                                    'Send Password',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18.0),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
        ),
        bottomNavigationBar: isForgorpassword == false
            ? Container(
                height: 45.0,
                color: Colors.deepPurple,
                child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 5,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed("/signup");
                              },
                              child: const Text(
                                'New Here? Create Account',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18.0),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )))
            : null);
  }
}
