import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:spurtcommerce/config.dart' as config;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spurtcommerce/screens/cartView.dart';

List cartProductArray = [];

Future<List<Cart>> fetchJobs() async {
  print('calll service  ');
  final prefs = await SharedPreferences.getInstance();
  List<String> show_id = prefs.getStringList('id_list') ?? List<String>();
  print('id==cart==$show_id');
  for (var i = 0; i < show_id.length; i++) {
    print('hii$i');
    var response = await http.get(
        Uri.encodeFull(
            config.baseUrl + 'product-store/productdetail/${show_id[i]}'),
        headers: {"Accept": "application/json"});

    var jsonResponse = await json.decode(response.body);
    cartProductArray.add(jsonResponse['data'][0]);
    
  }
  print('length===>>${cartProductArray.length} =======cartProductArray ======$cartProductArray');
  return cartProductArray.map((i) => new Cart.fromJson(i)).toList();
}
