import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../Home_Screen/Screens/homepage.dart';
import '../Provider/controlprovider.dart';
import 'Login_Screen.dart';




class StillLogin extends StatelessWidget {
  const StillLogin({super.key});


  @override
  Widget build(BuildContext context) {
    return Consumer<ControlProvider>(builder: (context, value, child) {
      return value.id==null ? LoginScreen():const HomePage();
    },);
  }
}
