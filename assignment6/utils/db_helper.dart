import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static const String _databaseName = 'news.db';
  static const int _databaseVersion = 3;

  DBHelper._();

  static final DBHelper _singleton = DBHelper._();

  factory DBHelper() => _singleton;

  Database? _database;

  get db async {
    _database ??= await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    var dbDir = await getApplicationDocumentsDirectory();

    var dbPath = path.join(dbDir.path, _databaseName);

    print(dbPath);

    //await deleteDatabase(dbPath);

    var db = await openDatabase(dbPath, version: _databaseVersion,
        onCreate: (Database db, int version) async {
    
      await db.execute('''
          CREATE TABLE FavoriteOrSearchedNews(
            FavoriteOrSearchedNewsId INTEGER PRIMARY KEY,
            SourceId TEXT,
            SourceName TEXT,
            Author TEXT,
            Title TEXT,
            Description TEXT,
            NewsCategory TEXT
          )
        ''');
    });

    return db;
  }

  

  Future<List<Map<String, dynamic>>> query(String table,{String? where}) async {
    final db = await this.db;
    return where == null ? db.query(table) : db.query(table, where: where);
  }

  Future<int> insert(String table, Map<String, dynamic> data) async {
    final db = await this.db;
    int id = await db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<void> delete(String table, int id, String tableIDName) async {
    final db = await this.db;
    await db.delete(
      table,
      where: '$tableIDName = ?',
      whereArgs: [id],
    );
  }
}