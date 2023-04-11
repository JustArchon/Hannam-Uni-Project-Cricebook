import 'package:flutter/material.dart';

import 'ui/Main/CircleMain.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    /*
      initialRoute: '/',
      routes: {
        '/': (context) => CircleMain(),
        '/GroupMain': (context) => CircleGroupMain()
      },
    */
    debugShowCheckedModeBanner: false,
    home: CircleMain(),
    );
  }
}

