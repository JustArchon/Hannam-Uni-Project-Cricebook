import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:circle_book/widgets/Profile_imagePickWidget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? userPickedImage;
  void pickedImage(File image){
        userPickedImage = image;
    }
  void showAlert(BuildContext context){
      showDialog(
        context: context,
        builder: (context){
          return Dialog(
            backgroundColor: Colors.white,
            child: ProfilePickImage(pickedImage),
          );
        },
      );
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          height: 50,
          child: Image.asset('assets/icons/아이콘_흰색(512px).png'),
        ),
        centerTitle: true,
        elevation: 2,
        backgroundColor: const Color(0xff6DC4DB),
        foregroundColor: Colors.white,

        //toolbarHeight: 50,

        // 좌측 아이콘 버튼
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.menu_outlined),
        ),

        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search_outlined), // 그룹 검색 아이콘 생성
            onPressed: () {
              // 아이콘 버튼 실행
              //print('Group search button is clicked');
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings), // 그룹 설정 아이콘 생성
            onPressed: () {
              // 아이콘 버튼 실행
              //print('Group settings button is clicked');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Center(
            child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              showAlert(context);
            },
            child: CircleAvatar(
              radius: 100,
              backgroundImage: AssetImage("assets/icons/usericon.png")
            ),
          )
        ],
      ),
    )
  )
  );
  }
}

