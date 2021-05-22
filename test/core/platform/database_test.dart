import 'package:estimationer/core/constant/constants.dart';
import 'package:estimationer/core/error/exceptions.dart';
import 'package:estimationer/core/platform/database.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite/sqflite.dart';

class MockDatabase extends Mock implements Database{}

DataBaseManagerImpl dbManager;
MockDatabase db;

void main(){
  setUp((){
    db = MockDatabase();
    dbManager = DataBaseManagerImpl(db: db);
  });

  group('queryAll', (){
    String tTableName;
    setUp((){
      tTableName = 'table_name';
    });

    test('should call the db method with the tableName', ()async{
      await dbManager.queryAll(tTableName);
      verify(db.query(tTableName));
    });

    test('should return the db response', ()async{
      List<Map<String, dynamic>> queryResponse = [{'id':1}, {'id':2}];
      when(db.query(any)).thenAnswer((_) async => queryResponse);
      final response = await dbManager.queryAll(tTableName);
      expect(response, queryResponse);
    });

    test('should throw DBException(Platform) when db throws PlatformException', ()async{
      when(db.query(any)).thenThrow(PlatformException(code: 'codeX'));
      try{
        await dbManager.queryAll(tTableName);
        fail('debería lanzar un exception');
      }catch(exception){
        expect(exception.runtimeType, DBException);
        expect((exception as DBException).type, DBExceptionType.PLATFORM);
      }
    });
  });

  group('querySingleOne', (){
    String tTableName;
    int tId;
    Map<String, dynamic> tExpectedResponse;
    setUp((){
      tTableName = 'table_name';
      tId = 1;
      tExpectedResponse = {'id':1};
    });

    test('should call the db method with the specified tableName and id', ()async{
      when(db.query(any, where: anyNamed('where'), whereArgs: anyNamed('whereArgs'))).thenAnswer((_) async => [tExpectedResponse]);
      await dbManager.querySingleOne(tTableName, tId);
      verify(db.query(tTableName, where: '$TASKS_ID = ?', whereArgs: [tId]));
    });

    test('should return the db response', ()async{
      when(db.query(any, where: anyNamed('where'), whereArgs: anyNamed('whereArgs'))).thenAnswer((_) async => [tExpectedResponse]);
      final Map<String, dynamic> response = await dbManager.querySingleOne(tTableName, tId);
      expect(response, tExpectedResponse);
    });

    test('should throw DBException(Platform) when db throws PlatformException', ()async{
      when(db.query(any, where: anyNamed('where'), whereArgs: anyNamed('whereArgs'))).thenThrow(PlatformException(code: 'codeX'));
      try{
        await dbManager.querySingleOne(tTableName, tId);
        fail('debería lanzar un exception');
      }catch(exception){
        expect(exception.runtimeType, DBException);
        expect((exception as DBException).type, DBExceptionType.PLATFORM);
      }
    });
  });

  group('insert', (){
    String tTableName;
    Map<String, dynamic> tInsertedValue;
    setUp((){
      tTableName = 'table_name';
      tInsertedValue = {'id':1};;
    });

    test('should call the db method with the specified tableName and insertedValue', ()async{
      await dbManager.insert(tTableName, tInsertedValue);
      verify(db.insert(tTableName, tInsertedValue));
    });

    test('should return the id value', ()async{
      int tExpectedNewIndex = 1;
      when(db.insert(any, any)).thenAnswer((_) async => tExpectedNewIndex);
      int newIndex = await dbManager.insert(tTableName, tInsertedValue);
      expect(newIndex, tExpectedNewIndex);
    });

    test('should throw DBException(Platform) when db throws PlatformException', ()async{
      when(db.insert(any, any)).thenThrow(PlatformException(code: 'codeX'));
      try{
        await dbManager.insert(tTableName, tInsertedValue);
        fail('debería lanzar un exception');
      }catch(exception){
        expect(exception.runtimeType, DBException);
        expect((exception as DBException).type, DBExceptionType.PLATFORM);
      }
    });
  });

  group('update', (){
    String tTableName;
    int tId;
    Map<String, dynamic> tUpdatedValue;
    setUp((){
      tTableName = 'table_name';
      tId = 1;
      tUpdatedValue = {'id':1, 'name':'el name'};;
    });

    test('should call the db method with the specified tableName and updatedValue', ()async{
      await dbManager.update(tTableName, tUpdatedValue, tId);
      verify(db.update(tTableName, tUpdatedValue, where: '$TASKS_ID = ?', whereArgs: [tId]));
    });

    test('should throw DBException(Platform) when db throws PlatformException', ()async{
      when(db.update(any, any, where: anyNamed('where'), whereArgs: anyNamed('whereArgs'))).thenThrow(PlatformException(code: 'codeX'));
      try{
        await dbManager.update(tTableName, tUpdatedValue, tId);
        fail('debería lanzar un exception');
      }catch(exception){
        expect(exception.runtimeType, DBException);
        expect((exception as DBException).type, DBExceptionType.PLATFORM);
      }
    });
  });

  group('remove', (){
    String tTableName;
    int tId;
    setUp((){
      tTableName = 'table_name';
      tId = 1;
    });

    test('should call thd db method with the specified tableName and id', ()async{
      await dbManager.remove(tTableName, tId);
      verify(db.delete(tTableName, where: '$TASKS_ID = ?', whereArgs: [tId]));
    });

    test('should throw DBException(Platform) when db throws PlatformException', ()async{
      when(db.delete(any, where: anyNamed('where'), whereArgs: anyNamed('whereArgs'))).thenThrow(PlatformException(code: 'codeX'));
      try{
        await dbManager.remove(tTableName, tId);
        fail('debería lanzar un exception');
      }catch(exception){
        expect(exception.runtimeType, DBException);
        expect((exception as DBException).type, DBExceptionType.PLATFORM);
      }
    });
  });
}