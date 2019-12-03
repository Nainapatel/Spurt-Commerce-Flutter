import 'package:flutter/material.dart';

void main() {
  runApp(new SuccessOrderScreen());
}

class SuccessOrderScreen extends StatefulWidget {
  final id;
  final total;
  final email;
  SuccessOrderScreen({Key key, @required this.id, this.total, this.email})
      : super(key: key);
  @override
  SuccessOrderScreenState createState() => SuccessOrderScreenState();
}

class SuccessOrderScreenState extends State<SuccessOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Confirmation'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Card(
               child: Padding(
                                  padding: EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  
                  children: <Widget>[
                    Icon(
                      Icons.tag_faces,
                      color: Colors.deepPurple,
                      size: 80.0,
                    ),
                    Spacer(),
                    Text("Order Placed successfully",),
                     Spacer(),
                    Text("Order Id: ${this.widget.id}"),
                     Spacer(),
                    Text("Order Amount: ${this.widget.total}"),
                     Spacer(),
                    Text("A Confirmation email has been send to "),
                     Spacer(),
                    Text(this.widget.email)
                  ],
                ),
              ))
            ],
          ),
        ));
  }
}
