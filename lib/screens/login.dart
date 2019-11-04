import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:spurtcommerce/config.dart' as config;
import 'package:toast/toast.dart';

const String _AccountName = 'Spurt Commerce';
const String _AccountEmail = 'abc@gmail.com';

class LoginScreen extends StatefulWidget {
  @override
  LoginScreenState createState() => LoginScreenState();
}



class LoginScreenState extends State<LoginScreen> {
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
      FocusScope.of(context).requestFocus(FocusNode());
      Toast.show("Login Successfully", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      _emailController.text = '';
      _passwordController.text = '';
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
      drawer: new Drawer(
          child: new ListView(
              // padding: const EdgeInsets.only(top: 0.0),
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
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Container(
        child: Container(
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: new AssetImage("login.jpg"),
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
