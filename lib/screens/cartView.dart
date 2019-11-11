import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:spurtcommerce/services.dart';

class Cart {
  final int id;
  final String name;

  Cart({this.id, this.name});

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'],
      name: json['name'],
    );
  }
}

class CartView extends StatelessWidget {
  List cartProductArray = [];

  @override
  Widget build(BuildContext context) {
    print("call widget");
    return FutureBuilder<List<Cart>>(
      future: _fetchJobs(),
      builder: (context, snapshot) {
        print("snapshot.hasData====${snapshot.hasData}");
        if (snapshot.hasData) {
          print("snapshot.hasData==in if==${snapshot.hasData}");

          List<Cart> data = snapshot.data;
          return _jobsListView(data);
        } else if (snapshot.hasError) {
          print("error====${snapshot.error}");
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
    );
  }

  Future<List<Cart>> _fetchJobs() async {
    print("call in cart view");
    var response = await fetchJobs();
    print("call in cart view $response");
    return response;
  }

  ListView _jobsListView(data) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          print("data length===${data.length}");
          return _tile(data[index].name, Icons.work);
        });
  }

  ListTile _tile(String name, IconData icon) => ListTile(
        title: Text(name,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20,
            )),
        subtitle: Text(name),
        leading: Icon(
          icon,
          color: Colors.blue[500],
        ),
      );
}
