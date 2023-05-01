import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CircleBookController extends GetxController {
  final _authentication = FirebaseAuth.instance;
  String UserEmail = "";
  String UserName = "";


  void authCatch() async{
    final user = await _authentication.currentUser;
    if(user != null){
      UserEmail = user.email!;
    }
  }
  //Debugcode
  void displayemail() {
    print(UserEmail);
  }
  String returnEmail() {
    return UserEmail;
  }

  signIn({required String email, required String password}) {}
}