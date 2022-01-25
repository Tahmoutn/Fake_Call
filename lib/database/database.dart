import 'package:fake_call/model/DataBaseModel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path/path.dart';

import '../constants.dart';

class DatabaseHelper {
  static final DatabaseHelper _helper = new DatabaseHelper.internal();

  factory DatabaseHelper() => _helper;

  static Database _database;

  Future<Database> get db async{
    if(_database != null){
      return _database;
    }
    _database = await initDatabase();
    return _database;
  }

  DatabaseHelper.internal();

  initDatabase() async{
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DATABASE_PATH);
    var theDatabase = openDatabase(path,version: 1 ,onCreate: _onCreate);
    return theDatabase;
  }

  void _onCreate(Database database,int version) async{
    await database.execute('CREATE TABLE $TABLE_NAME($ID_ROW INTEGER, $NAME_ROW TEXT, $NUMBER_ROW TEXT, $TIME_ROW TEXT)');
  }

    Future<int> saveCall(DataBaseModel call) async {
    var dbClient = await db;
    int res = await dbClient.insert(TABLE_NAME, call.toMap());
    return res;
  }

  Future<List<DataBaseModel>> getCalls() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM $TABLE_NAME');
    List<DataBaseModel> calls = new List();
    for (int i = 0; i < list.length; i++) {
      var call = new DataBaseModel(list[i][ID_ROW],list[i][NAME_ROW], list[i][NUMBER_ROW], list[i][TIME_ROW]);
      calls.insert(0,call);
    }
    return calls;
  }

  Future<int> deleteCall(DataBaseModel call) async {
    var dbClient = await db;
    int res = await dbClient.rawDelete('DELETE FROM $TABLE_NAME WHERE $ID_ROW = ?', [call.id]);
    return res;
  }

  Future<bool> updateCall(DataBaseModel call) async {
    var dbClient = await db;
    int res = await dbClient.update(TABLE_NAME, call.toMap(),
        where: "$ID_ROW = ?", whereArgs: <int>[call.id]);
    return res > 0 ? true : false;
  }


  Future<bool> dataBaseState() async {
    //_database = null;
    var dbClient = await db;
    return dbClient.isOpen ?? false;
  }
}