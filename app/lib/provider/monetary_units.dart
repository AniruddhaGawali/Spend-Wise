import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;

class MonetaryUnitNotfier extends Notifier<String> {
  @override
  build() => "";

  set(String unit) => state = unit;

  get() => state;

  clear() => state = "";

  Future<Database> _getDatabase() async {
    final dbPath = await sql.getDatabasesPath();
    final db = await sql.openDatabase(
      path.join(dbPath, 'spendwise.db'),
      version: 1,
    );

    return db;
  }

  Future saveUnit() async {
    final db = await _getDatabase();

    await db.insert(
      'monetary_unit',
      {
        'unit': state,
      },
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  Future<bool> loadUnit() async {
    final db = await _getDatabase();
    db.execute('CREATE TABLE IF NOT EXISTS monetary_unit(unit TEXT)');
    final data = await db.query('monetary_unit');

    if (data.isEmpty) {
      return false;
    } else {
      state = data.first['unit'].toString();
      return true;
    }
  }

  Future deleteUnit() async {
    final db = await _getDatabase();
    await db.delete('monetary_unit');
  }
}

final monetaryUnitProvider = NotifierProvider<MonetaryUnitNotfier, String>(() {
  return MonetaryUnitNotfier();
});
