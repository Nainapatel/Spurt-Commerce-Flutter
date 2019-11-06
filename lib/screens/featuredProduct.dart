import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:spurtcommerce/config.dart' as config;
import 'package:spurtcommerce/screens/productView.dart';

void main() {
  runApp(new FeaturedProductScreen());
}

class FeaturedProductScreen extends StatefulWidget {
  @override
  FeaturedProductScreenState createState() => FeaturedProductScreenState();
}

class FeaturedProductScreenState extends State<FeaturedProductScreen> {
  List featuredProduct;
  @override
  void initState() {
    super.initState();
    this.getFeatureProduct(); //Function for featured product
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
    return "Successfull";
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Featured Product'),
          actions: [
            Icon(
              Icons.notifications,
              color: Colors.yellowAccent,
              size: 24.0,
            ),
          ],
        ),
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(children: <Widget>[
              Column(
                children: <Widget>[
                  GridView.builder(
                      shrinkWrap: true,
                      itemCount: featuredProduct.length,
                      gridDelegate:
                          new SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2),
                      itemBuilder: (BuildContext context, int i) {
                        return new GestureDetector(
                            child: new Container(
                          margin: const EdgeInsets.only(
                              left: 5.0, right: 5.0, top: 5.0),

                               child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ProductViewScreen(
                                                id: '${featuredProduct[i]["_id"]}',
                                                name:'${featuredProduct[i]["name"]}'),
                                          ));
                                    },
                          child: SizedBox(
                      
                            child: new Card(
                              elevation: 5.0,
                              child: Padding(
                                padding: EdgeInsets.only(right: 5.0, left: 5.0),
                                child: new Container(
                                  alignment: Alignment.center,
                                  child: Column(
                                    children: [
                                      new Container(
                                        margin: const EdgeInsets.only(
                                            bottom: 20.0, top: 10.0),
                                        child: Image.network(
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
                               ),
                        ));
                      })
                ],
              ),
            ])));
  }
}
