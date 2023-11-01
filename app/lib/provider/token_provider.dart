import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;

class TokenNotfier extends Notifier<String> {
  @override
  build() {
    return "";
  }

  set(String token) {
    state = token;
  }

  get() {
    return state;
  }

  clear() {
    state = "";
  }

  Future<Database> _getDatabase() async {
    final dbPath = await sql.getDatabasesPath();
    final db = await sql.openDatabase(
      path.join(dbPath, 'spendwise.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE user(token TEXT)',
        );
      },
      version: 1,
    );

    return db;
  }

  Future saveToken() async {
    final db = await _getDatabase();

    await db.insert(
      'user',
      {
        'token': state,
      },
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  Future<bool> loadToken() async {
    final db = await _getDatabase();
    final data = await db.query('user');

    if (data.isEmpty) {
      return false;
    } else {
      state = data.first['token'].toString();
      return true;
    }
  }

  Future deleteToken() async {
    final db = await _getDatabase();
    clear();
    await db.delete('user');
  }
}

final tokenProvider = NotifierProvider<TokenNotfier, String>(() {
  return TokenNotfier();
});
