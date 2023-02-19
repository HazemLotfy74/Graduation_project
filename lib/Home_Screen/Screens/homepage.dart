import 'package:animated_icon_button/animated_icon_button.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:finalproject/Authentication/Provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

import '../../Database/database.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool textScanning = false;

  XFile? imageFile;

  String scannedText = "";

  final _formKey = GlobalKey<FormState>();
  String? drugName;
  DatabaseHelper data = DatabaseHelper();
  var result;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      drawer: MyDrawer(context),
      appBar: AppBar(
        backgroundColor: HexColor('fc746c'),
        centerTitle: true,
        title: Text("Roshta",style: GoogleFonts.pacifico(
          textStyle: TextStyle(fontSize: 25,color: Colors.white)
        ),),
        actions: [
          AnimatedIconButton(onPressed: () {
            AwesomeDialog(
              context: context,
              dialogType: DialogType.question,
              animType: AnimType.topSlide,
              transitionAnimationDuration: Duration(seconds: 1),
              padding: EdgeInsets.all(10),
              width: double.infinity,
              body: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a drug name';
                          }
                          return null;
                        },
                        onChanged: (Value)async {
                          drugName=Value;
                          result = await data.searchDrug(drugName!);
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(25))
                          ),
                          constraints: BoxConstraints(maxWidth: 200,maxHeight: 120),
                          prefixIcon:Icon(Icons.search),
                          hintText: 'Search for a drug',
                        )
                    ),
                  ],
                ),
              ),
              title: 'Search',
              btnCancelOnPress: () {},
              btnOkOnPress: () async {
                if (_formKey.currentState!.validate()) {
                  final result =  await data.searchDrug(drugName!);
                  print(result);
                }
                AwesomeDialog(
                  context: context,
                  animType: AnimType.bottomSlide,
                  dialogType: DialogType.info,
                  body: Column(
                    children: [
                      Text(drugName==null?"No drugs entered":"$drugName ${result.toString()}",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)
                    ],
                  ),
                  btnOkOnPress: () {
                    drugName=null;
                  },
                  btnCancelOnPress: () {},
                )..show();
              },

            )..show();
          },
              icons:[AnimatedIconItem(icon: Icon(EvaIcons.search,color: Colors.white,))],
           splashColor: Colors.white,
            duration: Duration(seconds: 1),
          )
        ],
      ),
      body: Center(
          child: SingleChildScrollView(
        child: Container(
            margin: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (textScanning) const LinearProgressIndicator(),
                if (!textScanning && imageFile == null)
                  Container(
                    width: 300,
                    height: 300,
                    color: Colors.grey[300]!,
                  ),
                if (imageFile != null) Image.file(File(imageFile!.path)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        padding: const EdgeInsets.only(top: 10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.grey,
                            backgroundColor: Colors.white,
                            shadowColor: Colors.grey[400],
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                          ),
                          onPressed: () {
                            getImage(ImageSource.gallery);
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                 Icon(
                                  Iconsax.gallery,
                                  color: HexColor('fc746c'),
                                  size: 30,
                                ),
                                Text(
                                  "Gallery",
                                  style: GoogleFonts.pacifico(
                                    textStyle: TextStyle(fontSize: 13,color: Colors.grey[600])
                                  ),
                                )
                              ],
                            ),
                          ),
                        )),
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        padding: const EdgeInsets.only(top: 10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.grey,
                            backgroundColor: Colors.white,
                            shadowColor: Colors.grey[400],
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                          ),
                          onPressed: () {
                            getImage(ImageSource.camera);
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                 Icon(
                                 LineAwesome.camera_solid,
                                  color: HexColor('fc746c'),
                                  size: 30,
                                ),
                                Text(
                                  "Camera",
                                  style: GoogleFonts.pacifico(
                                      textStyle: TextStyle(fontSize: 13,color: Colors.grey[600])
                                  ),
                                )
                              ],
                            ),
                          ),
                        )),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  scannedText,
                  style: const TextStyle(fontSize: 20),
                )
              ],
            )),
      )),
    );
  }

  void getImage(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        textScanning = true;
        imageFile = pickedImage;
        setState(() {});
        // getRecognisedText(pickedImage);
      }
    } catch (e) {
      textScanning = false;
      imageFile = null;
      scannedText = "Error occurred while scanning";
      setState(() {});
    }
  }

  /*void getRecognisedText(XFile image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    final textDetector = GoogleMlKit.vision.textRecognizer();
    RecognizedText recognisedText = await textDetector.processImage(inputImage);
    await textDetector.close();
    scannedText = "";
    for (TextBlock block in recognisedText.blocks) {
      for (TextLine line in block.lines) {
        scannedText = "$scannedText${line.text}\n";
      }
    }
    textScanning = false;
    setState(() {});
  }*/

  @override
  void initState() {
    super.initState();
    data.open();
  }
}

MyDrawer(context) {
  var user = Provider.of<AuthProvider>(context).user;
  Provider.of<AuthProvider>(context).getUser();
  var saif_url = 'https://seif-online.com/';
  var alDawaa_url = 'https://www.al-dawaa.com/';
  var misr_url = ' https://misr-online.com/ ';
  var vezeeta_url = 'https://www.vezeeta.com/ar-eg/pharmacy';
  return Drawer(
    backgroundColor: Colors.white,
    child: ListView(
      children: [
        AppBar(
          backgroundColor: HexColor('fc746c'),
          toolbarHeight: 100,
          leading: CircleAvatar(
            backgroundColor: Colors.white,
            child: Image(image: NetworkImage(Provider.of<AuthProvider>(context).user.image==null?'https://t3.ftcdn.net/jpg/01/18/01/98/360_F_118019822_6CKXP6rXmVhDOzbXZlLqEM2ya4HhYzSV.jpg':user.image,),),
            radius: 10,
          ),
          leadingWidth: 60,
          title: Column(
            children: [
              Text(
                Provider.of<AuthProvider>(context).user.name==null?'':user.name,
                style: TextStyle(fontSize: 15),
              ),
              Text(
                Provider.of<AuthProvider>(context).user.email==null?"":user.email,
                style: TextStyle(fontSize: 15),
              )
            ],
          ),
          actions: [
            IconButton(onPressed: () {
              Provider.of<AuthProvider>(context,listen: false).logout();
            }, icon: Icon(Iconsax.logout))
          ],
        ),
        ListTile(
            leading: CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage('assets/سيف.png'),
            ),
            title: InkWell(
              child: Text(
                "Seif",
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
            ),
            onTap: () async {
              await launch(
                saif_url,
                enableJavaScript: true,
                forceWebView: true,
              );
            }),
        SizedBox(child: Container(width: double.infinity,height: 1.2,color: Colors.grey[300],),),
        ListTile(
          leading: CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage('assets/الدواء.jpg'),
          ),
          title: InkWell(
              child: Text("Al-dawaa",
                style: TextStyle(
                    fontSize: 20, color: Colors.black),),
          ),
          onTap: () async {
              await launch(
                alDawaa_url,
                enableJavaScript: true,
                forceWebView: true,
              );
            }
        ),
        SizedBox(child: Container(width: double.infinity,height: 1.2,color: Colors.grey[300],),),
        ListTile(
            leading: CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage('assets/فيزيتا.png'),
            ),
            title: InkWell(
                child: Text("Veezeta",
                  style: TextStyle(
                      fontSize: 20, color: Colors.black),),
            ),
            onTap:()async {
              await launch(vezeeta_url,enableJavaScript: true,forceWebView: true,);
            }
        ),
        SizedBox(child: Container(width: double.infinity,height: 1.2,color: Colors.grey[300],),),
        ListTile(
            leading: CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage('assets/مصر.png'),
            ),
            title: InkWell(
                child: Text("Masr",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black),),
            ),
            onTap:()async {
              await launch(misr_url,
                enableJavaScript: true,
                forceWebView: true,);
            }
        ),
        SizedBox(child: Container(width: double.infinity,height: 1.2,color: Colors.grey[300],),),

      ],
    ),
  );
}
