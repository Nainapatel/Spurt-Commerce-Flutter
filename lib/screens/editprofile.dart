import 'package:flutter/material.dart';
import 'package:spurtcommerce/screens/drawer.dart';
import 'package:spurtcommerce/screens/bottomTab.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:spurtcommerce/config.dart' as config;
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:email_validator/email_validator.dart';

class EditprofileScreen extends StatefulWidget {
  final id;
  EditprofileScreen({Key key, @required this.id}) : super(key: key);

  @override
  EditprofileScreenState createState() => EditprofileScreenState();
}

class EditprofileScreenState extends State<EditprofileScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _emailcontroller;
  TextEditingController _firstnamecontroller;
  TextEditingController _phonenumbercontroller;
  String _avtarcontroller;
  String _avtarpathcontroller;
  File imageFile;
  String base64Image;
  var tmpFile;
  String errMessage = 'Error';
  bool _autoValidate = false;

  @override
  void initState() {
    super.initState();
    getProfile();
  }

  opeGallery(BuildContext context) async {
    var picture = await ImagePicker.pickImage(source: ImageSource.gallery);
    this.setState(() {
      imageFile = picture;
    });
    print('imageFile$imageFile');
    Navigator.of(context).pop();
  }

  opeCamera(BuildContext context) async {
    var picture = await ImagePicker.pickImage(source: ImageSource.camera);
    this.setState(() {
      imageFile = picture;
    });
    Navigator.of(context).pop();
  }

  Future<void> showChoiceDialog(BuildContext context) {
    print('call function');
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Make a Choice!!"),
            content: SingleChildScrollView(
                child: ListBody(
              children: <Widget>[
                GestureDetector(
                    child: Text("Gallary"), onTap: (opeGallery(context))),
                Padding(
                  padding: EdgeInsets.all(8.0),
                ),
                GestureDetector(
                    child: Text("Camera"), onTap: (opeCamera(context))),
              ],
            )),
          );
        });
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
      _emailcontroller = new TextEditingController(
          text: json.decode(response.body)['data']['email']);
      _firstnamecontroller = new TextEditingController(
          text: json.decode(response.body)['data']['firstName']);
      _phonenumbercontroller = new TextEditingController(
          text: json.decode(response.body)['data']['mobileNumber']);
      _avtarcontroller = json.decode(response.body)['data']['avatar'];
      _avtarpathcontroller = json.decode(response.body)['data']['avatarPath'];

      print('avtar=====$_avtarcontroller======$_avtarpathcontroller');
      return "Successfull";
    }
  }

  Future<String> updatePost() async {
    final prefs = await SharedPreferences.getInstance();
    var show_token = prefs.getString('jwt_token');

    if (show_token == null) {
      print('call if');
      Navigator.of(context).pushNamed("/login");
    } else {
      print('image path ===== $imageFile');

      if (imageFile == null) {
        var response = await http.post(
            Uri.encodeFull(config.baseUrl + 'customer/edit-profile'),
            headers: {
              "Authorization": json.decode(show_token)
            },
            body: {
              'emailId': _emailcontroller.text,
              'firstName': _firstnamecontroller.text,
              'phoneNumber': _phonenumbercontroller.text,
            });
        print('res====${response.body}');
        Navigator.of(context).pushNamed("/profile");
        return "Successfull";
      } else {
        tmpFile = imageFile.toString();
        base64Image = base64Encode(imageFile.readAsBytesSync());
        var response = await http.post(
            Uri.encodeFull(config.baseUrl + 'customer/edit-profile'),
            headers: {
              "Authorization": json.decode(show_token)
            },
            body: {
              'emailId': _emailcontroller.text,
              'firstName': _firstnamecontroller.text,
              'phoneNumber': _phonenumbercontroller.text,
              'image': base64Image,
            });
        print('res====${response.body}');
        Navigator.of(context).pushNamed("/profile");
        return "Successfull";
      }
    }
  }

  Widget decideImageView() {
    if (imageFile == null && _avtarcontroller == '') {
      print("call function edit if");

      return Image.asset('assets/user.png',
          width: MediaQuery.of(context).size.width / 3.0,
          height: MediaQuery.of(context).size.width / 3.0,
          fit: BoxFit.fill);
    } else if (_avtarcontroller == '') {
      print("call function else if");

      return Image.file(
        imageFile,
        width: MediaQuery.of(context).size.width / 3.0,
        height: MediaQuery.of(context).size.width / 3.0,
        fit: BoxFit.fill,
      );
    } else {
      print('call else');
      return Image.network(
        config.mediaUrl + '$_avtarpathcontroller' + '$_avtarcontroller',
        width: MediaQuery.of(context).size.width / 3.0,
        height: MediaQuery.of(context).size.width / 3.0,
        fit: BoxFit.fill,
      );
    }
  }

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
  Widget build(BuildContext context) {
    return new Scaffold(
        drawer: DrawerScreen(),
        bottomNavigationBar: BottomTabScreen(),
        appBar: new AppBar(
          title: new Text('Profile'),
        ),
        body: Container(
            child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
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
                            child: Image.asset('assets/profilebg.jpg',
                                fit: BoxFit.fill),
                            width: MediaQuery.of(context).size.width / 0.5,
                            height: 200),
                        FractionalTranslation(
                            translation: Offset(0.0, 0.5),
                            child: GestureDetector(
                                onTap: () {
                                  showChoiceDialog(context);
                                },
                                child: new ClipRRect(
                                    borderRadius:
                                        new BorderRadius.circular(90.0),
                                    child: decideImageView())))
                      ],
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 60.0, left: 10.0),
                        child: Form(
                          key: _formKey,
                          autovalidate: true,
                          onWillPop: () async {
                            return false;
                          },
                          onChanged: () {},
                          child: Column(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.topLeft,
                                child: TextFormField(
                                  autofocus: true,
                                  controller: _firstnamecontroller,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    labelText: "Name",
                                    icon: Icon(
                                      Icons.tag_faces,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  validator: (String arg) {
                                    if (arg.length < 3)
                                      return 'Name must be more than 2 charater';
                                    else
                                      return null;
                                  },
                                  onSaved: (String val) {
                                    _firstnamecontroller = _firstnamecontroller;
                                  },
                                ),
                              ),
                              Divider(),
                              Align(
                                alignment: Alignment.topLeft,
                                child: TextFormField(
                                  autofocus: true,
                                  controller: _emailcontroller,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    labelText: "Eamil",
                                    icon: Icon(
                                      Icons.email,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  validator: validateEmail,
                                  onSaved: (String val) {
                                    _firstnamecontroller = _firstnamecontroller;
                                  },
                                ),
                              ),
                              Divider(),
                              Align(
                                alignment: Alignment.topLeft,
                                child: TextFormField(
                                  autofocus: true,
                                  controller: _phonenumbercontroller,
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    labelText: "PhoneNumber",
                                    icon: Icon(
                                      Icons.phone,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  validator: (String arg) {
                                    if (arg.length > 10 || arg.length < 10)
                                      return 'Phone Number not valid';
                                    else
                                      return null;
                                  },
                                  onSaved: (String val) {
                                    _firstnamecontroller = _firstnamecontroller;
                                  },
                                ),
                              ),
                              Divider(),
                              Align(
                                alignment: Alignment.center,
                                child: RaisedButton(
                                  onPressed: () {
                                    updatePost();
                                  },
                                  child: Text('Update'),
                                ),
                              )
                            ],
                          ),
                        ))
                  ]),
                ))));
  }
}
