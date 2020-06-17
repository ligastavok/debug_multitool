import 'dart:async';
import 'dart:io';

import 'package:debug_desktop_client/services/service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'logger_service.dart';

class DbService implements Service {
  DbService({
    @required this.dbName,
    @required this.schemaInitPath,
    @required this.loggerService,
  });

  final String schemaInitPath;
  final String dbName;
  final LoggerService loggerService;

  Database _database;
  Database get database => _database;

  @override
  Future<void> init() async {
    _database = await open();
  }

  Future<void> close() async {
    loggerService.d('DATABASE. close');
    if (_database != null) {
      await _database.close();
    }
  }

  Future<Database> open() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final String path = join(documentsDirectory.path, dbName);

    loggerService..d('db.open.path = $path')..d('DATABASE. open');

    try {
      final Database db = await openDatabase(
        path,
        version: 2,
        onCreate: _onCreate,
        onOpen: _onOpen,
        onUpgrade: _onUpgrade,
        onConfigure: _onConfigure,
        onDowngrade: _onDowngrade,
      );

      loggerService.d('db.open.isOpen = ${db.isOpen}');

      return db;
    } catch (exc) {
      loggerService.d('create db exception: $exc');
    }

    return null;
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    loggerService.d('DATABASE. onUpgrade. newV: $newVersion, oldV: $oldVersion');

    if (newVersion > oldVersion) {
      //schema tune
      await db.execute(
        '''
        drop index profile_uk_is_current;
        ''',
      );
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    loggerService.d('DATABASE.onCreate.schemaInitPath = $schemaInitPath');

    final String schema = await rootBundle.loadString(schemaInitPath);

    schema.split(';').forEach((String p) async {
      final String sql = p + ';';
      await db.execute(sql);
    });
  }

  Future<void> _onOpen(Database db) async {
    loggerService.d('DATABASE. onOpen');
  }

  Future<void> _onDowngrade(Database db, int oldVersion, int newVersion) async {
    loggerService.d('DATABASE. onDowngrade');
  }

  Future<void> _onConfigure(Database db) async {
    loggerService.d('DATABASE. onConfigure');
  }
}