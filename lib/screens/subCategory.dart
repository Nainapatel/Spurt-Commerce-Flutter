import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:spurtcommerce/config.dart' as config;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:spurtcommerce/screens/categoryProductlist.dart';

void main() {
  runApp(new SubCategoryScreen());
}

class SubCategoryScreen extends StatefulWidget {
  final id;
  final name;
  SubCategoryScreen({Key key, @required this.id, this.name}) : super(key: key);

  @override
  SubCategoryScreenState createState() => SubCategoryScreenState();
}

class SubCategoryScreenState extends State<SubCategoryScreen> {
  List bannreData;

  List subcategoryList;

  @override
  void initState() {
    super.initState();
    this.getJSONData();
    this.getSubCategory();
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
    return "Successfull";
  }

  /*
 *  For Category
 */
  Future<String> getSubCategory() async {
    var id = this.widget.id;
    var subcategory;
    var response = await http.get(
        Uri.encodeFull(config.baseUrl + 'list/category-list'),
        headers: {"Accept": "application/json"});
    var category = json.decode(response.body)['data'];

    for (var i = 0; i <= await category.length; i++) {
      if (id == category[i]['children'][0]['parentInt']) {
        subcategory = await category[i]['children'];
      }
      setState(() {
        subcategoryList = subcategory;
      });
    }
    return "Successfull";
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
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
      body: Container(
        child: Column(
          children: <Widget>[
            Column(children: [
              CarouselSlider(
                height: 200.0,
                items: bannreData.map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          child: Image.network(
                              config.mediaUrlBanner + '${i['image']}',
                              width: MediaQuery.of(context).size.width,
                              height: 200,
                              fit: BoxFit.fill));
                    },
                  );
                }).toList(),
              ),
            ]),
            new Row(
              children: <Widget>[
                Expanded(
                  child: SizedBox(
                    height: 350.0,
                    child: new ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: subcategoryList.length,
                      itemBuilder: (BuildContext ctxt, int i) {
                        return SizedBox(
                            child: GestureDetector(
                          onTap: () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CategoryProductlistScreen(
                                    id: '${subcategoryList[i]["categoryId"]}',
                                    name: '${subcategoryList[i]['name']}',
                                  ),
                                ))
                          },
                          child: Card(
                              margin: EdgeInsets.all(10),
                              child: Text(
                                '${subcategoryList[i]['name']}',
                                style: TextStyle(fontSize: 20.0),
                              )),
                        ));
                      },
                    ),
                  ),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            )
          ],
        ),
      ),
    );
  }
}
