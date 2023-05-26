
import 'package:finalproject/Authentication/Provider/auth_provider.dart';
import 'package:finalproject/Home_Screen/Screens/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tflite/tflite.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool textScanning = false;
  XFile? imageFile;
 bool imageSelect = false;


 late List dataResults;

 Future loadModel()async{

   String? res;
   res= await Tflite.loadModel(
        model: "assets/model_unquant.tflite",
        labels: "assets/labels.txt"
    );
   print("models loading $res");
  }
 void initState() {
    loadModel().then((value){
      setState(() {
      });
    });
    super.initState();
  }
  @override
  void dispose() async{
    Tflite.close();
    super.dispose();
  }

Future classifyImage(XFile imageFile) async {
  var recognitions = await Tflite.runModelOnImage(path: imageFile.path,
    imageStd:50,
    imageMean: 150,
    threshold: 0.1,
    numResults: 1,
  );
  setState(() {
    dataResults = recognitions!;
    imageSelect = true;
    textScanning = false;
  });
}

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
          IconButton(
            onPressed: () {
              Get.to(SearchScreen());
          },
            icon:Icon(Icons.search)
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
                  height: 30,
                ),
                Column(
                  children: (imageSelect)? dataResults.map((e){
                    return Card(
                      child: Container(
                        child: Text(
                          "the prediction drug is : ${e['label'].toString()}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
                        ),
                      ),
                    );
                  }).toList():[
                    Text("No image selected",style: GoogleFonts.pacifico(color: Colors.grey,fontSize: 20),)
                  ],
                )
              ],
            )
            ),
      )),
    );
  }

  void getImage(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        textScanning = true;
        imageFile = pickedImage;
        setState(() {
          imageFile = pickedImage;
        });
      }
    } catch (e) {
      textScanning = false;
      imageFile = null;
      setState(() {});
    }
    classifyImage(imageFile!);
  }





}

MyDrawer(context) {

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
          leading: Padding(
            padding: const EdgeInsets.all(5),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: FadeInImage(image: NetworkImage(Provider.of<AuthProvider>(context).user.image),
                placeholder: AssetImage('assets/user.png'),
                imageErrorBuilder: (context, error, stackTrace) {
                    return Image.asset('assets/user.png');
                  },
              ),
              radius: 10,
            ),
          ),
          leadingWidth: 60,
          title: Column(
            children: [
              Text(
                Provider.of<AuthProvider>(context).user.name,
                style: TextStyle(fontSize: 15),
              ),
              Text(
                Provider.of<AuthProvider>(context).user.email,
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
              await launchUrl(
                Uri.parse(saif_url),
               webViewConfiguration: WebViewConfiguration(enableJavaScript: true)
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
              await launchUrl(
               Uri.parse( alDawaa_url),
                webViewConfiguration: WebViewConfiguration(enableJavaScript: true)
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
              await launchUrl(Uri.parse(vezeeta_url),webViewConfiguration: WebViewConfiguration(enableJavaScript: true));
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
              await launchUrl(Uri.parse(misr_url),
                webViewConfiguration: WebViewConfiguration(enableJavaScript: true)
              );
            }
        ),
        SizedBox(child: Container(width: double.infinity,height: 1.2,color: Colors.grey[300],),),
      ],
    ),
  );
}


