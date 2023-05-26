
import 'package:animated_svg/animated_svg.dart';
import 'package:finalproject/Authentication/Screens/stilllogin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BoardingScreen extends StatefulWidget {
  const BoardingScreen({super.key});

  @override
  State<BoardingScreen> createState() => _BoardingScreenState();
}

class _BoardingScreenState extends State<BoardingScreen> {
  List<Boardingitem> board = [
    Boardingitem(image: 'assets/Hello-rafiki.svg', title: "Welcome to Roshta", body: 'A medical application'),
    Boardingitem(image: 'assets/Doctors-pana.svg', title: "Scan prescription", body: 'use your camera to recognize text from a prescription'),
    Boardingitem(image: 'assets/Questions-pana.svg', title: "Search", body: ' for any drugs in pharmacies  '),
  ];

  var boardController = PageController();

  bool isLast = false;
  late final SvgController controller;
  @override
  void initState() {
    controller = AnimatedSvgController();
    super.initState();
  }
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children:[
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset("assets/mobile-bk.png",fit: BoxFit.fill,),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: TextButton(onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const StillLogin(),));
              }, child: const Text("SKIP",style: TextStyle(fontSize: 20,color: Colors.white),),

              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
            children: [
              Expanded(
                child: PageView.builder(itemBuilder: (context, index) => buildBoardItem(board[index]),
                  itemCount: board.length,
                  controller: boardController,
                  physics: const BouncingScrollPhysics(),
                  allowImplicitScrolling: true,
                  pageSnapping: true,
                  onPageChanged: (value) {
                    if(value==board.length-1){   setState(() {
                      isLast=true;
                    });}
                    else{setState(() {
                      isLast=false;
                    });}

                  },
                ),
              ),
              const SizedBox(height: 25,),
              Row(
                children: [
                  SmoothPageIndicator(controller: boardController, count: board.length,effect:  WormEffect(
                      dotHeight: 20,
                      dotWidth: 15,
                      activeDotColor: HexColor('fc746c'),
                      dotColor:Colors.grey ,
                      spacing: 15
                  ),),
                  const Spacer(),
                  FloatingActionButton(
                    onPressed: () {
                    if(isLast){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const StillLogin(),));
                    }
                    else{boardController.nextPage(duration: const Duration(milliseconds: 950), curve: Curves.fastLinearToSlowEaseIn);}
                  },backgroundColor: Colors.white,child:  Icon(Icons.arrow_forward_ios,color: HexColor('fc746c'),),
                  )
                ],
              ),
            ],
        ),
          ),

        ]
      ),
    );
  }

  buildBoardItem(Boardingitem model){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: SvgPicture.asset(model.image)
        ),

        const SizedBox(height:5),
        Text(model.title,style: GoogleFonts.nerkoOne(
            textStyle: TextStyle(fontSize: 30,color: HexColor('fc746c'))
        ),),
        const SizedBox(height: 5,),
        Text(model.body,style: GoogleFonts.nerkoOne(
            textStyle:  TextStyle(fontSize: 20,color: Colors.grey[700])
        ))
      ],
    );
  }
}
class Boardingitem {
  final String image;
  final String title;
  final String body;

  Boardingitem({required this.image, required this.title,required this.body});
}

