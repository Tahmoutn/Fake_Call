import 'package:fake_call/constants.dart';
import 'package:fake_call/model/HistoriesDatabaseModel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path/path.dart';

class HistoryDatabase {
  static final HistoryDatabase _helper = new HistoryDatabase.internal();

  factory HistoryDatabase() => _helper;

  static Database _database;

  Future<Database> get db async{
    if(_database != null){
      return _database;
    }
    _database = await initDatabase();
    return _database;
  }

  HistoryDatabase.internal();

  initDatabase() async{
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, HISTORIES_DATABASE_PATH);
    var theDatabase = openDatabase(path,version: 1,onCreate: _onCreate);
    return theDatabase;
  }

  void _onCreate(Database database,int version) async{
    await database.execute('CREATE TABLE $HISTORIES_TABLE_NAME(id INTEGER PRIMARY KEY,$HISTORIES_NAME_ROW TEXT, $HISTORIES_NUMBER_ROW TEXT, $HISTORIES_TIME_ROW TEXT)');
  }

  Future<int> saveCall(HistoriesDataBaseModel call) async {
    var dbClient = await db;
    int res = await dbClient.insert(HISTORIES_TABLE_NAME , call.toMap());
    return res;
  }

  Future<List<HistoriesDataBaseModel>> getCalls() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM $HISTORIES_TABLE_NAME');
    List<HistoriesDataBaseModel> calls = new List();
    for (int i = 0; i < list.length; i++) {
      var call = new HistoriesDataBaseModel(list[i][HISTORIES_NAME_ROW], list[i][HISTORIES_NUMBER_ROW], list[i][HISTORIES_TIME_ROW]);
      call.setCallId(list[i]["id"]);
      calls.insert(0,call);
    }
    return calls;
  }

  Future<int> deleteCall(HistoriesDataBaseModel call) async {
    var dbClient = await db;
    int res = await dbClient.rawDelete('DELETE FROM $HISTORIES_TABLE_NAME WHERE id = ?', [call.id]);
    return res;
  }

  Future<bool> updateCall(HistoriesDataBaseModel call) async {
    var dbClient = await db;
    int res = await dbClient.update(HISTORIES_TABLE_NAME , call.toMap(),
        where: "id = ?", whereArgs: <int>[call.id]);
    return res > 0 ? true : false;
  }

  Future<bool> deleteAll() async{
    var dbClient = await db;
    dbClient.delete(HISTORIES_TABLE_NAME);
    return true;
  }


  Future<bool> dataBaseState() async {
    //_database = null;
    var dbClient = await db;
    return dbClient.isOpen ?? false;
  }
}