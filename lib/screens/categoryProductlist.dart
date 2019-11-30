import 'package:flutter/material.dart';
import 'package:spurtcommerce/screens/drawer.dart';
import 'package:spurtcommerce/screens/bottomTab.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:spurtcommerce/config.dart' as config;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:spurtcommerce/screens/productView.dart';

class CategoryProductlistScreen extends StatefulWidget {
   final id;
   final name;
CategoryProductlistScreen({Key key, @required this.id, this.name}) : super(key: key);
  @override
  CategoryProductlistScreenState createState() => CategoryProductlistScreenState();
}

class CategoryProductlistScreenState extends State<CategoryProductlistScreen> {
  List categoryProduct;
  bool loader = false;
  @override
  void initState() {
    super.initState();
    this.getCategoryProduct(); //Function for featured product
  }

  /*
 *  For get FeatureProduct
 */
  Future<String> getCategoryProduct() async {
    var id = this.widget.id;
    var response = await http.get(
        Uri.encodeFull(config.baseUrl + 'list/productlist?categoryId=$id'),
        headers: {"Accept": "application/json"});
    setState(() {
      categoryProduct = json.decode(response.body)['data']['productList'];
    });
    print(categoryProduct);
     loader = true;
    return "Successfull";
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: DrawerScreen(),
      bottomNavigationBar: BottomTabScreen(),
      appBar: new AppBar(
        title: new Text(this.widget.name),
        actions: [
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
                                                    '${categoryProduct[index]["_id"]}',
                                                name:
                                                    '${categoryProduct[index]["name"]}'),
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
                                                        '${categoryProduct[index]['Images']['containerName']}' +
                                                        '${categoryProduct[index]['Images']['image']}',
                                                    width: 100,
                                                    height: 100,
                                                  ),
                                                ),
                                                Text(
                                                  '${categoryProduct[index]['name'].substring(0, 15)}...',
                                                ),
                                                Text(
                                                  'Rs ${categoryProduct[index]['price']}',
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
                            
                          }, childCount: categoryProduct.length)),
                      
                   
                 
                    ],
                  )
                : Align(
                    alignment: Alignment.center,
                    child: SpinKitCircle(color: Colors.deepPurple),
                  ))
          //  body: SingleChildScrollView(
          //   scrollDirection: Axis.vertical,
          //   child: loader == true ?
          //    Column(children: <Widget>[
          //     Column(
          //       children: <Widget>[
          //         GridView.builder(
          //             shrinkWrap: true,
          //             itemCount: categoryProduct.length,
          //             gridDelegate:
          //                 new SliverGridDelegateWithFixedCrossAxisCount(
          //                     crossAxisCount: 2),
          //             itemBuilder: (BuildContext context, int i) {
          //               return new GestureDetector(
          //                   child: new Container(
          //                 margin: const EdgeInsets.only(
          //                     left: 5.0, right: 5.0, top: 5.0),

          //                      child: GestureDetector(
          //                           onTap: () {
          //                             Navigator.push(
          //                                 context,
          //                                 MaterialPageRoute(
          //                                   builder: (context) => ProductViewScreen(
          //                                       id: '${categoryProduct[i]["_id"]}',
          //                                       name:'${categoryProduct[i]["name"]}'),
          //                                 ));
          //                           },
          //                 child: SizedBox(
                      
          //                   child: new Card(
          //                     elevation: 5.0,
          //                     child: Padding(
          //                       padding: EdgeInsets.only(right: 5.0, left: 5.0),
          //                       child: new Container(
          //                         alignment: Alignment.center,
          //                         child: Column(
          //                           children: [
          //                             new Container(
          //                               margin: const EdgeInsets.only(
          //                                   bottom: 20.0, top: 10.0),
          //                               child: Image.network
          //                               (
          //                                 config.mediaUrl +
          //                                     '${categoryProduct[i]['Images']['containerName']}' +
          //                                     '${categoryProduct[i]['Images']['image']}',
          //                                 width: 100,
          //                                 height: 100,
          //                               ),
          //                             ),
          //                             Text(
          //                               '${categoryProduct[i]['name'].substring(0, 15)}...',
          //                             ),
          //                             Text(
          //                               'Rs ${categoryProduct[i]['price']}',
          //                               style: TextStyle(
          //                                 fontSize: 12.0,
          //                                 color: Colors.red,
          //                               ),
          //                             )
          //                           ],
          //                         ),
          //                       ),
          //                     ),
          //                   ),
          //                 ),
          //                      ),
          //               ));
          //             })
          //       ],
          //     )
          //   ]) :Align(
          //         alignment: Alignment.center,
          //         child: SpinKitCircle(color: Colors.deepPurple),
          //       )),
            );
  }
}




