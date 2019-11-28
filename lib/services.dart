import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:spurtcommerce/config.dart' as config;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spurtcommerce/screens/cartView.dart';
import 'package:spurtcommerce/screens/categoryProductlist.dart';

List<Map> cartProductArray = [];

var jsonResponseCart;
var jsonResponseCategory;
var checkvalueofitem;
/** fetch cart data */
Future<List<Cart>> fetchcartItem() async {
  final prefs = await SharedPreferences.getInstance();

  List<String> show_obj = prefs.getStringList('obj_list') ?? List<String>();

  print(
      ">>>>>>>>>>>>>>>>>length==service file===${show_obj.length}========${cartProductArray.length}");
 
    for (var i = 0; i < show_obj.length; i++) {
      var response = await http.get(
          Uri.encodeFull(config.baseUrl +
              'product-store/productdetail/${jsonDecode(show_obj.toString())[i]['id']}'),
          headers: {"Accept": "application/json"});
      jsonResponseCart = await json.decode(response.body);
      List prodLists = cartProductArray
          .where((prod) =>
              prod["productId"] == jsonDecode(show_obj.toString())[i]['id'])
          .toList();

      checkvalueofitem = prodLists.length == 1 ?? prodLists[0];
    }
    print("checkvalueofitem======$checkvalueofitem");
    if (checkvalueofitem == false) {
      cartProductArray.add(jsonResponseCart['data'][0]);
    }

    for (var i = 0; i < cartProductArray.length; i++) {
      var jsonobject = cartProductArray[i];

      jsonobject["qty"] = 1;
    }
  
  
  return cartProductArray.map((i) => new Cart.fromJson(i)).toList();
}

Future<String> logout() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.clear();
  return "log out successfully";
}
