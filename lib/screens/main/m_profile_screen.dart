import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
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
  late Stream<String> imageUrlStream;
  String? imageUrl;
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
      body: 
      StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
          return const Center(
            child: CircularProgressIndicator(), 
          );
        }else{
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Center(
            child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  showAlert(context);
                },
                child: CircleAvatar(
                  radius: 100,
                  backgroundImage: NetworkImage(snapshot.data!['UserProfileImage']), //AssetImage("assets/icons/usericon.png")
                ),
              ),
              SizedBox(height: 20),
              RichText(
                text: TextSpan(
                  text: '닉네임: ',
                  style: TextStyle(fontFamily: "Ssurround", fontSize: 30, color: Colors.black),
                  children: [
                    TextSpan(
                      text: snapshot.data!['userName'],
                      style: TextStyle(fontFamily: "Ssurround", fontSize: 30, color: Colors.black),
                    )
                  ]
                ),
              ),
              SizedBox(height: 10),
              RichText(
                text: TextSpan(
                  text: '이메일: ',
                  style: TextStyle(fontFamily: "Ssurround", fontSize: 22, color: Colors.black),
                  children: [
                    TextSpan(
                      text: snapshot.data!['userEmail'],
                      style: TextStyle(fontFamily: "Ssurround", fontSize: 22, color: Colors.black),
                    )
                  ]
                ),
              ),
            ],
          ),
          )
        );
        }
        }
      )
  );
  }
}

