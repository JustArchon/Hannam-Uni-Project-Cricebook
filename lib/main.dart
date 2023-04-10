import 'package:flutter/material.dart';

import 'ui/CircleMain.dart';
import 'ui/CircleGroupMain.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => CircleMain(),
        '/GroupMain': (context) => CircleGroupMain()
      },
    );
  }
}