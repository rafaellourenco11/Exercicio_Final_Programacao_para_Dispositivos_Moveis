
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/filme.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static const _databaseName = "FilmesDB.db";
  static const _databaseVersion = 1;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }


  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $tableFilmes (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnUrlImagem TEXT NOT NULL,
            $columnTitulo TEXT NOT NULL,
            $columnGenero TEXT NOT NULL,
            $columnFaixaEtaria TEXT NOT NULL,
            $columnDuracao TEXT NOT NULL,
            $columnPontuacao REAL NOT NULL,
            $columnDescricao TEXT NOT NULL,
            $columnAno TEXT NOT NULL
          )
          ''');
  }

  Future<int> insert(Filme filme) async {
    Database db = await database;
    return await db.insert(tableFilmes, filme.toMap());
  }

  Future<List<Filme>> getFilmes() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(tableFilmes);
    return List.generate(maps.length, (i) {
      return Filme.fromMap(maps[i]);
    });
  }


  Future<int> update(Filme filme) async {
    Database db = await database;
    return await db.update(
      tableFilmes,
      filme.toMap(),
      where: '$columnId = ?',
      whereArgs: [filme.id],
    );
  }


  Future<int> delete(int id) async {
    Database db = await database;
    return await db.delete(
      tableFilmes,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }
}