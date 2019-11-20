import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:spurtcommerce/config.dart' as config;
import 'package:spurtcommerce/screens/subCategory.dart';
import 'package:spurtcommerce/screens/productView.dart';
import 'package:spurtcommerce/screens/drawer.dart';
import 'package:spurtcommerce/screens/bottomTab.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:carousel_pro/carousel_pro.dart';

void main() {
  runApp(new HomeScreen());
}

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  List bannreData;
  List categoryData;
  List featuredProduct;
  bool loader = false;
  @override
  void initState() {
    super.initState();
    this.getJSONData(); // Function for banner Images
    this.getCategoty(); // Function for category display
    this.getFeatureProduct(); //Function for featured product
  }

/*
 *  For Banner
 */
  Future<String> getJSONData() async {
    var response = await http.get(
        Uri.encodeFull(config.baseUrl + 'list/banner-list'),
        headers: {"Accept": "application/json"});
    setState(() {
      bannreData = json.decode(response.body)['data'];
    });
    loader = true;
    return "Successfull";
  }

  /*
 *  For Category
 */
  Future<String> getCategoty() async {
    var response = await http.get(
        Uri.encodeFull(config.baseUrl + 'list/category-list'),
        headers: {"Accept": "application/json"});
    setState(() {
      categoryData = json.decode(response.body)['data'];
    });
    loader = true;
    return "Successfull";
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
    loader = true;
    return "Successfull";
  }

  @override
  Widget build(BuildContext context) {
    print('loader==$loader');
    return new Scaffold(
        drawer: DrawerScreen(),
        bottomNavigationBar: BottomTabScreen(),
        appBar: new AppBar(
          title: new Text('Home'),
          actions: [
            Icon(
              Icons.notifications,
              color: Colors.yellowAccent,
              size: 24.0,
            ),
          ],
        ),
        body: Center(
          child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: loader == true
                  ? Column(
                      children: <Widget>[
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              CarouselSlider(
                                height: 200.0,
                                items: bannreData.map((i) {
                                  return Builder(
                                    builder: (BuildContext context) {
                                      return Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 5.0),
                                          child: Image.network(
                                              config.mediaUrlBanner +
                                                  '${i['image']}',
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: 200,
                                              fit: BoxFit.fill));
                                    },
                                  );
                                }).toList(),
                              ),
                            ]),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: categoryData.map((i) {
                              return Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: new Container(
                                  margin: const EdgeInsets.only(
                                      left: 10.0, right: 10.0, top: 10.0),
                                  child: FlatButton(
                                    color: Colors.deepPurple,
                                    textColor: Colors.white,
                                    disabledColor: Colors.grey,
                                    disabledTextColor: Colors.black,
                                    padding: EdgeInsets.all(8.0),
                                    splashColor: Colors.blueAccent,
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                SubCategoryScreen(
                                                    id: '${i["categoryId"]}',
                                                    name: '${i["name"]}'),
                                          ));
                                    },
                                    child: Text(
                                      '${i['name']}',
                                      style: TextStyle(fontSize: 12.0),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(right: 8.0),
                                  child: new Container(
                                      margin: const EdgeInsets.only(
                                          left: 20.0, right: 20.0, top: 10.0),
                                      child: Text('Featured Products',
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                          ))),
                                ),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 20.0, right: 20.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context)
                                          .pushNamed("/featuredProduct");
                                    },
                                    child: const Text('See all',
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            GridView.builder(
                                shrinkWrap: true,
                                itemCount: featuredProduct.length,
                                gridDelegate:
                                    new SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2),
                                itemBuilder: (BuildContext context, int i) {
                                  if (i <= 3) {
                                    return new GestureDetector(
                                        child: new Container(
                                            margin: const EdgeInsets.only(
                                                left: 5.0,
                                                right: 5.0,
                                                top: 5.0),
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          ProductViewScreen(
                                                              id:
                                                                  '${featuredProduct[i]["_id"]}',
                                                              name:
                                                                  '${featuredProduct[i]["name"]}'),
                                                    ));
                                              },
                                              child: SizedBox(
                                                child: new Card(
                                                  elevation: 5.0,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 5.0, left: 5.0),
                                                    child: new Container(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Column(
                                                        children: [
                                                          new Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    bottom:
                                                                        20.0,
                                                                    top: 10.0),
                                                            child:
                                                                Image.network(
                                                              config.mediaUrl +
                                                                  '${featuredProduct[i]['Images']['containerName']}' +
                                                                  '${featuredProduct[i]['Images']['image']}',
                                                              width: 100,
                                                              height: 100,
                                                            ),
                                                          ),
                                                          Text(
                                                            '${featuredProduct[i]['name'].substring(0, 22)}...',
                                                          ),
                                                          Text(
                                                            'Rs ${featuredProduct[i]['price']}',
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
                                            )));
                                  }
                                })
                          ],
                        ),
                      ],
                    )
                  : Align(
                      alignment: Alignment.center,
                      child: SpinKitCircle(color: Colors.deepPurple),
                    )),
        ));
  }
}
