import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:spurtcommerce/config.dart' as config;
import 'package:spurtcommerce/screens/productView.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:spurtcommerce/screens/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(new FeaturedProductScreen());
}

class FeaturedProductScreen extends StatefulWidget {
  @override
  FeaturedProductScreenState createState() => FeaturedProductScreenState();
}

class FeaturedProductScreenState extends State<FeaturedProductScreen> {
  List featuredProduct;
  bool loader = false;
  List<String> count_cart;
  List<String> count_wishlist;
  @override
  void initState() {
    super.initState();
    this.getFeatureProduct(); //Function for featured product
  this.getCount();
  }
  getCount() async {
    final prefs = await SharedPreferences.getInstance();
    count_wishlist = prefs.getStringList('id_wishlist') ?? List<String>();
    count_cart = prefs.getStringList('obj_list') ?? List<String>();
    print(
        ">>>>>>>>${count_wishlist.length}>>home>>>>>length of obj list====${count_cart.length}");
  }
  /*
 *  For getFeatureProduct
 */
  Future<String> getFeatureProduct() async {
    var response = await http.get(
        Uri.encodeFull(config.baseUrl + 'product-store/featureproduct-list'),
        headers: {"Accept": "application/json"});
    setState(() {
      featuredProduct = json.decode(response.body)['data'];
    });
    print(featuredProduct);
    loader = true;
    return "Successfull";
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: DrawerScreen(),
        appBar: new AppBar(
          title: new Text('Featured Product'),
            actions: [
             Container(
              margin: EdgeInsets.fromLTRB(0, 0, 25, 0),
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed("/cart");
                    },
                    child: Stack(
                      children: <Widget>[
                        IconButton(
                            icon: Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                        )),
                        new Positioned(
                          right: 9,
                          top: 5,
                          child: new Container(
                            padding: EdgeInsets.all(2),
                            decoration: new BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            constraints: BoxConstraints(
                              minWidth: 14,
                              minHeight: 14,
                            ),
                            child: Text(
                              '${count_cart.length}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed("/wishlist");
                    },
                    child: Stack(
                      children: <Widget>[
                        new IconButton(
                            icon: Icon(
                          Icons.favorite,
                          color: Colors.white,
                        )),
                        new Positioned(
                          right: 9,
                          top: 5,
                          child: new Container(
                            padding: EdgeInsets.all(2),
                            decoration: new BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            constraints: BoxConstraints(
                              minWidth: 14,
                              minHeight: 14,
                            ),
                            child: Text(
                              '${count_wishlist.length}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        body: Center(
            child: loader == true
                ? CustomScrollView(
                    slivers: <Widget>[
                      SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 0.0,
                            crossAxisSpacing: 0.0,
                          ),
                          delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                            return new Container(
                                margin: const EdgeInsets.only(
                                    left: 5.0, right: 5.0, top: 5.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ProductViewScreen(
                                              id:
                                                  '${featuredProduct[index]["_id"]}',
                                              name:
                                                  '${featuredProduct[index]["name"]}'),
                                        ));
                                  },
                                  child: SizedBox(
                                    child: new Card(
                                      elevation: 5.0,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            right: 5.0, left: 5.0),
                                        child: new Container(
                                          alignment: Alignment.center,
                                          child: Column(
                                            children: [
                                              new Container(
                                                 decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: AssetImage(
                                                          "assets/img_loader.gif"),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                margin: const EdgeInsets.only(
                                                    bottom: 20.0, top: 10.0),
                                                child: Image.network(
                                                  config.mediaUrl +
                                                      '${featuredProduct[index]['Images']['containerName']}' +
                                                      '${featuredProduct[index]['Images']['image']}',
                                                  width: 100,
                                                  height: 100,
                                                ),
                                              ),
                                              Text(
                                                '${featuredProduct[index]['name'].substring(0, 22)}...',
                                              ),
                                              Text(
                                                'Rs ${featuredProduct[index]['price']}',
                                                style: TextStyle(
                                                  fontSize: 12.0,
                                                  color: Colors.red,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ));
                          }, childCount: featuredProduct.length)),
                    ],
                  )
                : Align(
                    alignment: Alignment.center,
                    child: SpinKitCircle(color: Colors.deepPurple),
                  )));
  }
}

