import 'package:finalproject/Authentication/Screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:icons_plus/icons_plus.dart';
import '../Provider/auth_provider.dart';
import 'forgot_password.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();


  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Form(
        key: _formKey,
        child: Stack(
            children: [
          Container(
            width: deviceSize.width,
            height: deviceSize.height,
            child: Image.asset(
              "assets/mobile-bk2.png",
              fit: BoxFit.fill,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  child: Text(
                    "Hello Again! ",
                    style:  GoogleFonts.nerkoOne(fontSize: 35, fontWeight: FontWeight.bold,color:HexColor('fc746c')),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Sign in ",
                  style:  GoogleFonts.nerkoOne(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600]),
                ),
                SizedBox(height: 15,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _password,
                      obscureText: Provider.of<AuthProvider>(context).obscure,
                      keyboardType: TextInputType.visiblePassword,
                      validator: (value) {
                        if (value!.isEmpty || value.length < 3) {
                          return "Please enter your password";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        constraints: const BoxConstraints(maxWidth: 350),
                        hintText: 'Enter Password',
                        label: const Text(
                          'Password',
                        ),

                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: Colors.grey, style: BorderStyle.solid)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: Colors.grey, style: BorderStyle.solid)),
                        prefixIcon:  Icon(
                          EvaIcons.lock,
                          color: HexColor('fc746c'),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(EvaIcons.eye,color: HexColor('fc746c'),),
                          onPressed: () {
                            Provider.of<AuthProvider>(context, listen: false)
                                .password();
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Provider.of<AuthProvider>(context, listen: false).login(
                              email: _email.text,
                              password: _password.text,
                              context: context);
                        }
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(HexColor('fc746c'))),
                      child:  Text(
                        'Sign in',
                        style:  GoogleFonts.nerkoOne(fontSize: 20),
                      ),

                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text("OR",style:  GoogleFonts.nerkoOne(fontWeight: FontWeight.bold),),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(onPressed: (){
                          Provider.of<AuthProvider>(context, listen: false)
                              .googleSign(context);
                        }, icon: Logo(Logos.google)),
                        SizedBox(width: 20,
                        ),
                        IconButton(onPressed: (){
                          Provider.of<AuthProvider>(context, listen: false)
                              .loginWithFacebook();
                        }, icon: Logo(Logos.facebook_logo)),


                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                         Text(
                          'Don\'t have an account?',
                          style:  GoogleFonts.nerkoOne(fontWeight: FontWeight.bold),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.to(RegisterScreen());
                          },
                          child: Text(
                            'Sign Up',
                            style:  GoogleFonts.nerkoOne(color: HexColor('fc746c'),fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Forgot your password?',
                          style:  GoogleFonts.nerkoOne(fontWeight: FontWeight.bold),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return ForgotPassword();
                            },));
                          },
                          child: Text(
                            'Reset Password',
                            style:  GoogleFonts.nerkoOne(color: HexColor('fc746c'),fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
