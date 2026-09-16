import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class DatabaseService {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    databaseFactory = databaseFactoryFfiWeb;

    return await openDatabase(
      'estoque.db',
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE usuarios (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT NOT NULL,
            email TEXT NOT NULL UNIQUE,
            senha TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE produtos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT NOT NULL,
            categoria TEXT NOT NULL,
            quantidade INTEGER NOT NULL,
            preco REAL NOT NULL
          )
        ''');
      },
    );
  }

  static Future<void> mostrarProdutosNoTerminal() async {
    final db = await database;
    final produtos = await db.query('produtos');

    print('===== PRODUTOS NO BANCO =====');

    for (final produto in produtos) {
      print(produto);
    }
  }
}