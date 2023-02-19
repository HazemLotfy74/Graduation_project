import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class ControlProvider with ChangeNotifier{
  FirebaseAuth stillLogin = FirebaseAuth.instance;
  String? id;

  ControlProvider(){
    get();
  }

  void get(){
    id = stillLogin.currentUser?.uid??null;
    notifyListeners();
  }
}