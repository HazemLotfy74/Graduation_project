import 'package:sqflite/sqflite.dart';


class DatabaseHelper{
  Database? db;
  Future open() async {
    var databasesPath = await getDatabasesPath();
    String path = '$databasesPath/drugs.db';

    // Open database
    db = await openDatabase(path, version: 3,
        onCreate: (Database database, int version) async {
          // Create masr table
          await database.execute(
            'CREATE TABLE eldawa (name TEXT PRIMARY KEY)',
          ).then((value) {print("Table1 created");}).catchError((e){
            print(e);
          });

          await database.execute(
            'CREATE TABLE masr (name TEXT PRIMARY KEY)',
          ).then((value) {print("Table2 created");}).catchError((e){
            print(e);
          });
          await database.execute(
            'CREATE TABLE vezeta (name TEXT PRIMARY KEY)',
          ).then((value) {print("Table3 created");}).catchError((e){
            print(e);
          });


          // Insert eldawa into table
          await database.insert('eldawa', {'name': 'Aspirin'});
          await database.insert('eldawa', {'name': 'panadol'});
          await database.insert('eldawa', {'name': 'Acetaminophen'});
          await database.insert('eldawa', {'name': 'omega'});
          await database.insert('eldawa', {'name': 'Paracetamol'});

          // Insert masr into table
          await database.insert('masr', {'name': 'cataflam'});
          await database.insert('masr', {'name': 'panadol'});
          await database.insert('masr', {'name': 'omega'});
          await database.insert('masr', {'name': 'pandarex'});
          await database.insert('masr', {'name': 'voltareen'});

          await database.insert('vezeta', {'name': 'spasmo'});
          await database.insert('vezeta', {'name': 'panadol'});
          await database.insert('vezeta', {'name': 'signal'});
          await database.insert('vezeta', {'name': 'otrivin'});
          await database.insert('vezeta', {'name': 'omega'});

        }).then((value) {
      print("insert succefully");
    }).catchError((e){
      print(e);
    });

  }

  Future<List<String>> searchDrug(String drugName) async {
    final database = await openDatabase('drugs.db');

    final results1 = await database.query(
      'eldawa',
      where: 'name = ?',
      whereArgs: [drugName],
    );

    final results2 = await database.query(
      'masr',
      where: 'name = ?',
      whereArgs: [drugName],
    );

    final results3 = await database.query(
      'vezeta',
      where: 'name = ?',
      whereArgs: [drugName],
    );

    List<String> tableNames = [];
    if (results1.isNotEmpty) {
      tableNames.add(' متوفر فى صيدلية الدواء ');
    }
    if (results2.isNotEmpty) {
      tableNames.add('متوفر فى صيدلية مصر');
    }
    if (results3.isNotEmpty) {
      tableNames.add('متوفر فى صيدلية فيزيتا');
    }

    if (tableNames.isEmpty) {
      tableNames.add('هذا الدواء غير متوفر فى اى صيدلية');
    }

    return tableNames;
  }

}