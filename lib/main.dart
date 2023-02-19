import 'package:finalproject/Authentication/Screens/Login_Screen.dart';
import 'package:finalproject/Authentication/Screens/register_screen.dart';
import 'package:finalproject/Authentication/Screens/splashscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';
import 'Authentication/Provider/auth_provider.dart';
import 'Authentication/Provider/controlprovider.dart';
import 'Authentication/Screens/Welcome_screen.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => AuthProvider()..getUser(),),
    ChangeNotifierProvider(create: (context) => ControlProvider(),),
  ],child: const MyApp(),));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
      ),
      home:   SplashScreen()
    );
  }
}

