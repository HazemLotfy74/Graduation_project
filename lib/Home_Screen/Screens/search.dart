
import 'package:finalproject/API/drugsdata.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';



class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>  {


  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
   var name;

  setName(nameDrug) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('name', nameDrug);
  }
 Future<String> getName() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
     name = prefs.getString('name');
    return name;
  }
  @override
  void initState() {
  getName();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.sizeOf(context);
    var prof = Provider.of<DrugInfo>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Search',style: GoogleFonts.pacifico(),),
        backgroundColor:  HexColor('fc746c'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                enableSuggestions: true,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: HexColor('fc746c')
                    )
                  ),
                  prefixIcon: Icon(Icons.search,color: Colors.grey,),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20)
                  ),
                  hintText: name==null?'Search by drug name':name,
                  hintStyle: GoogleFonts.pacifico(color: Colors.grey)
                ),
                onSubmitted: (String searchQuery) {
                  setState(() {
                    setName(searchQuery);
                    _isSearching = true;
                  });
                 prof.getData(searchQuery.trim(),context);
                 prof.runSearch(searchQuery.trim(),context).then((value){
                   setState(() {
                     _isSearching=false;
                   });
                 });
                 getName();
                },
              ),
            ),
                 if(prof.isLoading)Text("No drugs yet",style: GoogleFonts.pacifico(color: Colors.grey,fontWeight: FontWeight.bold),)
                  else if(prof.drug.isEmpty||prof.searchResult.isEmpty)CircularProgressIndicator(color: HexColor('fc746c'),)
                 else
                 Expanded(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: ListView.separated(
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 20,);
                  },
                  itemCount: prof.searchResult.length,
                  itemBuilder: (BuildContext context, int index) {
                    final data = prof.searchResult[index].data();
                    return Container(
                      width: deviceSize.width,
                      color: Colors.white70,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                        Image.network((data as Map<String, dynamic>)['image'] ?? 'error',width: 100,height:80,filterQuality: FilterQuality.high,fit: BoxFit.cover),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Drug name : ",style: TextStyle(fontSize: 18,color: Colors.grey[500],fontWeight: FontWeight.bold),),
                            Text(prof.drug[index].brandName,style: TextStyle(fontSize: 15,color: HexColor('fc746c'),fontWeight: FontWeight.bold),),
                            SizedBox(height: 15,),
                            Text("Active_ingredients:",style: TextStyle(fontSize: 18,color: Colors.grey[500],fontWeight: FontWeight.bold),),
                            Text(prof.drug[index].name,style: TextStyle(fontSize: 15,color:HexColor('fc746c'),fontWeight: FontWeight.bold ),),
                            SizedBox(height: 15,),
                            Text("Strength:",style: TextStyle(fontSize: 18,color: Colors.grey[500],fontWeight: FontWeight.bold),),
                            Text(prof.drug[index].strength,style:TextStyle(fontSize: 15,color:HexColor('fc746c'),fontWeight: FontWeight.bold ),),
                            SizedBox(height: 15,),
                            Text("alternative drug: " ,style: TextStyle(fontSize: 18,color: Colors.grey[500],fontWeight: FontWeight.bold),),
                            Text((data)['alter'] ,style: TextStyle(fontSize: 15,color:HexColor('fc746c'),fontWeight: FontWeight.bold ),),
                            Image.network((data)['alterimage'] ?? 'error',width: 70,height: 60,filterQuality: FilterQuality.high,),
                          ],
                        ),
                      ],

                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*Container(
                      width: deviceSize.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.black12,
                        shape: BoxShape.rectangle
                      ),
                      child: prof.drug.isEmpty&&prof.searchResult.isEmpty?Text("searching"):Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Drug name is : "+prof.drug[index].brandName,style: TextStyle(fontSize: 18,color: HexColor('fc746c'),fontWeight: FontWeight.bold),),
                          SizedBox(height: 10,),
                          Image.network((data as Map<String, dynamic>)['image'] ?? 'error',width: 70,height: 60,filterQuality: FilterQuality.high,),
                          SizedBox(height: 10,),
                          Text("Active_ingredients is : "+prof.drug[index].name,style: TextStyle(fontSize: 15),),
                          SizedBox(height: 10,),
                          Text("Strength is : "+prof.drug[index].strength,style: TextStyle(fontSize: 15),),
                          SizedBox(height: 10,),
                          Text("alternative drug is : "+(data)['alter'] ,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                          SizedBox(height: 10,),
                          Image.network((data)['alterimage'] ?? 'error',width: 70,height: 60,filterQuality: FilterQuality.high,),


                        ],
                      )
                    );*/

/*ListTile(
                        leading: Image.network((data as Map<String, dynamic>)['image'] ?? 'error',width: 80,filterQuality: FilterQuality.high,fit: BoxFit.cover),
                        title:  Column(
                          children: [
                            Text("Drug name : ",style: TextStyle(fontSize: 18,color: Colors.grey[500],fontWeight: FontWeight.bold),),
                            Text(prof.drug[index].brandName,style: TextStyle(fontSize: 15,color: HexColor('fc746c'),fontWeight: FontWeight.bold),),
                            SizedBox(height: 15,),
                            Text("Active_ingredients:",style: TextStyle(fontSize: 18,color: Colors.grey[500],fontWeight: FontWeight.bold),),
                            Text(prof.drug[index].name,style: TextStyle(fontSize: 15,color:HexColor('fc746c'),fontWeight: FontWeight.bold ),),
                            SizedBox(height: 15,),
                            Text("Strength:",style: TextStyle(fontSize: 18,color: Colors.grey[500],fontWeight: FontWeight.bold),),
                            Text(prof.drug[index].strength,style:TextStyle(fontSize: 15,color:HexColor('fc746c'),fontWeight: FontWeight.bold ),),
                            SizedBox(height: 15,),
                            Text("alternative drug: " ,style: TextStyle(fontSize: 18,color: Colors.grey[500],fontWeight: FontWeight.bold),),
                            Text((data)['alter'] ,style: TextStyle(fontSize: 15,color:HexColor('fc746c'),fontWeight: FontWeight.bold ),),
                            Image.network((data)['alterimage'] ?? 'error',width: 70,height: 60,filterQuality: FilterQuality.high,),
                          ],
                        ),
                      ),*/