import 'package:flutter/material.dart';

import 'ui/CircleMain.dart';
import 'ui/Group/CircleGroupMain.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
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