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
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: Container(
                margin: const EdgeInsets.all(10),
                height: MediaQuery.of(context).size.height - 20,
                padding: const EdgeInsets.only(
                  top: 30,
                  left: 20,
                  right: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      '모두와 함께하는 독서,',
                      style: TextStyle(
                        letterSpacing: 1.0,
                        fontSize: 30,
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
                          fontSize: 30,
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
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: Image.asset('assets/icons/아이콘_배경x(512px).png'),
                    )
                  ],
                ),
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(microseconds: 500),
              curve: Curves.easeIn,
              top: 300,
              child: AnimatedContainer(
                duration: const Duration(microseconds: 500),
                curve: Curves.easeIn,
                padding: const EdgeInsets.all(20.0),
                height: isSignupScreen ? 470.0 : 400.0,
                width: MediaQuery.of(context).size.width - 40,
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 5,
                          spreadRadius: 5)
                    ]),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 20),
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
                                    height: 2,
                                    width: 55,
                                    color: const Color(0xff6DC4DB),
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
                                    width: 55,
                                    color: const Color(0xff6DC4DB),
                                  )
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (isSignupScreen)
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  key: const ValueKey(1),
                                  validator: (value) {
                                    if (value!.isEmpty || value.length < 4) {
                                      return '최소 4자 이상의 이름을 입력해 주십시오.';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    userName = value!;
                                  },
                                  decoration: const InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.account_circle,
                                        color: Palette.iconColor,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Palette.textColor1),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(35.0),
                                        ),
                                      ),
                                      hintText: '닉네임',
                                      hintStyle: TextStyle(
                                          fontSize: 14,
                                          color: Palette.textColor1),
                                      contentPadding: EdgeInsets.all(10)),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  key: const ValueKey(2),
                                  validator: (value) {
                                    if (value!.isEmpty ||
                                        !value.contains('@')) {
                                      return '정확한 이메일 형식을 입력해 주십시오.';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    userEmail = value!;
                                  },
                                  decoration: const InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.email,
                                        color: Palette.iconColor,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Palette.textColor1),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(35.0),
                                        ),
                                      ),
                                      hintText: '이메일 주소',
                                      hintStyle: TextStyle(
                                          fontSize: 14,
                                          color: Palette.textColor1),
                                      contentPadding: EdgeInsets.all(10)),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                TextFormField(
                                  obscureText: true,
                                  key: const ValueKey(3),
                                  validator: (value) {
                                    if (value!.isEmpty || value.length < 6) {
                                      return '최소 6자 이상의 비밀번호를 입력해 주십시오.';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    userPassword = value!;
                                  },
                                  decoration: const InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.lock,
                                        color: Palette.iconColor,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Palette.textColor1),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(35.0),
                                        ),
                                      ),
                                      hintText: '비밀번호',
                                      hintStyle: TextStyle(
                                          fontSize: 14,
                                          color: Palette.textColor1),
                                      contentPadding: EdgeInsets.all(10)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      if (!isSignupScreen)
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  key: const ValueKey(4),
                                  validator: (value) {
                                    if (value!.isEmpty ||
                                        !value.contains('@')) {
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
                                  decoration: const InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.email,
                                        color: Palette.iconColor,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Palette.textColor1),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(35.0),
                                        ),
                                      ),
                                      hintText: '이메일 주소',
                                      hintStyle: TextStyle(
                                          fontSize: 14,
                                          color: Palette.textColor1),
                                      contentPadding: EdgeInsets.all(10)),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                TextFormField(
                                  obscureText: true,
                                  key: const ValueKey(5),
                                  validator: (value) {
                                    if (value!.isEmpty || value.length < 6) {
                                      return '최소 6자 이상의 비밀번호를 입력해 주십시오.';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    userPassword = value!;
                                  },
                                  onChanged: (value) {
                                    userPassword = value;
                                  },
                                  decoration: const InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.lock,
                                        color: Palette.iconColor,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Palette.textColor1),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(35.0),
                                        ),
                                      ),
                                      hintText: '비밀번호',
                                      hintStyle: TextStyle(
                                          fontSize: 14,
                                          color: Palette.textColor1),
                                      contentPadding: EdgeInsets.all(10)),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                              ],
                            ),
                          ),
                        ),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          height: 55,
                          width: 400,
                          decoration: BoxDecoration(
                              color: const Color(0xff6DC4DB),
                              borderRadius: BorderRadius.circular(15)),
                          child: GestureDetector(
                            onTap: () async {
                              if (isSignupScreen) {
                                _tryValidation();
                                try {
                                  final newUser = await _authentication
                                      .createUserWithEmailAndPassword(
                                    email: userEmail,
                                    password: userPassword,
                                  );
                                  if (newUser.user != null) {
                                    firestore
                                        .collection('users')
                                        .doc(FirebaseAuth
                                            .instance.currentUser?.uid)
                                        .set({
                                      "userName": userName,
                                      "userEmail": userEmail,
                                      "userUID":
                                          FirebaseAuth.instance.currentUser?.uid
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
                                  //print(e);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('이메일 혹은 비밀번호를 체크해주시기 바랍니다.'),
                                      backgroundColor: Colors.blue,
                                    ),
                                  );
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
                                //print(e);
                                Future.delayed(Duration.zero, () {
                                  final scaffoldContext =
                                      ScaffoldMessenger.of(context);
                                  scaffoldContext.showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('이메일 혹은 비밀번호를 체크해주시기 바랍니다.'),
                                      backgroundColor: Colors.blue,
                                    ),
                                  );
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
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: SizedBox(
                          width: 400,
                          child:
                              Image.asset('assets/icons/Google로 시작히기(예시).png'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
