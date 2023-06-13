
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';

import 'ApiRequest.dart';

class DrugInfo extends ChangeNotifier{
  List<DrugModel> drug = [];
  List<DocumentSnapshot> searchResult = [];
 static bool isLoading = true;
  Future getData(String drugName)async{
    try{
      var dio = await Dio().get('https://drug-info-and-price-history.p.rapidapi.com/1/druginfo?drug=$drugName',options: Options(
          headers: {
            'X-RapidAPI-Key':"69d0f406dcmsh026b208718d31e2p1a9f5bjsnf742a5611741",
            "X-RapidAPI-Host":"drug-info-and-price-history.p.rapidapi.com"
          }
      ));
      drug = List<DrugModel>.from(dio.data.map((e)=>DrugModel.fromJson(e)));
      isLoading=false;
      notifyListeners();
    }
    catch(e){
      GetSnackBar(duration: Duration(seconds: 3),backgroundColor: Colors.red,message: "No drugs found",).show();
      notifyListeners();
    }
      notifyListeners();
}

  runSearch(String searchQuery) async{
    // perform search query on Firestore
    try{
     await FirebaseFirestore.instance
          .collection('drugs')
          .where('name', isEqualTo: searchQuery)
          .get()
          .then((QuerySnapshot querySnapshot) {
        searchResult = querySnapshot.docs;
        isLoading = false;
        notifyListeners();
      });
    }
    catch(e){
      GetSnackBar(duration: Duration(seconds: 3),backgroundColor: Colors.red,message: "No drugs found",).show();
      notifyListeners();
    }
   notifyListeners();
  }
}