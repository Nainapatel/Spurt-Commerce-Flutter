import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:spurtcommerce/config.dart' as config;
import 'package:toast/toast.dart';
import 'package:spurtcommerce/screens/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:async';
import 'dart:convert';

class SignupScreen extends StatefulWidget {
  @override
  SignupScreenState createState() => SignupScreenState();
}

class SignupScreenState extends State<SignupScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, dynamic> list;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPassword = TextEditingController();
  TextEditingController _phoneNumber = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  bool _autoValidate = false;
/*
This for Register value
*/
  Future<http.Response> signup() async {
    if (_emailController.text != '' &&
        _passwordController.text != '' &&
        _nameController.text != '' &&
        _phoneNumber.text != '' &&
        _confirmPassword.text != '') {
      final response =
          await http.post(config.baseUrl + 'customer/register', body: {
        'emailId': _emailController.text,
        'password': _passwordController.text,
        'name': _nameController.text,
        'confirmPassword': _confirmPassword.text,
        'phoneNumber': _phoneNumber.text
      });
      print(response.body);
      _nameController.text = '';
      _emailController.text = '';
      _passwordController.text = '';
      _confirmPassword.text = '';
      _phoneNumber.text = '';

      Toast.show("Signup Successfully", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      list = json.decode(response.body)['data'];
      Navigator.of(context).pop();
      print('username======${list['username']}');
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('username', list['username']);
      return response;
    }
  }

/*
 * This Function contains validate Email. this call from widget
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
    _nameController.dispose();
    _passwordController.dispose();
    _confirmPassword.dispose();
    _phoneNumber.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerScreen(),
      appBar: AppBar(
        title: Text('Signup'),
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
                    TextFormField(
                      autofocus: true,
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: "name",
                        icon: Icon(
                          Icons.perm_identity,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      validator: (String arg) {
                        if (!(arg.length > 3) && arg.isNotEmpty)
                          return 'Name must be more than 2 charater';
                        else
                          return null;
                      },
                    ),
                    TextFormField(
                      autofocus: true,
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: "email",
                        icon: Icon(
                          Icons.email,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      validator: validateEmail,
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: "password",
                        icon: Icon(
                          Icons.lock_open,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      validator: (String arg) {
                        if (!(arg.length > 8) && arg.isNotEmpty )
                          return 'Password must be less than 8 charater';
                        else
                          return null;
                      },
                      obscureText: true,
                    ),
                    TextFormField(
                      controller: _confirmPassword,
                      decoration: InputDecoration(
                        labelText: "Confirm Password",
                        icon: Icon(
                          Icons.lock_outline,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      validator: (String arg) {
                        if (!(arg.length > 8) && arg.isNotEmpty )
                          return 'Confirm Password is required';
                        else
                          return null;
                      },
                      obscureText: true,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _phoneNumber,
                      decoration: InputDecoration(
                        labelText: "Phone Number",
                        icon: Icon(
                          Icons.phone_android,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      validator: (String arg) {
                        if ((arg.length > 10 || arg.length < 10 ) &&  arg.isNotEmpty)
                          return 'Phone Number not valid';
                        else
                          return null;
                      },
                      // obscureText: true,
                    ),
                    RaisedButton(
                      color: Colors.deepPurple,
                      onPressed: () {
                        // signup(_emailController.text, _passwordController.text,
                        //     _nameController.text,_confirmPassword.text,_phoneNumber.value);
                        signup();
                      },
                      child: Text(
                        'Signup',
                        style: TextStyle(color: Colors.white, fontSize: 18.0),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed("/login");
                      },
                      child: const Text(
                        'Already have an account. Login',
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
