import 'dart:io';
import 'package:meta/meta.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart';
import 'package:estimationer/core/constant/constants.dart';
import 'package:estimationer/core/error/exceptions.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

abstract class DataBaseManager{
  Future<List<Map<String, dynamic>>> queryAll(String tableName);
  Future<Map<String, dynamic>> querySingleOne(String tableName, int id);
  Future<List<Map<String, dynamic>>> queryWhere(String tableName, String whereStatement, List<dynamic> whereVariables);
  Future<int> insert(String tableName, Map<String, dynamic> data);
  Future<void> update(String tableName, Map<String, dynamic> row, int id);
  Future<void> remove(String tableName, int id);
}

class DataBaseManagerImpl implements DataBaseManager{
  final Database db;

  DataBaseManagerImpl({
    @required this.db
  });

  @override
  Future<List<Map<String, dynamic>>> queryAll(String tableName)async{
    return await _executeOperation(()async =>
      await db.query(tableName)
    ); 
  }

  @override
  Future<Map<String, dynamic>> querySingleOne(String tableName, int id)async{
    return await _executeOperation(()async =>
      (await db.query(tableName, where: '$TASKS_ID = ?', whereArgs: [id]) )[0]
    );
  }

  @override
  Future<List<Map<String, dynamic>>> queryWhere(String tableName, String whereStatement, List whereArgs)async{
    return await _executeOperation(()async =>
      await db.query(tableName, where: whereStatement, whereArgs: whereArgs)
    );
  }

  @override
  Future<int> insert(String tableName, Map<String, dynamic> data)async{
    return await _executeOperation(()async =>
      await db.insert(tableName, data)
    );
  }

  @override
  Future<void> update(String tableName, Map<String, dynamic> row, int id)async{
    await _executeOperation(()async =>
      await db.update(tableName, row, where: '$TASKS_ID = ?', whereArgs: [id])
    );
  }

  @override
  Future<void> remove(String tableName, int id)async{
    await _executeOperation(()async =>
      await db.delete(tableName, where: '$TASKS_ID = ?', whereArgs: [id])
    );
  }

  Future<dynamic> _executeOperation(Function function)async{
    try{
      return await function();
    }on PlatformException{
      throw DBException(type: DBExceptionType.PLATFORM);
    }
  }
}

class CustomDataBaseFactory{
  static const String DB_NAME = 'estimationer';
  static const int DB_VERSION = 1;

  static Future<Database> get dataBase async => await initDataBase();

  static Future<Database> initDataBase()async{
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, DB_NAME);
    //await deleteDatabase(path);
    return await openDatabase(path, version: DB_VERSION, onCreate: _onCreate);
  }

  static Future _onCreate(Database db, int version)async{
    db.execute(
      '''
        CREATE TABLE $TASKS_TABLE_NAME (
        $TASKS_ID INTEGER PRIMARY KEY,
        $TASKS_NAME TEXT NOT NULL, 
        $TASKS_PESIMISTIC FLOAT NOT NULL,
        $TASKS_OPTIMISTIC FLOAT NOT NULL,
        $TASKS_NORMAL FLOAT NOT NULL,
        $TASKS_ESTIMATE FLOAT NOT NULL,
        $TASKS_UNCERTAINTY FLOAT NOT NULL
        )
      '''
    );
    db.execute('''
      CREATE TABLE $TASK_GROUPS_TABLE_NAME (
        $TASK_GROUPS_ID INTEGER PRIMARY KEY,
        $TASK_GROUPS_NAME TEXT NOT NULL,
        $TASK_GROUPS_TOTAL_ESTIMATE FLOAT,
        $TASK_GROUPS_TOTAL_UNCERTAINTY FLOAT,
        $TASK_GROUPS_INITIAL_DATE TEXT NOT NULL,
        $TASK_GROUPS_FINAL_DATE TEXT
      )
    ''');
  }
}