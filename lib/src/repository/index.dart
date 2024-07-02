import 'package:sqflite/sqflite.dart';
import 'package:cardrepo/src/services/contacts.data.dart';

class Repository {
  bool _isDbBound = false;
  late Database _db;
  static final _instance = Repository._new();

  Repository._new();

  factory Repository() => _instance;

  Future<Database> get db async {
    if (!_isDbBound) {
      final dbDir = getDatabasesPath();
      const dbName = "cardrepo.db";
      final dbPath = '$dbDir/$dbName';

      _db = await openDatabase(
        dbPath,
        version: 1,
        onCreate: _onCreate
      );
      _isDbBound = true;
    }

    return _db;
  }

  Future<void> _onCreate(Database db, int version) async {
    final sqls = [
      """CREATE TABLE CONTACTS (
        id TEXT PRIMARY KEY,
        fn TEXT NOT NULL,
        tel TEXT NOT NULL,
        email TEXT NOT NULL,
        card_url TEXT NOT NULL,
        org TEXT,
        position TEXT,
        ext_link TEXT
      );""",
      for (final e in data)
        """INSERT INTO CONTACTS (
          id,
          fn,
          tel,
          email,
          card_url,
          org,
          position
        ) VALUES (
          '${e["id"]}',
          '${e["fn"]}',
          '${e["tel"]}',
          '${e["email"]}',
          '',
          ${e["org"] == null ? 'NULL' : "'${e["org"]}'"},
          ${e["position"] == null ? 'NULL' : "'${e["position"]}'"}
        );""",
    ];

    await db.transaction((txn) async {
      for (final sql in sqls ) {
        await txn.execute(sql);
      }
    });
  }
}
