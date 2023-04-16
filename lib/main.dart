import 'package:flutter/material.dart';

import 'ui/Main/CircleMain.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async{
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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

