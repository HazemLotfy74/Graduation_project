import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';
import '../Provider/auth_provider.dart';
import 'Login_Screen.dart';

class RegisterScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _name = TextEditingController();

  RegisterScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              "assets/mobile-bk2.png",
              fit: BoxFit.fill,
            ),),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     Text(
                      "Sign Up",
                      style:  GoogleFonts.nerkoOne(fontSize: 30, fontWeight: FontWeight.bold,color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      controller: _name,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter your name";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        label: const Text('Name'),
                        prefixIcon:  Icon(EvaIcons.person,color: HexColor('fc746c'),),
                        constraints: const BoxConstraints(
                            maxWidth: 280
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
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
                        constraints: const BoxConstraints(
                            maxWidth: 280
                        ),
                        label: const Text('Email'),
                        prefixIcon:  Icon(EvaIcons.email,color: HexColor('fc746c'),),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: Provider.of<AuthProvider>(context).obscure,
                      controller: _password,
                      validator: (value) {
                        if (value!.isEmpty || value.length < 3) {
                          return "Please enter your password";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        constraints: const BoxConstraints(
                            maxWidth: 280
                        ),
                        hintText: 'Enter Password',
                        label: const Text('Password'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon:  Icon(EvaIcons.lock,color: HexColor('fc746c'),),
                        suffixIcon: IconButton(icon: Icon(EvaIcons.eye,color: HexColor('fc746c'),),onPressed:(){
                          Provider.of<AuthProvider>(context,listen: false).password();},),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if(_formKey.currentState!.validate()) {
                          Provider.of<AuthProvider>(context,listen: false).register(email: _email.text, password: _password.text,name: _name.text,context: context);
                        }
                      },
                      style: ButtonStyle(
                          backgroundColor:
                          MaterialStatePropertyAll(HexColor('fc746c'))),
                      child: Text('Sign Up', style:  GoogleFonts.nerkoOne(fontSize: 20,color: Colors.white),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Already have an account?'),
                        TextButton(
                          onPressed: () {
                            Get.to(LoginScreen());
                          },
                          child: Text('Login',style:  GoogleFonts.nerkoOne(color: HexColor('fc746c'))),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ]
      ),
    );
  }
}
