import 'package:fake_call/model/ListCallModel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path/path.dart';

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
    String path = join(documentsDirectory.path, "fake_calls.db");
    var theDatabase = openDatabase(path,version: 1 ,onCreate: _onCreate);
    return theDatabase;
  }

  void _onCreate(Database database,int version) async{
    await database.execute('CREATE TABLE calls(id INTEGER PRIMARY KEY,name TEXT, number TEXT,time TEXT)');
  }

    Future<int> saveCall(ListCallModel call) async {
    var dbClient = await db;
    int res = await dbClient.insert("calls", call.toMap());
    return res;
  }

  Future<List<ListCallModel>> getCalls() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM calls');
    List<ListCallModel> calls = new List();
    for (int i = 0; i < list.length; i++) {
      var call = new ListCallModel(list[i]["name"], list[i]["number"], list[i]["time"]);
      call.setCallId(list[i]["id"]);
      calls.insert(0,call);
    }
    return calls;
  }

  Future<int> deleteCall(ListCallModel call) async {
    var dbClient = await db;
    int res = await dbClient.rawDelete('DELETE FROM calls WHERE id = ?', [call.id]);
    return res;
  }

  Future<bool> updateCall(ListCallModel call) async {
    var dbClient = await db;
    int res = await dbClient.update("calls", call.toMap(),
        where: "id = ?", whereArgs: <int>[call.id]);
    return res > 0 ? true : false;
  }


  Future<bool> dataBaseState() async {
    //_database = null;
    var dbClient = await db;
    return dbClient.isOpen ?? false;
  }
}