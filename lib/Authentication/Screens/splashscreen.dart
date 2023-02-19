
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:finalproject/Authentication/Screens/Welcome_screen.dart';
import 'package:finalproject/Authentication/Screens/stilllogin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
        splash:Column(
          children: [
            Image.asset('assets/rx.png',width: 200,height: 200,),
            SizedBox(height: 5,),
            Text("Roshta",style: GoogleFonts.nerkoOne(fontSize: 35,fontWeight: FontWeight.bold,color: HexColor('fc746c'),),),
          ],
        ),
        splashTransition: SplashTransition.fadeTransition,
        duration: 4000,
        animationDuration: Duration(seconds: 1),
        nextScreen: BoardingScreen(),
      splashIconSize: 250,

    );
  }
}
