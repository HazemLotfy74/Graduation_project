import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quickalert/quickalert.dart';
import '../../Home_Screen/Screens/homepage.dart';
import '../Models/usermodel.dart';
import '../Screens/Login_Screen.dart';
import '../Screens/verify_email.dart';



class AuthProvider extends ChangeNotifier{
  FirebaseAuth loginAuth = FirebaseAuth.instance;
  FirebaseFirestore database = FirebaseFirestore.instance;
  GoogleSignIn googleSignIn=GoogleSignIn();
  UserModel user = UserModel(name: '', email: "", userId: "",image: "");
  bool obscure = true;
  bool check = true;
  bool isVerified = false;
  Timer? time;

  void login({ required String email ,required String password,required context})async{
    showDialog(context: context,barrierDismissible: false, builder: (context) =>  Center(child: CircularProgressIndicator(color: HexColor('fc746c'),),),);
    try{
      await loginAuth.signInWithEmailAndPassword(email: email, password: password);
      Get.offAll(const VerifyEmail());
    }
    catch(e) {
      Get.dialog(await QuickAlert.show(context: context, type: QuickAlertType.error,text: e.toString()));
    }
  }

  void register({required String email ,required String password,required String name,required context})async{
    showDialog(context: context,barrierDismissible: false, builder: (context) =>  Center(child: CircularProgressIndicator(color: HexColor('fc746c'),),),);
    try{
      await loginAuth.createUserWithEmailAndPassword(email: email, password: password).then((value) {
        saveUser(value, name,email);
      });
      Get.offAll(const VerifyEmail());
    }
   on FirebaseAuthException catch(e){
      Get.dialog(await QuickAlert.show(context: context, type: QuickAlertType.error,text: e.toString()));
    }
  }

  void logout()async{
    await loginAuth.signOut();
    Get.to(LoginScreen());
  }

  void googleSign(context)async{
    showDialog(context: context,barrierDismissible: false, builder: (context) => Center(child: CircularProgressIndicator(color: HexColor('fc746c'),),),);
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    GoogleSignInAuthentication google = await googleUser!.authentication;

    var credintal=GoogleAuthProvider.credential(idToken:google.idToken ,accessToken: google.accessToken);
    await loginAuth.signInWithCredential(credintal).then((value) {
      saveUser(value, "","");
      Get.offAll(const HomePage());
    });
  }

  void saveUser(UserCredential? user,String name,String email)async{
    if (user != null && user.user != null){
    UserModel userModel = UserModel(name: name==""?user.user!.displayName!:name,email:user.user!.email??"",image: "", userId: user.user!.uid);
    database.collection("users").doc(user.user!.uid).set(userModel.toJson()).then((value) {
    }).catchError((error)
    {print(error);});
    }
  }

  getUser()async{
    await database.collection('users').doc(loginAuth.currentUser?.uid).get().then((value) {
      if(value.exists){
      user = UserModel.fromJson(value.data()!);
      notifyListeners();}
    });
  }

  void password(){
    obscure=!obscure;
    notifyListeners();
  }


/*void facebook_login(context)async{
    final result = await FacebookAuth.i.login(permissions: ['email', 'public_profile']);
    try
    {
      if(result.status==LoginStatus.success){
        final faceData = await FacebookAuth.instance.getUserData(fields: 'email,name,id');
        print(faceData['email']);
        print(faceData['name']);
        print(faceData['id']);


        final facebookAuthCredential = FacebookAuthProvider.credential(result.accessToken!.token);
        await loginAuth.signInWithCredential(facebookAuthCredential).then((value) {
          Get.offAll(const HomePage());
        });
      }
      notifyListeners();
    }
    catch(e)
    {
     Get.dialog(await QuickAlert.show(context: context, type: QuickAlertType.error,text: e.toString()));
    }

    notifyListeners();

}*/
  Future<void> loginWithFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login();
    if (result.status == LoginStatus.success) {
      final AccessToken accessToken = result.accessToken!;
      final OAuthCredential facebookAuthCredential =
      FacebookAuthProvider.credential(accessToken.token);
      final UserCredential userCredential =
      await loginAuth.signInWithCredential(facebookAuthCredential);
      final data = await FacebookAuth.i.getUserData(fields: 'picture.type(large)');
      final User? user = userCredential.user;
      if (user != null) {
        final UserModel userModel = UserModel(
            name: user.displayName ?? '',
            email: user.email ?? '',
            userId: user.uid,
            image: data['picture']['data']['url'] ?? '');
        database.collection("users").doc(user.uid).set(userModel.toJson()).then((value) {
          notifyListeners();
        }).catchError((error) {
          print(error);
        });
        Get.to(HomePage());
      }
    } else {

    }
  }





}