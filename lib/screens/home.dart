import 'package:flutter/material.dart';
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
  List<dynamic> featuredProduct = new List<dynamic>();
  bool loader = false;
  double opacityLevel = 1.0;

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
 *  For get Banner Image 
 */
  Future<String> getJSONData() async {
    var response = await http.get(
        Uri.encodeFull(config.baseUrl + 'list/banner-list'),
        headers: {"Accept": "application/json"});
    setState(() {
      bannreData = json.decode(response.body)['data'];
    });
    loader = true;
    print(config.mediaUrlBanner + '${bannreData[0]['image']}');
    print(config.mediaUrlBanner + '${bannreData[1]['image']}');
    print(config.mediaUrlBanner + '${bannreData[2]['image']}');
    print(config.mediaUrlBanner + '${bannreData[3]['image']}');
    print(config.mediaUrlBanner + '${bannreData[4]['image']}');
    return "Successfull";
  }

  /*
 *  For fetch get Category name
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
 *  For get FeatureProduct list
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

/** This widget for display category name over image */
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
            boxShadow: [
              new BoxShadow(
                color: Colors.black,
                blurRadius: 20.0,
              ),
            ],
            border: Border.all(
                width: 5, color: Colors.white, style: BorderStyle.solid)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> image = new List<dynamic>();
    image.insert(0, AssetImage('assets/sale/baby.jpg'));
    image.insert(1, AssetImage('assets/sale/electronics.jpg'));
    image.insert(2, AssetImage('assets/sale/house.jpg'));
    image.insert(3, AssetImage('assets/sale/men.jpg'));
    image.insert(4, AssetImage('assets/sale/sports.jpg'));
    image.insert(5, AssetImage('assets/sale/women.jpg'));
    print('loader==$loader');

    return new Scaffold(
        drawer: DrawerScreen(),
        // bottomNavigationBar: BottomTabScreen(),
        appBar: new AppBar(
          title: new Text('Home'),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed("/cart");
              },
              child: Icon(
                Icons.shopping_cart,
                color: Colors.white,
                size: 24.0,
              ),
            ),
              GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed("/wishlist");
              },
              child: Icon(
                Icons.favorite,
                color: Colors.white,
                size: 24.0,
              ),
            ),
            Icon(
              Icons.notifications,
              color: Colors.yellowAccent,
              size: 24.0,
            ),
          ],
        ),
        body: Center(
            child: loader == true
                ? CustomScrollView(
                    slivers: <Widget>[
                      SliverList(
                          delegate: SliverChildListDelegate([
                        SizedBox(
                            height: MediaQuery.of(context).size.height / 3.5,
                            width: MediaQuery.of(context).size.width,
                            child: Carousel(
                              images: [
                                NetworkImage(config.mediaUrlBanner +
                                    '${bannreData[0]['image']}'),
                                NetworkImage(config.mediaUrlBanner +
                                    '${bannreData[1]['image']}'),
                                NetworkImage(config.mediaUrlBanner +
                                    '${bannreData[2]['image']}'),
                                NetworkImage(config.mediaUrlBanner +
                                    '${bannreData[3]['image']}'),
                                NetworkImage(config.mediaUrlBanner +
                                    '${bannreData[4]['image']}'),
                              ],
                              dotSpacing: 15.0,
                              dotBgColor: Colors.black.withOpacity(0.0),
                              borderRadius: false,
                              boxFit: BoxFit.fill,
                            )),
                      ])),
                      SliverList(
                        delegate: SliverChildListDelegate([
                          Column(
                            children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.only(right: 8.0),
                                  child: new Container(
                                    margin: const EdgeInsets.only(
                                        left: 20.0, right: 20.0, top: 10.0),
                                    child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          'Category',
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )),
                                  )),
                            ],
                          ),
                        ]),
                      ),
                      SliverList(
                        delegate: SliverChildListDelegate([
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
                        ]),
                      ),
                      SliverList(
                        delegate: SliverChildListDelegate([
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
                        ]),
                      ),
                      SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 0.0,
                            crossAxisSpacing: 0.0,
                          ),
                          delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                            if (index <= 3) {
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
                            }
                          }, childCount: featuredProduct.length)),
                      SliverList(
                          delegate: SliverChildListDelegate([
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 10,
                          ),
                          child: SizedBox(
                              height: MediaQuery.of(context).size.height / 3,
                              width: MediaQuery.of(context).size.width,
                              child: Carousel(
                                images: [
                                  image[0],
                                  image[1],
                                  image[2],
                                  image[3],
                                  image[4],
                                  image[5]
                                ],
                                dotSpacing: 15.0,
                                dotBgColor: Colors.black.withOpacity(0.0),
                                borderRadius: false,
                                boxFit: BoxFit.fill,
                              )),
                        )
                      ])),
                      SliverList(
                        delegate: SliverChildListDelegate([
                          Column(
                            children: <Widget>[
                              GestureDetector(
                                  onTap: () {
                                    Navigator.of(context)
                                        .pushNamed("/featuredProduct");
                                  },
                                  child: Image.asset(
                                    'assets/sale/offer.jpg',
                                    height: 300,
                                    width: MediaQuery.of(context).size.width,
                                  ))
                            ],
                          ),
                        ]),
                      ),
                      SliverList(
                        delegate: SliverChildListDelegate([
                          Column(
                            children: <Widget>[
                              GestureDetector(
                                child: RaisedButton(
                                    color: Colors.deepPurple,
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pushNamed("/featuredProduct");
                                    },
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text('Shop Now',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold)),
                                          Image.asset(
                                            'assets/giphy.gif',
                                            height: 35,
                                            width: 35,
                                            color: Colors.white,
                                          )
                                        ])),
                              )
                            ],
                          ),
                        ]),
                      ),
                    ],
                  )
                : Align(
                    alignment: Alignment.center,
                    child: SpinKitCircle(color: Colors.deepPurple),
                  )));
  }
}
