import 'dart:async';
import 'package:circle_book/screens/main_login_screen.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';


class LandingPage extends StatefulWidget {
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>{
@override
  void initState() {
  	Timer(Duration(milliseconds: 1500), () {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => const LoginScreen()
                  )
                  );
                });
  }
  @override
  Widget build(BuildContext conext){
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Image.asset('assets/image/LandingPage.jpg',fit: BoxFit.cover,)
          ),
          const CircularProgressIndicator()
        ],
      )
    );
  }
}