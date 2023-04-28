import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>{
  @override
  Widget build(BuildContext conext){
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Image.asset('assets/image/LandingPage.jpg',fit: BoxFit.cover,)
      )
    );
  }
}