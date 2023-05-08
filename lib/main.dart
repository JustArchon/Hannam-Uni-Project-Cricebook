import 'package:circle_book/screens/login_page.dart';
import 'package:circle_book/screens/main_landing_screen.dart';
//import 'package:circle_book/screens/main/m_base_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "MyApp",
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        primaryColor: const Color(0xff6DC4DB),
      ),
      // 웹,앱 모두 드래그 작동하게하는 코드
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown
        },
      ),
      home: //const MainBaseScreen(),
          LandingPage(),
    );
  }
}
