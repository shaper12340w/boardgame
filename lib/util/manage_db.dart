import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ManageDB {
  final String path = "./";
  final String name = "data.db";

  Future<Database> init() async {
    final Future<Database> database = openDatabase(
      join(path, name),
      onCreate: (db, version) {
        return db.execute(
            "CREATE TABLE IF NOT EXISTS game(id INTEGER PRIMARY KEY, name TEXT)");
      },
      version: 1,
    );

    return database; // init 메서드 내에서 Future<Database>를 반환
  }
}
