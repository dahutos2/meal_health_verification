import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

const _dbFile = 'vocabulary_note.db';
const _dbVersion = 1;

final dbHelperProvider = Provider<DbHelper>(
  (_) => DbHelper(),
);

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
          CREATE TABLE meals (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            date DATE NOT NULL,
            label_rating INTEGER NOT NULL,
            health_rating INTEGER NOT NULL
          )
        ''');
      },
    );
    await debugDb();
    return _db;
  }

  Future<void> debugDb() async {
    List<Map<String, Object?>>? books = await _db?.query('meals');
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
