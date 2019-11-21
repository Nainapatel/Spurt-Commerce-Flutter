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

  List img = [
    'assets/Electronic.png',
    'assets/man.jpeg',
    'assets/baby.jpg',
    'assets/Sports.jpg',
    'assets/house.jpg',
    'assets/women.jpeg'
  ];

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

  Widget buildTitle(String name) {
    return Center(
      child: Container(
        child: Text(
          name,
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
        decoration: BoxDecoration(
            border: Border.all(
                width: 5, color: Colors.white, style: BorderStyle.solid)),
      ),
    );
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
                                height: 250.0,
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
                                autoPlay: true,
                              ),
                            ]),
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
                                      child: Text('Category',
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                          ))),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 18.0),
                          height: MediaQuery.of(context).size.height * 0.30,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: categoryData.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => SubCategoryScreen(
                                                id:
                                                    '${categoryData[index]["categoryId"]}',
                                                name:
                                                    '${categoryData[index]["name"]}'),
                                          ));
                                    },
                                    child: Card(
                                      child: Container(
                                        decoration: new BoxDecoration(
                                          image: new DecorationImage(
                                            image: new AssetImage(img[index]),
                                            colorFilter: new ColorFilter.mode(
                                                Colors.black.withOpacity(0.8),
                                                BlendMode.dstATop),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        child: Center(
                                            child: buildTitle(
                                                categoryData[index]['name'])),
                                      ),
                                    ),
                                  ),
                                );
                              }),
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
                                      child: Text('Products',
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
                                    child: const Text('View all',
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
