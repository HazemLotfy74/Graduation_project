
import 'package:finalproject/API/drugsdata.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';



class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {


  final TextEditingController _searchController = TextEditingController();


  @override
  Widget build(BuildContext context) {
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
                  hintText: 'Search by drug name',
                  hintStyle: GoogleFonts.pacifico(color: Colors.grey)
                ),
                onSubmitted: (String searchQuery) {
                 prof.getData(searchQuery.trim());
                 prof.runSearch(searchQuery.trim());

                },
              ),
            ),

            prof.drug.isEmpty && prof.searchResult.isEmpty?
            Center(child: Text("No drugs searched for now",style: GoogleFonts.pacifico(color: Colors.grey,fontSize: 20),))
                :
                 Expanded(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: ListView.separated(
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 20,);
                  },
                  itemCount: prof.drug.length,
                  itemBuilder: (BuildContext context, int index) {
                    final data = prof.searchResult[index].data();
                    return Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.black12,
                        shape: BoxShape.rectangle
                      ),
                      child: Column(
                        children: [
                          Text("Drug name is : "+prof.drug[index].brandName,style: TextStyle(fontSize: 18,color: HexColor('fc746c'),fontWeight: FontWeight.bold),),
                          SizedBox(height: 5,),
                          Image.network((data as Map<String, dynamic>)['image'] ?? 'error',width: 70,height: 60,filterQuality: FilterQuality.high,),
                          SizedBox(height: 5,),
                          Text("Active_ingredients is : "+prof.drug[index].name,style: TextStyle(fontSize: 15),),
                          SizedBox(height: 5,),
                          Text("Strength is : "+prof.drug[index].strength,style: TextStyle(fontSize: 15),),
                          SizedBox(height: 5,),
                          Text("alternative drug is : "+(data)['alter'] ,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                          Image.network((data)['alterimage'] ?? 'error',width: 70,height: 60,filterQuality: FilterQuality.high,),


                        ],
                      )
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
// prof.isLoading?
//                 CircularProgressIndicator():
//                 prof.searchResult.isEmpty?Center(child: Text("No drugs searched for now",style: GoogleFonts.pacifico(color: Colors.grey,fontSize: 20),))
