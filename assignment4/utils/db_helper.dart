import '../models/deckmodel.dart';
import '../models/cardset.dart';
import '../models/cardmodel.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static const String _databaseName = 'cards.db';
  static const int _databaseVersion = 1;

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

    //print(dbPath);

    //await deleteDatabase(dbPath);

    var db = await openDatabase(dbPath, version: _databaseVersion,
        onCreate: (Database db, int version) async {
      await db.execute('''
          CREATE TABLE decks(
            deck_id INTEGER PRIMARY KEY,
            title TEXT
          )
        ''');

      await db.execute('''
          CREATE TABLE cards(
            card_id INTEGER PRIMARY KEY,
            question TEXT,
            answer TEXT,
            deck_id INTEGER,
            FOREIGN KEY (deck_id) REFERENCES decks(deck_id)
          )
        ''');
    });

    return db;
  }

  Future<List<Map<String, dynamic>>> query(String table, {String? where}) async {
    final db = await this.db;
    return where == null ? db.query(table) 
                         : db.query(table, where: where);
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

  Future<void> update(String table, Map<String, dynamic> data, String idName) async {
    final db = await this.db;
    await db.update(
      table,
      data,
      where: '$idName = ?',
      whereArgs: [data[idName]],
    );
  }

  Future<void> delete(String table, int id, String idName) async {
    final db = await this.db;
    await db.delete(
      table,
      where: '$idName = ?',
      whereArgs: [id],
    );
  }

  Future<void> batchInsert(String table, Map<String, dynamic> data) async {
    final db = await this.db;
    Batch batch = db.batch;
    batch.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }


// Make data models from json data and insert the model details into db

  Future<void> jsonModelDB(List decksCards, String decksTable, String cardsTable) async {

    final db = await this.db;

    for (var deck in decksCards) {

      DeckModel deckModel = DeckModel.fromJson(deck);
      Map<String, dynamic> title = {'title': deckModel.title};

      int deckId = await db.insert(
        decksTable,
        title,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      CardSet? flash = deckModel.cardSet;
      
      List<FlashCardModel> cards = flash!.getList();

      for (var card in cards) {
        Map<String, dynamic> flashCardData = {
          'question': card.question,
          'answer': card.answer,
          'deck_id': deckId
        };
        await db.insert(
          cardsTable,
          flashCardData,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    }
  }

// using raw query below so that we get the count also in data for display

  Future<List<Map<String, dynamic>>> queryDecks() async {
    final db = await this.db;
    return await db.rawQuery(
        'select d.deck_id,title,count(c.deck_id) as cards_count from decks d left join cards c on d.deck_id=c.deck_id group by d.deck_id,title order by d.deck_id');
  }

// This function deletes the deck as well as its cards

  Future<void> deleteDeck(String decksTable, String cardsTable, int deckID, String idName) async {
    
    final db = await this.db;
    
    await db.delete(
      decksTable,
      where: '$idName = ?',
      whereArgs: [deckID],
    );

    await db.delete(
      cardsTable,
      where: '$idName = ?',
      whereArgs: [deckID],
    );
  }
}