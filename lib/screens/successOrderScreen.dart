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
              Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.tag_faces,
                        color: Colors.deepPurple,
                        size: 60.0,
                      ),
                      Divider(),
                      Text(
                        "Order Placed successfully",
                        style: TextStyle(color: Colors.deepPurple),
                      ),
                      Divider(),
                      Text("Order Id: ${this.widget.id}",
                          style: TextStyle(color: Colors.grey)),
                      Divider(),
                      Text("Order Amount: ${this.widget.total}",
                          style: TextStyle(color: Colors.grey)),
                      Divider(),
                      Text("A Confirmation email has been send to ",
                          style: TextStyle(color: Colors.black)),
                      Divider(),
                      Text('${this.widget.email}',
                          style: TextStyle(color: Colors.black)),
                      Divider(),
                      RaisedButton(
                        color: Colors.deepPurple,
                        onPressed: () {
                          Navigator.of(context).pushNamed("/dashboard");
                        },
                        child: Text(
                          'Keep Shopping',
                          style: TextStyle(color: Colors.white, fontSize: 18.0),
                        ),
                      ),
                    ],
                  ))
            ],
          ),
        ));
  }
}
