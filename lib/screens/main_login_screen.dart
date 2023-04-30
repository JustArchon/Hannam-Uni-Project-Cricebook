import 'package:circle_book/config/palette.dart';
import 'package:circle_book/screens/main_books_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:circle_book/Controller/CircleBookLoginService.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart';

import 'main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen>{
  final _authentication = FirebaseAuth.instance;
    bool isSignupScreen = true;
    final _formKey = GlobalKey<FormState>();
    String userName = '';
    String userEmail = '';
    String userPassword = '';
    void _tryValidation(){
      final isValid = _formKey.currentState!.validate();
      if(isValid){
        _formKey.currentState!.save();
      }
    }
    @override
    Widget build(BuildContext conext){
      Get.put(AuthManage());
      return Scaffold(
        backgroundColor: Colors.white,
        body: GestureDetector(
          onTap: (){
            FocusScope.of(context).unfocus();
          },
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: Container(
                height: 300,
                decoration: const BoxDecoration(
                ),
                child: Container(
                  padding: const EdgeInsets.only(top: 90, left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: const TextSpan(
                          text: '모두와 함께하는',
                          style: TextStyle(
                            letterSpacing: 1.0,
                            fontSize: 25,
                            color: Colors.black
                          ),
                          children: [
                            TextSpan(
                              text: ' 독서,',
                              style: TextStyle(
                                letterSpacing: 1.0,
                                fontSize: 25,
                                color: Colors.black,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 1.0,
                      ),
                      RichText(
                        text: const TextSpan(
                          text: '지금부터 ',
                          style: TextStyle(
                            letterSpacing: 1.0,
                            fontSize: 25,
                            color: Colors.black
                          ),
                          children: [
                            TextSpan(
                              text: '써클북',
                              style: TextStyle(
                                letterSpacing: 1.0,
                                fontSize: 25,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            TextSpan(
                              text: '과 함께 하세요.',
                              style: TextStyle(
                                letterSpacing: 1.0,
                                fontSize: 25,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            AnimatedPositioned(
              duration: Duration(microseconds: 500),
              curve: Curves.easeIn,
              top: 180,
              child: AnimatedContainer(
                duration: Duration(microseconds: 500),
                curve: Curves.easeIn,
                padding: EdgeInsets.all(20.0),
                height: isSignupScreen ? 280.0 : 250.0,
                width: MediaQuery.of(conext).size.width-40,
                margin: EdgeInsets.symmetric(horizontal: 20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:  BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius : 5,
                      spreadRadius: 5
                    )
                  ]
                ),
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isSignupScreen = false;
                            });
                          },
                        child: Column(
                          children: [
                            Text(
                              'LOGIN',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color:!isSignupScreen ? Colors.black : Palette.textColor1
                              ),
                            ),
                            if(!isSignupScreen)
                            Container(
                              height: 2,
                              width: 55,
                              color: Colors.orange,
                            )
                          ],
                      ),
                    ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isSignupScreen = true;
                            });
                          },
                        child: Column(
                          children: [
                            Text(
                              'SIGNUP',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isSignupScreen ? Colors.black : Palette.textColor1
                              ),
                            ),
                            if(isSignupScreen)
                            Container(
                              margin: EdgeInsets.only(top: 3),
                              height: 2,
                              width: 55,
                              color: Colors.orange,
                            )
                          ],
                        ),
                        ),
                      ],
                    ),
                    if(isSignupScreen)
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              key: ValueKey(1),
                              validator: (value){
                                if(value!.isEmpty || value.length < 4){
                                  return '최소 4자 이상의 이름을 입력해주십시오.';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                userName = value!;
                              },
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.account_circle,
                                  color: Palette.iconColor,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Palette.textColor1
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(35.0),
                                    ),
                                  ),
                                  hintText: 'User name',
                                  hintStyle: TextStyle(
                                    fontSize: 14,
                                    color: Palette.textColor1
                                  ),
                                  contentPadding: EdgeInsets.all(10)
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              key: ValueKey(2),
                              validator: (value){
                                if(value!.isEmpty || !value.contains('@')){
                                  return '정확한 이메일 형식을 입력해 주십시오.';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                userEmail = value!;
                              },
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: Palette.iconColor,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Palette.textColor1
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(35.0),
                                    ),
                                  ),
                                  hintText: 'email',
                                  hintStyle: TextStyle(
                                    fontSize: 14,
                                    color: Palette.textColor1
                                  ),
                                  contentPadding: EdgeInsets.all(10)

                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            TextFormField(
                              obscureText: true,
                              key: ValueKey(3),
                              validator: (value){
                                if(value!.isEmpty || value.length < 9){
                                  return '최소 9자 이상의 비밀번호를 입력해 주십시오.';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                userPassword = value!;
                              },
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Palette.iconColor,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Palette.textColor1
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(35.0),
                                    ),
                                  ),
                                  hintText: 'password',
                                  hintStyle: TextStyle(
                                    fontSize: 14,
                                    color: Palette.textColor1
                                  ),
                                  contentPadding: EdgeInsets.all(10)

                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if(!isSignupScreen)
                    Container(
                      margin: EdgeInsets.only(top:20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              key: ValueKey(4),
                              validator: (value){
                                if(value!.isEmpty || !value.contains('@')){
                                  return '정확한 이메일 형식을 입력해 주십시오.';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                userEmail = value!;
                              },
                              onChanged: (value) {
                                userEmail = value;
                              },
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.account_circle,
                                  color: Palette.iconColor,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Palette.textColor1
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(35.0),
                                    ),
                                  ),
                                  hintText: 'User name',
                                  hintStyle: TextStyle(
                                    fontSize: 14,
                                    color: Palette.textColor1
                                  ),
                                  contentPadding: EdgeInsets.all(10)
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            TextFormField(
                              obscureText: true,
                              key: ValueKey(5),
                              validator: (value){
                                if(value!.isEmpty || value.length < 9){
                                  return '최소 9자 이상의 비밀번호를 입력해 주십시오.';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                userPassword = value!;
                              },
                              onChanged: (value) {
                                userPassword = value;
                              },
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.lock,
                                  color: Palette.iconColor,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Palette.textColor1
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(35.0),
                                    ),
                                  ),
                                  hintText: 'password',
                                  hintStyle: TextStyle(
                                    fontSize: 14,
                                    color: Palette.textColor1
                                  ),
                                  contentPadding: EdgeInsets.all(10)

                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            ],
                          )
                      ),
                    ),
                  ],
                  ),
              ),
            ),
            ),
            AnimatedPositioned(
              duration: Duration(microseconds: 500),
              curve: Curves.easeIn,
              top: isSignupScreen ? 430 : 390,
              right: 0,
              left: 0,
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(15),
                  height: 90,
                  width: 90,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50)
                  ),
                child: GestureDetector(
                  onTap: () async{
                    if (isSignupScreen){
                      _tryValidation();
                    

                    try {
                      final newUser = await _authentication
                        .createUserWithEmailAndPassword(
                          email: userEmail,
                          password: userPassword,
                          );
                      if(newUser.user != null){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context){
                            return MainScreen();
                          }),
                        );
                      }
                    }catch(e){
                      print(e);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                          Text('이메일 혹은 비밀번호를 체크해주시기 바랍니다.'),
                          backgroundColor: Colors. blue,
                        ),
                      );
                    }
                    }
                    try {
                    if(!isSignupScreen){
                      _tryValidation();
                      final newUser = await _authentication.signInWithEmailAndPassword(
                        email: userEmail,
                        password: userPassword,
                      );
                      if(newUser.user != null){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context){
                            return MainScreen();
                          }),
                        );
                    }
                  }
                    }catch(e){
                      print(e);
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.blue, Colors.white],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: Offset(0,1))
                    ],
                    ),
                    child: Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    )
                  ),
                ),
              ),
            ),
          ),
            Positioned(
              top: MediaQuery.of(context).size.height-125,
              right: 0,
              left: 0,
              child: Column(
                children: [
                  Text(isSignupScreen ? 'or Signup with' : 'or Signin with'),
                  SizedBox(
                    height: 10,
                  ),
                  TextButton. icon(
                    onPressed: (){},
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                      minimumSize: Size(155, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                      ),
                      backgroundColor: Colors.blue
                    ),
                    icon: Icon(Icons.add),
                    label: Text('Google'),
                  )
                ],
              )
            )
          ],
        ),
      ),
      );
    }
  }