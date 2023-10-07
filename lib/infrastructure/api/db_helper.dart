import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

const _dbFile = 'vocabulary_note.db';
const _dbVersion = 1;

const String dbMeals = 'meals';
const String dbId = 'id';
const String dbLabelIndex = 'label_index';
const String dbDate = 'date';
const String dbLabelRating = 'label_rating';
const String dbHealthRating = 'health_rating';

class DbHelper {
  Database? _db;
  Transaction? _txn;

  Future<String> getDbPath() async {
    var dbFilePath = '';

    if (Platform.isIOS) {
      // iOSであれば「getLibraryDirectory」を利用
      final dbDirectory = await getLibraryDirectory();
      dbFilePath = dbDirectory.path;
    } else {
      // iOS以外であれば「getDatabasesPath」を利用
      dbFilePath = await getDatabasesPath();
    }
    // 配置場所のパスを作成して返却
    final path = join(dbFilePath, _dbFile);
    return path;
  }

  Future<Database?> open() async {
    final path = await getDbPath();

    _db = await openDatabase(
      path,
      version: _dbVersion,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE $dbMeals (
            $dbId INTEGER PRIMARY KEY AUTOINCREMENT,
            $dbLabelIndex INTEGER NOT NULL,
            $dbDate DATE NOT NULL,
            $dbLabelRating INTEGER NOT NULL,
            $dbHealthRating INTEGER NOT NULL
          )
        ''');
      },
    );
    await debugDb();
    return _db;
  }

  Future<void> debugDb() async {
    List<Map<String, Object?>>? books = await _db?.query(dbMeals);
    debugPrint('$books');
  }

  Future<void> dispose() async {
    await _db?.close();
    _db = null;
  }

  Future<T?> transaction<T>(Future<T> Function() f) async {
    return _db?.transaction<T>((txn) async {
      _txn = txn;
      return await f();
    }).then((v) {
      _txn = null;
      return v;
    });
  }

  Future<List<Map<String, dynamic>>?> rawQuery(
    String sql, [
    List<dynamic>? arguments,
  ]) async {
    return await (_txn ?? _db)?.rawQuery(sql, arguments);
  }

  Future<int?> rawInsert(
    String sql, [
    List<dynamic>? arguments,
  ]) async {
    return await (_txn ?? _db)?.rawInsert(sql, arguments);
  }
}
