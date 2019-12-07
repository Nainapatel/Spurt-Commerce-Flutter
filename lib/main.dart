import 'package:spurtcommerce/Routes.dart';

void main()  {
  new Routes();
}

// import 'package:flutter/material.dart';
// void main() =>
//     runApp(MaterialApp(
//       title: "Notification Badge",
//       debugShowCheckedModeBanner: false,
//       home: MyApp(),
//     ));

//     class MyApp extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     // TODO: implement createState
//     return _MyApp();
//   }
// }

// class _MyApp extends State<MyApp> {
//   int counter = 0;

//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Notification Badge"),
//         actions: <Widget>[
//           // Using Stack to show Notification Badge
//           new Stack(
//             children: <Widget>[
//               new IconButton(icon: Icon(Icons.notifications), onPressed: () {
//                 setState(() {
//                   counter = 0;
//                 });
//               }),
//             new Positioned(
//                 right: 11,
//                 top: 11,
//                 child: new Container(
//                   padding: EdgeInsets.all(2),
//                   decoration: new BoxDecoration(
//                     color: Colors.red,
//                     borderRadius: BorderRadius.circular(6),
//                   ),
//                   constraints: BoxConstraints(
//                     minWidth: 14,
//                     minHeight: 14,
//                   ),
//                   child: Text(
//                     'hiiiiii',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 8,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               ) 
//             ],
//           ),
//             new Stack(
//             children: <Widget>[
//               new IconButton(icon: Icon(Icons.notifications), onPressed: () {
//                 setState(() {
//                   counter = 0;
//                 });
//               }),
//             new Positioned(
//                 right: 11,
//                 top: 11,
//                 child: new Container(
//                   padding: EdgeInsets.all(2),
//                   decoration: new BoxDecoration(
//                     color: Colors.red,
//                     borderRadius: BorderRadius.circular(6),
//                   ),
//                   constraints: BoxConstraints(
//                     minWidth: 14,
//                     minHeight: 14,
//                   ),
//                   child: Text(
//                     'hiiiiii',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 8,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               ) 
//             ],
//           ),
//         ],
//       ),
      
//     );
//   }
// }