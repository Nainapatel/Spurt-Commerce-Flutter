import 'package:flutter/material.dart';
import 'package:spurtcommerce/screens/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:spurtcommerce/config.dart' as config;
import 'package:toast/toast.dart';

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

  @override
  void initState() {
    super.initState();
    getProfile(); // get profile data
    getCountryList(); // get country list in dropdown
    getStateList(); // get State list in dropdown
  }

  placeorder() async {
    final prefs = await SharedPreferences.getInstance();
    var show_token = prefs.getString('jwt_token');
    List show_obj = prefs.getStringList('obj_list');
    print("in place order============$show_obj");

    if (show_token == null) {
      print('call if');
      Navigator.of(context).pushNamed("/login");
    } else {
      print('call else');
      var body = {
        json.encode("productDetails".toString()): show_obj,
        json.encode("shippingFirstName".toString()):
            json.encode(_firstnamecontroller.text.toString()),
        json.encode("shippingLastName".toString()):
            json.encode(_firstnamecontroller.text.toString()),
        json.encode("shippingAddress_1".toString()):
            json.encode(_addressonecontroller.text.toString()),
        json.encode("shippingAddress_2".toString()):
            json.encode(_addresstwocontroller.text.toString()),
        json.encode("shippingCity".toString()):
            json.encode(_citycontroller.text.toString()),
        json.encode("shippingPostCode".toString()):
            json.encode(_pincodecontroller.text.toString()),
        json.encode("shippingCountry".toString()):
            json.encode(dropdowncountryValue.toString()),
        json.encode("shippingZone".toString()):
            json.encode(dropdownstateValue.toString()),
        json.encode("phoneNumber".toString()):
            json.encode(_phonenumbercontroller.text.toString()),
        json.encode("emailId".toString()):
            json.encode(_emailcontroller.text.toString()),
      };
      print("body===$body");

      var response = await http
          .post(config.baseUrl + 'orders/customer-checkout', headers: {
        "Authorization": json.decode(show_token),
      }, body: {
        json.encode("productDetails".toString()): show_obj,
        json.encode("shippingFirstName".toString()):
            json.encode(_firstnamecontroller.text.toString()),
        json.encode("shippingLastName".toString()):
            json.encode(_firstnamecontroller.text.toString()),
        json.encode("shippingAddress_1".toString()):
            json.encode(_addressonecontroller.text.toString()),
        json.encode("shippingAddress_2".toString()):
            json.encode(_addresstwocontroller.text.toString()),
        json.encode("shippingCity".toString()):
            json.encode(_citycontroller.text.toString()),
        json.encode("shippingPostCode".toString()):
            json.encode(_pincodecontroller.text.toString()),
        json.encode("shippingCountry".toString()):
            json.encode(dropdowncountryValue.toString()),
        json.encode("shippingZone".toString()):
            json.encode(dropdownstateValue.toString()),
        json.encode("phoneNumber".toString()):
            json.encode(_phonenumbercontroller.text.toString()),
        json.encode("emailId".toString()):
            json.encode(_emailcontroller.text.toString()),
      }).toString();
      print('res====$response');

      Toast.show("Submit order Successfully", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      Navigator.of(context).pushNamed("/dashboard");
     
      SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.getKeys();
        for(String key in preferences.getKeys()) {
          if(key != "jwt_token") {
            preferences.remove(key);
          }
        }
      return "Successfull";
    }
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
      body: Container(
        child: Container(
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
                    ),
                    TextFormField(
                      autofocus: true,
                      controller: _emailcontroller,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(labelText: "email"),
                    ),
                    TextFormField(
                      autofocus: true,
                      controller: _phonenumbercontroller,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: "Phone Number"),
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
                    Container(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Add Address",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    TextFormField(
                      autofocus: true,
                      controller: _addressonecontroller,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(labelText: "Address Line 1"),
                    ),
                    TextFormField(
                      autofocus: true,
                      controller: _addresstwocontroller,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(labelText: "Address Line 2"),
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
                    ),
                    TextFormField(
                      autofocus: true,
                      controller: _pincodecontroller,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: "Pincode"),
                    ),
                    RaisedButton(
                      onPressed: () {
                        placeorder();
                      },
                      child: Text(
                        'Submit Order',
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
