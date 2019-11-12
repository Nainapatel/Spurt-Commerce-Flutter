import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:spurtcommerce/config.dart' as config;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spurtcommerce/screens/cartView.dart';

List cartProductArray = [];
List cartProduct = [];

var jsonResponse;
/** fetch cart data */
Future<List<Cart>> fetchJobs() async {
  final prefs = await SharedPreferences.getInstance();
  List<String> show_id = prefs.getStringList('id_list') ?? List<String>();
  print("show_id====$show_id");
  if (show_id.length != cartProductArray.length) {
    for (var i = 0; i < show_id.length; i++) {
      print('hii$i');
      var response = await http.get(
          Uri.encodeFull(
              config.baseUrl + 'product-store/productdetail/${show_id[i]}'),
          headers: {"Accept": "application/json"});
      jsonResponse = await json.decode(response.body);
    }
    cartProductArray.add(jsonResponse['data'][0]);
  }
  return cartProductArray.map((i) => new Cart.fromJson(i)).toList();
}
