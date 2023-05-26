import 'dart:async';
import 'package:finalproject/Authentication/Provider/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../../Home_Screen/Screens/homepage.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {

  bool isVerified = false;
  bool canResend = false;
  Timer? time;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isVerified = Provider.of<AuthProvider>(context,listen: false).loginAuth.currentUser!.emailVerified;

    if(!isVerified){
      sendVerificationEmail();
      time = Timer.periodic(const Duration(seconds: 5), (_) =>checkEmail());
    }
  }
  @override
  void dispose() {
    // TODO: implement dispose
    time?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return isVerified ?
    const HomePage():
    Scaffold(
      backgroundColor: HexColor('fc746c'),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Container(
            width: 350,
            height: 600,
            decoration:  const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15))
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Image(image: AssetImage('assets/email.png')),
                  const SizedBox(height: 30,),
                   Text("You have entered ${Provider.of<AuthProvider>(context).loginAuth.currentUser!.email.toString()} as the email address of your account "
                       "please verify your email address"),
                  const SizedBox(height: 30,),
                  ElevatedButton(onPressed: canResend ? sendVerificationEmail : null,
                    style: const ButtonStyle(fixedSize: MaterialStatePropertyAll(Size(230, 30))),
                      child: Row(
                        children: const [
                          Icon(Icons.verified_sharp),
                          Text("Resend email verification"),
                        ],
                      ),
                  ),
                  ElevatedButton(onPressed: () {
                    Provider.of<AuthProvider>(context,listen: false).logout();
                  },
                    style: const ButtonStyle(fixedSize: MaterialStatePropertyAll(Size(150, 30))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.exit_to_app_rounded),
                      Text("Cancel"),
                    ],
                  ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future sendVerificationEmail() async {
    try{
      final user = Provider.of<AuthProvider>(context,listen: false).loginAuth.currentUser!;
      await user.sendEmailVerification();
      setState(() {
        canResend = false;
      });
      await Future.delayed(Duration(seconds: 5));
      setState(() {
        canResend = true;
      });
      Get.dialog(await QuickAlert.show(context: context, type: QuickAlertType.success,text:"Email verification has been sent successfully" ));}
   on FirebaseAuthException catch(e){
      Get.dialog(await QuickAlert.show(context: context, type: QuickAlertType.error,text: e.toString()));
    }
  }

  Future checkEmail() async{
    await Provider.of<AuthProvider>(context,listen: false).loginAuth.currentUser!.reload();
    setState(() {
      isVerified = Provider.of<AuthProvider>(context,listen: false).loginAuth.currentUser!.emailVerified;
    });
    if(isVerified) time?.cancel();
  }
}
