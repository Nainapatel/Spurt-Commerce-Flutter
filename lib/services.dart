import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:spurtcommerce/config.dart' as config;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spurtcommerce/screens/cartView.dart';
import 'package:spurtcommerce/screens/categoryProductlist.dart';

List cartProductArray = [];

var jsonResponseCart;
var jsonResponseCategory;
/** fetch cart data */
Future<List<Cart>> fetchJobs() async {
  final prefs = await SharedPreferences.getInstance();
  List<String> show_id = prefs.getStringList('id_list') ?? List<String>();
  print("show_id====$show_id");
  if (show_id.length != cartProductArray.length) {
    for (var i = 0; i < show_id.length; i++) {
      var response = await http.get(
          Uri.encodeFull(
              config.baseUrl + 'product-store/productdetail/${show_id[i]}'),
          headers: {"Accept": "application/json"});
      jsonResponseCart = await json.decode(response.body);
    }
    cartProductArray.add(jsonResponseCart['data'][0]);
    for (var i = 0; i < cartProductArray.length; i++) {
      var jsonobject = cartProductArray[i];

      jsonobject["qty"] = 1;
    }
  }
  return cartProductArray.map((i) => new Cart.fromJson(i)).toList();
}

Future<String> logout() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.clear();
  return "log out successfully";
}

