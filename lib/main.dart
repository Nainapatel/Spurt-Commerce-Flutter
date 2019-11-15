import 'package:spurtcommerce/Routes.dart';
import 'package:spurtcommerce/RoutesHome.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  final prefs = await SharedPreferences.getInstance();
  final value = prefs.getString('jwt_token');
  if (value != null) {
    print('in main screen if');
    new Routes();
  }else{
    print("in else");
    new RoutesHome();
  }
}
