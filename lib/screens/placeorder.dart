import 'package:flutter/material.dart';
import 'package:spurtcommerce/screens/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:spurtcommerce/config.dart' as config;
import 'package:spurtcommerce/screens/successOrderScreen.dart';
import 'package:toast/toast.dart';
import 'dart:io';

void main() {
  runApp(new PlaceorderScreen());
}

class PlaceorderScreen extends StatefulWidget {
  @override
  PlaceorderScreenState createState() => PlaceorderScreenState();
}

class PlaceorderScreenState extends State<PlaceorderScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _emailcontroller;
  TextEditingController _firstnamecontroller;
  TextEditingController _phonenumbercontroller;
  TextEditingController _addressonecontroller = TextEditingController();
  TextEditingController _addresstwocontroller = TextEditingController();
  TextEditingController _citycontroller = TextEditingController();
  TextEditingController _pincodecontroller = TextEditingController();

  List<dynamic> countryList;
  List<dynamic> stateList;
  var dropdowncountryValue;
  var dropdownstateValue;
  var successOrder;
  bool autovalidate = false;
  bool loader = false;

  @override
  void initState() {
    super.initState();
    getProfile(); // get profile data
    getCountryList(); // get country list in dropdown
    getStateList(); // get State list in dropdown
  }

  placeorder() async {
    final prefs = await SharedPreferences.getInstance();
    List show_obj = prefs.getStringList('obj_list');
    print("in place order============${json.decode(show_obj.toString())}");
    var show_token = prefs.getString('jwt_token');

    if (show_token == null) {
      print('call if');
      Navigator.of(context).pushNamed("/login");
    } else {
      print('call else');

      String url = config.baseUrl + 'orders/customer-checkout';
      Map body = {
        "productDetails": json.decode(show_obj.toString()),
        "shippingFirstName": _firstnamecontroller.text,
        "shippingLastName": _firstnamecontroller.text,
        "shippingAddress_1": _addressonecontroller.text,
        "shippingAddress_2": _addresstwocontroller.text,
        "shippingCity": _citycontroller.text,
        "shippingPostCode": _pincodecontroller.text,
        "shippingCountry": dropdowncountryValue,
        "shippingZone": dropdownstateValue,
        "phoneNumber": _phonenumbercontroller.text,
        "emailId": _emailcontroller.text,
      };
      print('========== =======${await apiRequest(url, body)}');
    }
  }

  Future<String> apiRequest(String url, Map jsonMap) async {
    print("call");

    final prefs = await SharedPreferences.getInstance();
    var show_token = prefs.getString('jwt_token');

    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    request.headers.set('Authorization', json.decode(show_token));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(jsonMap)));
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    httpClient.close();
    setState(() {
      successOrder = reply;
    });
    print("reply====${json.decode(reply.toString())['data']['email']}");
    Toast.show("Submit order Successfully", context,
        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SuccessOrderScreen(
              id: '${json.decode(reply.toString())['data']['orderId']}',
              total: '${json.decode(reply.toString())['data']['total']}',
              email: '${json.decode(reply.toString())['data']['email']}'),
        ));
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.getKeys();
    for (String key in preferences.getKeys()) {
      if (key != "jwt_token") {
        preferences.remove(key);
      }
    }

    return reply;
  }

/*
This function for get country list 
*/
  getStateList() async {
    final prefs = await SharedPreferences.getInstance();
    var show_token = prefs.getString('jwt_token');

    if (show_token == null) {
      print('call if');
      Navigator.of(context).pushNamed("/login");
    } else {
      print('call else');

      var response =
          await http.get(Uri.encodeFull(config.baseUrl + 'list/zone-list'));

      setState(() {
        stateList = json.decode(response.body)['data'];
      });
      dropdownstateValue = stateList[0]['_id'];
      return "Successfull";
    }
  }

/*
This function for get country list 
*/
  getCountryList() async {
    final prefs = await SharedPreferences.getInstance();
    var show_token = prefs.getString('jwt_token');

    if (show_token == null) {
      print('call if');
      Navigator.of(context).pushNamed("/login");
    } else {
      print('call else');

      var response = await http
          .get(Uri.encodeFull(config.baseUrl + 'country/countrylist'));

      setState(() {
        countryList = json.decode(response.body)['data'];
      });
      dropdowncountryValue = countryList[0]['_id'];
      return "Successfull";
    }
  }

/** This Function contains validate Email. this call from widget*/
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

/*
 This function for get profile value
  */
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
      _emailcontroller = new TextEditingController(
          text: json.decode(response.body)['data']['email']);
      _firstnamecontroller = new TextEditingController(
          text: json.decode(response.body)['data']['firstName']);
      _phonenumbercontroller = new TextEditingController(
          text: json.decode(response.body)['data']['mobileNumber']);
      return "Successfull";
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: DrawerScreen(),
      // bottomNavigationBar: BottomTabScreen(),
      appBar: new AppBar(
        title: new Text('Address'),
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
                  // mainAxisSize: MainAxisSize.min,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
                      autofocus: true,
                      controller: _firstnamecontroller,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(labelText: "name"),
                      validator: (String arg) {
                        if (!(arg.length > 3) && arg.isNotEmpty)
                          return 'Name must be more than 2 charater';
                        else
                          return null;
                      },
                    ),
                    TextFormField(
                      autofocus: true,
                      controller: _emailcontroller,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(labelText: "email"),
                      validator: validateEmail,
                    ),
                    TextFormField(
                      autofocus: true,
                      controller: _phonenumbercontroller,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: "Phone Number"),
                      validator: (String arg) {
                        if ((arg.length > 10 || arg.length < 10) &&
                            arg.isNotEmpty)
                          return 'Phone Number not valid';
                        else
                          return null;
                      },
                    ),
                    Container(
                        width: 300.0,
                        child: DropdownButton<String>(
                          value: dropdowncountryValue,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(color: Colors.deepPurple),
                          underline: Container(
                            height: 2,
                            width: MediaQuery.of(context).size.width,
                            color: Colors.deepPurpleAccent,
                          ),
                          onChanged: (String newValue) {
                            setState(() {
                              dropdowncountryValue = newValue;
                            });
                          },
                          items: countryList
                              .map<DropdownMenuItem<String>>((value) {
                            return DropdownMenuItem<String>(
                              value: value['_id'],
                              child: Text(value['name']),
                            );
                          }).toList(),
                        )),
                    Divider(),
                    Container(
                      color: Colors.deepPurple,
                      padding: EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Add Address",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                    Divider(),
                    TextFormField(
                      autofocus: true,
                      controller: _addressonecontroller,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(labelText: "Address Line 1"),
                      validator: (String arg) {
                        if (!(arg.length > 3) && arg.isNotEmpty)
                          return 'Address 1 is required';
                        else
                          return null;
                      },
                    ),
                    TextFormField(
                      autofocus: true,
                      controller: _addresstwocontroller,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(labelText: "Address Line 2"),
                      validator: (String arg) {
                        if (!(arg.length > 3) && arg.isNotEmpty)
                          return 'Address 2 is required';
                        else
                          return null;
                      },
                    ),
                    Container(
                        width: 300.0,
                        child: DropdownButton<String>(
                          value: dropdownstateValue,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(color: Colors.deepPurple),
                          underline: Container(
                            height: 2,
                            width: MediaQuery.of(context).size.width,
                            color: Colors.deepPurpleAccent,
                          ),
                          onChanged: (String newValue) {
                            setState(() {
                              dropdownstateValue = newValue;
                            });
                          },
                          items:
                              stateList.map<DropdownMenuItem<String>>((value) {
                            return DropdownMenuItem<String>(
                              value: value['_id'],
                              child: Text(value['name']),
                            );
                          }).toList(),
                        )),
                    TextFormField(
                      autofocus: true,
                      controller: _citycontroller,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(labelText: "City"),
                      validator: (String arg) {
                        if (!(arg.length > 1) && arg.isNotEmpty)
                          return 'City is required';
                        else
                          return null;
                      },
                    ),
                    TextFormField(
                      autofocus: true,
                      controller: _pincodecontroller,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: "Pincode"),
                      validator: (String arg) {
                        if ((arg.length > 6 || arg.length < 6) &&
                            arg.isNotEmpty)
                          return 'Pine Number not valid';
                        else
                          return null;
                      },
                    ),
                    _addressonecontroller.text.isNotEmpty &&
                            _addresstwocontroller.text.isNotEmpty &&
                            _citycontroller.text.isNotEmpty &&
                            _pincodecontroller.text.isNotEmpty
                        ? RaisedButton(
                            color: Colors.deepPurple,
                            onPressed: () {
                              placeorder();
                            },
                            child: Text(
                              'Submit Order',
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
                              'Submit Order',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18.0),
                            ),
                          )
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
