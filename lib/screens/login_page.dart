import 'package:circle_book/palette.dart';
import 'package:circle_book/screens/main/m_base_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:circle_book/controller/login_service.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final _authentication = FirebaseAuth.instance;
  bool isSignupScreen = false;
  final _formKey = GlobalKey<FormState>();
  String userName = '';
  String userEmail = '';
  String userPassword = '';

  String errorMessage1 = '',
      errorMessage2 = '',
      errorMessage3 = '',
      errorMessage4 = '';
  bool errorPosition1 = false,
      errorPosition2 = false,
      errorPosition3 = false,
      errorPosition4 = false;

  void _tryValidation() {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    Get.put(AuthManage());
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(
                top: 50,
                left: 30,
                right: 30,
              ),
              child: Column(
                children: [
                  const Text(
                    '모두와 함께하는 독서,',
                    style: TextStyle(
                      letterSpacing: 1.0,
                      fontSize: 24,
                      color: Colors.black,
                      fontFamily: "SsurroundAir",
                      fontWeight: FontWeight.bold,
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
                        fontSize: 24,
                        color: Colors.black,
                        fontFamily: "SsurroundAir",
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                          text: '써클북',
                          style: TextStyle(
                            color: Color(0xff6DC4DB),
                          ),
                        ),
                        TextSpan(
                          text: '과 함께 하세요.',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.height * 0.15,
                    child: AspectRatio(
                        aspectRatio: 1 / 1,
                        child: Image.asset('assets/icons/아이콘_배경x(512px).png')),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20.0),
              width: MediaQuery.of(context).size.width,
              height: isSignupScreen
                  ? MediaQuery.of(context).size.height * 0.53
                  : MediaQuery.of(context).size.height * 0.45,
              margin: const EdgeInsets.symmetric(horizontal: 30.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 5,
                        spreadRadius: 5)
                  ]),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isSignupScreen = false;
                            errorPosition2 = false;
                            errorPosition3 = false;
                            errorPosition4 = false;
                          });
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '로그인',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: "SsurroundAir",
                                  fontWeight: FontWeight.bold,
                                  color: !isSignupScreen
                                      ? Colors.black
                                      : Palette.textColor1),
                            ),
                            if (!isSignupScreen)
                              Container(
                                margin: const EdgeInsets.only(top: 3),
                                height: 2,
                                width: 100,
                                color: const Color(0xff6DC4DB),
                              )
                            else
                              Container(
                                margin: const EdgeInsets.only(top: 3),
                                height: 2,
                                width: 100,
                                color: Colors.grey,
                              )
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isSignupScreen = true;
                            errorPosition1 = false;
                            errorPosition2 = false;
                            errorPosition3 = false;
                            errorPosition4 = false;
                          });
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '회원가입',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: "SsurroundAir",
                                  fontWeight: FontWeight.bold,
                                  color: isSignupScreen
                                      ? Colors.black
                                      : Palette.textColor1),
                            ),
                            if (isSignupScreen)
                              Container(
                                margin: const EdgeInsets.only(top: 3),
                                height: 2,
                                width: 100,
                                color: const Color(0xff6DC4DB),
                              )
                            else
                              Container(
                                margin: const EdgeInsets.only(top: 3),
                                height: 2,
                                width: 100,
                                color: Colors.grey,
                              )
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (isSignupScreen)
                    Container(
                      height: 180,
                      margin: const EdgeInsets.only(top: 10),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1.0, color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    height: errorPosition1 ? 40 : 55,
                                    padding: errorPosition1
                                        ? const EdgeInsets.all(0)
                                        : const EdgeInsets.only(bottom: 10),
                                    child: TextFormField(
                                      textInputAction: TextInputAction.next,
                                      key: const ValueKey(1),
                                      validator: (value) {
                                        if (value!.isEmpty ||
                                            value.length < 4) {
                                          setState(() {
                                            errorMessage1 =
                                                '최소 4자 이상의 닉네임을 입력해 주십시오.';
                                            errorPosition1 = true;
                                          });
                                        } else {
                                          setState(() {
                                            errorMessage1 = '';
                                            errorPosition1 = false;
                                          });
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        userName = value!;
                                      },
                                      textAlign: TextAlign.center,
                                      decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          hintText: '사용할 닉네임 (4자 이상)',
                                          hintStyle: TextStyle(
                                              fontSize: 15,
                                              color: Palette.textColor1),
                                          contentPadding: EdgeInsets.all(10)),
                                    ),
                                  ),
                                  if (errorPosition1)
                                    SizedBox(
                                      height: 15,
                                      child: Text(
                                        errorMessage1,
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontFamily: "SsurroundAir",
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 3),
                                    height: 1,
                                    width: MediaQuery.of(context).size.width,
                                    color: Colors.grey,
                                  ),
                                  Container(
                                    height: errorPosition2 ? 40 : 55,
                                    padding: errorPosition2
                                        ? const EdgeInsets.all(0)
                                        : const EdgeInsets.only(bottom: 10),
                                    child: TextFormField(
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.emailAddress,
                                      key: const ValueKey(2),
                                      validator: (value) {
                                        if (value!.isEmpty ||
                                            !value.contains('@')) {
                                          setState(() {
                                            errorMessage2 =
                                                '정확한 이메일 형식을 입력해 주십시오.';
                                            errorPosition2 = true;
                                          });
                                        } else {
                                          setState(() {
                                            errorMessage2 = '';
                                            errorPosition2 = false;
                                          });
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        userEmail = value!;
                                      },
                                      textAlign: TextAlign.center,
                                      decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          hintText: '이메일 주소 (@포함)',
                                          hintStyle: TextStyle(
                                              fontSize: 15,
                                              color: Palette.textColor1),
                                          contentPadding: EdgeInsets.all(10)),
                                    ),
                                  ),
                                  if (errorPosition2)
                                    SizedBox(
                                      height: 15,
                                      child: Text(
                                        errorMessage2,
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontFamily: "SsurroundAir",
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 3),
                                    height: 1,
                                    width: MediaQuery.of(context).size.width,
                                    color: Colors.grey,
                                  ),
                                  Container(
                                    height: errorPosition3 ? 40 : 55,
                                    padding: errorPosition3
                                        ? const EdgeInsets.all(0)
                                        : const EdgeInsets.only(bottom: 10),
                                    child: TextFormField(
                                      textInputAction: TextInputAction.done,
                                      onEditingComplete: () async {
                                        FocusScope.of(context).unfocus();
                                        if (isSignupScreen) {
                                          _tryValidation();
                                          try {
                                            final newUser = await _authentication
                                                .createUserWithEmailAndPassword(
                                              email: userEmail,
                                              password: userPassword,
                                            );
                                            setState(() {
                                              errorMessage4 = '';
                                              errorPosition4 = false;
                                            });
                                            if (newUser.user != null) {
                                              firestore
                                                  .collection('users')
                                                  .doc(FirebaseAuth.instance
                                                      .currentUser?.uid)
                                                  .set({
                                                "userName": userName,
                                                "userEmail": userEmail,
                                                "userUID": FirebaseAuth
                                                    .instance.currentUser?.uid,
                                                "readingbookcount": 0,
                                                "groupleadercount": 0,
                                                "certificount": 0,
                                                "reputationscore": 500,
                                                "selfintroduction": "",
                                                "complete_Achievements": [],
                                                "mounted_Achievements": [],
                                                "profileIcon":
                                                    "icons/아이콘_상태표시바용(512px)"
                                              });

                                              var scaffoldContext = context;
                                              Future.delayed(Duration.zero, () {
                                                Navigator.push(
                                                  scaffoldContext,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const MainBaseScreen()),
                                                );
                                              });
                                            }
                                          } catch (e) {
                                            setState(() {
                                              errorMessage4 = '잘못된 입력 입니다.';
                                              errorPosition4 = true;
                                            });
                                          }
                                        }
                                      },
                                      obscureText: true,
                                      key: const ValueKey(3),
                                      validator: (value) {
                                        if (value!.isEmpty ||
                                            value.length < 6) {
                                          setState(() {
                                            errorMessage3 =
                                                '최소 6자 이상의 비밀번호를 입력해 주십시오.';
                                            errorPosition3 = true;
                                          });
                                        } else {
                                          setState(() {
                                            errorMessage3 = '';
                                            errorPosition3 = false;
                                          });
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        userPassword = value!;
                                      },
                                      textAlign: TextAlign.center,
                                      decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          hintText: '사용할 비밀번호 (6자 이상)',
                                          hintStyle: TextStyle(
                                              fontSize: 15,
                                              color: Palette.textColor1),
                                          contentPadding: EdgeInsets.all(10)),
                                    ),
                                  ),
                                  if (errorPosition3)
                                    SizedBox(
                                      height: 15,
                                      child: Text(
                                        errorMessage3,
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontFamily: "SsurroundAir",
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  const SizedBox(
                                    height: 3,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (!isSignupScreen)
                    Container(
                      height: 130,
                      margin: const EdgeInsets.only(top: 10),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1.0, color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: errorPosition2 ? 40 : 55,
                                    padding: errorPosition2
                                        ? const EdgeInsets.all(0)
                                        : const EdgeInsets.only(bottom: 10),
                                    child: Center(
                                      child: TextFormField(
                                        textInputAction: TextInputAction.next,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        key: const ValueKey(4),
                                        validator: (value) {
                                          if (value!.isEmpty ||
                                              !value.contains('@')) {
                                            setState(() {
                                              errorMessage2 =
                                                  '정확한 이메일 형식을 입력해 주십시오.';
                                              errorPosition2 = true;
                                            });
                                          } else {
                                            setState(() {
                                              errorMessage2 = '';
                                              errorPosition2 = false;
                                            });
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          userEmail = value!;
                                        },
                                        onChanged: (value) {
                                          userEmail = value;
                                        },
                                        textAlign: TextAlign.center,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          hintText: '이메일 주소',
                                          hintStyle: TextStyle(
                                              fontSize: 15,
                                              color: Palette.textColor1),
                                          contentPadding: EdgeInsets.all(10),
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (errorPosition2)
                                    SizedBox(
                                      height: 15,
                                      child: Text(
                                        errorMessage2,
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontFamily: "SsurroundAir",
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  const SizedBox(
                                    height: 2.5,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 3),
                                    height: 1,
                                    width: MediaQuery.of(context).size.width,
                                    color: Colors.grey,
                                  ),
                                  Container(
                                    height: errorPosition3 ? 40 : 55,
                                    padding: errorPosition3
                                        ? const EdgeInsets.all(0)
                                        : const EdgeInsets.only(bottom: 10),
                                    child: Center(
                                      child: TextFormField(
                                        textInputAction: TextInputAction.done,
                                        onEditingComplete: () async {
                                          FocusScope.of(context).unfocus();
                                          try {
                                            setState(() {
                                              errorMessage4 = '';
                                              errorPosition4 = false;
                                            });
                                            if (!isSignupScreen) {
                                              _tryValidation();
                                              final newUser =
                                                  await _authentication
                                                      .signInWithEmailAndPassword(
                                                email: userEmail,
                                                password: userPassword,
                                              );
                                              if (newUser.user != null) {
                                                var scaffoldContext = context;
                                                Future.delayed(Duration.zero,
                                                    () {
                                                  Navigator.push(
                                                    scaffoldContext,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const MainBaseScreen()),
                                                  );
                                                });
                                              }
                                            }
                                          } catch (e) {
                                            setState(() {
                                              errorMessage4 =
                                                  '잘못된 이메일 혹은 비밀번호입니다.';
                                              errorPosition4 = true;
                                            });
                                          }
                                        },
                                        obscureText: true,
                                        key: const ValueKey(5),
                                        validator: (value) {
                                          if (value!.isEmpty ||
                                              value.length < 6) {
                                            setState(() {
                                              errorMessage3 =
                                                  '최소 6자 이상의 비밀번호를 입력해 주십시오.';
                                              errorPosition3 = true;
                                            });
                                          } else {
                                            setState(() {
                                              errorMessage3 = '';
                                              errorPosition3 = false;
                                            });
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          userPassword = value!;
                                        },
                                        onChanged: (value) {
                                          userPassword = value;
                                        },
                                        textAlign: TextAlign.center,
                                        decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            hintText: '비밀번호',
                                            hintStyle: TextStyle(
                                                fontSize: 15,
                                                color: Palette.textColor1),
                                            contentPadding: EdgeInsets.all(10)),
                                      ),
                                    ),
                                  ),
                                  if (errorPosition3)
                                    SizedBox(
                                      height: 15,
                                      child: Text(
                                        errorMessage3,
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontFamily: "SsurroundAir",
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  const SizedBox(
                                    height: 4.5,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  SizedBox(
                    height: errorPosition4 ? 10 : 40,
                  ),
                  if (errorPosition4)
                    SizedBox(
                      height: 20,
                      child: Text(
                        errorMessage4,
                        style: const TextStyle(
                          fontSize: 10,
                          fontFamily: "SsurroundAir",
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  SizedBox(
                    height: errorPosition4 ? 10 : 0,
                  ),
                  SizedBox(
                    height: 55,
                    width: MediaQuery.of(context).size.width,
                    child: MaterialButton(
                      splashColor: Colors.white60,
                      color: const Color(0xff6DC4DB),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      onPressed: () async {
                        if (isSignupScreen) {
                          _tryValidation();
                          try {
                            final newUser = await _authentication
                                .createUserWithEmailAndPassword(
                              email: userEmail,
                              password: userPassword,
                            );
                            setState(() {
                              errorMessage4 = '';
                              errorPosition4 = false;
                            });
                            if (newUser.user != null) {
                              firestore
                                  .collection('users')
                                  .doc(FirebaseAuth.instance.currentUser?.uid)
                                  .set({
                                "userName": userName,
                                "userEmail": userEmail,
                                "userUID":
                                    FirebaseAuth.instance.currentUser?.uid,
                                "readingbookcount": 0,
                                "groupleadercount": 0,
                                "certificount": 0,
                                "reputationscore": 500,
                                "selfintroduction": "",
                                "complete_Achievements": [],
                                "mounted_Achievements": [],
                                "profileIcon": "icons/아이콘_상태표시바용(512px)"
                              });

                              var scaffoldContext = context;
                              Future.delayed(Duration.zero, () {
                                Navigator.push(
                                  scaffoldContext,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const MainBaseScreen()),
                                );
                              });
                            }
                          } catch (e) {
                            setState(() {
                              errorMessage4 = '잘못된 입력 입니다.';
                              errorPosition4 = true;
                            });
                          }
                        }
                        try {
                          if (!isSignupScreen) {
                            _tryValidation();
                            final newUser = await _authentication
                                .signInWithEmailAndPassword(
                              email: userEmail,
                              password: userPassword,
                            );
                            setState(() {
                              errorMessage4 = '';
                              errorPosition4 = false;
                            });
                            if (newUser.user != null) {
                              var scaffoldContext = context;
                              Future.delayed(Duration.zero, () {
                                Navigator.push(
                                  scaffoldContext,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const MainBaseScreen()),
                                );
                              });
                            }
                          }
                        } catch (e) {
                          setState(() {
                            errorMessage4 = '잘못된 이메일 혹은 비밀번호입니다.';
                            errorPosition4 = true;
                          });
                        }
                      },
                      child: Center(
                        child: isSignupScreen
                            ? const Text('회원가입 후 로그인',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontFamily: "SsurroundAir",
                                  fontWeight: FontWeight.bold,
                                ))
                            : const Text('로그인',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontFamily: "SsurroundAir",
                                  fontWeight: FontWeight.bold,
                                )),
                      ),
                    ),
                  ),
                  /*
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Image.asset('assets/icons/Google로 시작히기(예시).png'),
                    ),
                  ),
                  */
                ],
              ),
            ),
            /*
            Container(
              margin: const EdgeInsets.only(top: 50),
              width: MediaQuery.of(context).size.width,
              child: Column(children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  color: const Color(0xff6DC4DB),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  color: Colors.white,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  color: const Color(0xffFFDC6D),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  color: const Color(0xff9C4EDB),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  color: const Color(0xff9ADBE4),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  color: const Color(0xff1F5A66),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  color: const Color(0xffCCCCCC),
                ),
              ]),
            )
            */
          ],
        ),
      ),
    );
  }
}
