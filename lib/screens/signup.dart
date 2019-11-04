import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:spurtcommerce/config.dart' as config;
import 'package:toast/toast.dart';

const String _AccountName = 'Spurt Commerce';
const String _AccountEmail = 'abc@gmail.com';
 

class SignupScreen extends StatefulWidget {
  @override
  SignupScreenState createState() => SignupScreenState();
}

class SignupScreenState extends State<SignupScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPassword = TextEditingController();
  TextEditingController _phoneNumber = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  Future<http.Response> signup(
      ) async {
    if (_emailController.text != '' &&
        _passwordController.text != '' &&
        _nameController.text != '' &&
        _phoneNumber.text != '' &&
        _confirmPassword.text != '') {
      final response = await http
          .post(config.baseUrl+'customer/register', body: {
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

      Navigator.of(context).pop();
      return response;
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
        title: Text('Signup'),
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
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: "name",
                        icon: Icon(
                          Icons.person,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
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
                    TextFormField(
                      controller: _confirmPassword,
                      decoration: InputDecoration(
                        labelText: "Confirm Password",
                        icon: Icon(
                          Icons.lock,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      obscureText: true,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _phoneNumber,
                      decoration: InputDecoration(
                        labelText: "Phone Number",
                        icon: Icon(
                          Icons.lock,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      // obscureText: true,
                    ),
                    RaisedButton(
                      onPressed: () {
                        // signup(_emailController.text, _passwordController.text,
                        //     _nameController.text,_confirmPassword.text,_phoneNumber.value);
                        signup();
                      },
                      child: Text(
                        'Signup',
                        style:
                            TextStyle(color: Colors.blueAccent, fontSize: 18.0),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed("/login");
                      },
                      child: const Text(
                        'Already have an account. Login',
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
