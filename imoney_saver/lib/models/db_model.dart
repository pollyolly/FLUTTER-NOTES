// import 'package:imoney_ssaver_arguments.dart';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import './money_saver_model.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

//https://github.com/tekartik/sqflite/blob/master/sqflite_common_ffi/doc/encryption_support.md

class DatabaseConnect {
  Database? _database; //_database variable is a nullable (can be null)

  Future<Database> get database async {
    const dbname = 'money_savers.db';
    if (Platform.isWindows || Platform.isLinux) {
      sqfliteFfiInit();
      var databaseFactory = databaseFactoryFfi;
      _database = await databaseFactory.openDatabase(
          Directory.current.path + dbname,
          options: OpenDatabaseOptions(version: 1, onCreate: _createDB));
    } else {
      final dbpath =
          await getDatabasesPath(); //location of db in device i.e. data/data //WidgetsFlutterBinding.ensureInitialized(); requirement
      //db name
      final path =
          join(dbpath, dbname); //joining path i.e. data/data/money_saver.db

      _database = await openDatabase(path,
          version: 1, onCreate: _createDB); //open db connection
    }

    return _database!; //! _database is nullable but we are sure that the returned value is not null
  }

//create our database
  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE money_saver(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        remarks TEXT, 
        money REAL,
        category TEXT, 
        creationDate  TEXT,
        isChecked INTEGER
      );
    ''');
  }

  Future<MoneySaverModel> insertData(MoneySaverModel data) async {
    final db = await database; //get connection to database
    data.id = await db.insert(
        'money_saver', data.toMap(), //toMap function in money_saver_model
        conflictAlgorithm: ConflictAlgorithm.replace);
    return data;
  }

  Future<MoneySaverModel> updateData(MoneySaverModel data) async {
    final db = await database; //get connection to database
    data.id = await db.update('money_saver', data.toMap(),
        where: 'id==?', whereArgs: [data.id]);
    return data;
  }

  Future<void> deleteAlldata() async {
    final db = await database;
    await db.delete('money_saver');
  }

  Future<MoneySaverModel> deleteData(MoneySaverModel data) async {
    final db = await database;
    data.id =
        await db.delete('money_saver', where: 'id==?', whereArgs: [data.id]);
    return data;
  }

  Future<List<MoneySaverModel>> getSelectedData(String dateStr) async {
    final db = await database;
    // List<Map<String, dynamic>> items = await db.rawQuery(
    //     'SELECT * FROM money_saver WHERE strftime("%m-%Y", creationDate) = ? ORDER BY creationDate DESC',
    //     [dateStr]);
    List<Map<String, dynamic>> items = await db.query('money_saver',
        where: 'strftime("%m-%Y", creationDate) = ?',
        orderBy: 'creationDate DESC',
        whereArgs: [dateStr]);
    return List.generate(
        items.length,
        (i) => MoneySaverModel(
            id: items[i]['id'],
            remarks: items[i]['remarks'],
            money: items[i]['money'],
            category: items[i]['category'],
            creationDate: DateTime.parse(items[i][
                'creationDate']), //text format from model convert to datetime format for display
            isChecked: items[i]['isChecked'] == 1 ? true : false));
  }

  Future<List<MoneySaverModel>> getData() async {
    final db = await database;
    String currentDate =
        DateFormat('MM-yyyy').format(DateTime.now()).toString();
    List<Map<String, dynamic>> items = await db.query('money_saver',
        where: 'strftime("%m-%Y", creationDate) = ?',
        orderBy: 'creationDate DESC',
        whereArgs: [currentDate]);

    return List.generate(
        items.length,
        (i) => MoneySaverModel(
            id: items[i]['id'],
            remarks: items[i]['remarks'],
            money: items[i]['money'],
            category: items[i]['category'],
            creationDate: DateTime.parse(items[i][
                'creationDate']), //text format from model convert to datetime format for display
            isChecked: items[i]['isChecked'] == 1 ? true : false));
  }
}
