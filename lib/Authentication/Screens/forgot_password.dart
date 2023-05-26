import 'package:finalproject/Authentication/Screens/Login_Screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';

import '../Provider/auth_provider.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  TextEditingController _email = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.black,),onPressed: () => Get.to(LoginScreen()),),
        title: Text("Reset Password",style: TextStyle(color: Colors.black),),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/Forgot password-pana.png",height: 250,width: 300,),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: _email,
                validator: (value) {
                  if (value!.isEmpty || !value.contains("@")) {
                    return "Please enter your email";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  constraints: const BoxConstraints(maxWidth: 350),
                  label: const Text(
                    'Email',
                  ),
                  prefixIcon:  Icon(
                    EvaIcons.email,
                    color: HexColor('fc746c'),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Colors.grey, style: BorderStyle.solid)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Colors.grey, style: BorderStyle.solid)),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Provider.of<AuthProvider>(context, listen: false).resetPassword(
                        email: _email.text.trim(),
                        context: context);
                  }
                },
                style: ButtonStyle(
                    backgroundColor:
                    MaterialStatePropertyAll(HexColor('fc746c'))),
                child:  Text(
                  'Reset',
                  style:  GoogleFonts.nerkoOne(fontSize: 20),
                ),

              )
            ],
          ),
        ),
      ),
    );
  }
}
