import 'package:financas/model/monthly%20epenses/monthly_expenses_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqliteDataBase {
  static final SqliteDataBase instance = SqliteDataBase._init();
  static Database? _database;

  SqliteDataBase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('expenses.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'TEXT PRIMARY KEY';
    const textType = 'TEXT NOT NULL';
    const doubleType = 'REAL NOT NULL';
    const intType = 'INTEGER NOT NULL';

    await db.execute('''
    CREATE TABLE monthlyExpenses (
      id $idType,
      title $textType,
      amount $doubleType,
      dueDate $intType
    )
    ''');
  }

  Future<int> createExpense(MonthlyExpenses expense) async {
    final db = await instance.database;
    return await db.insert('monthlyExpenses', expense.toMap());
  }

  Future<MonthlyExpenses?> getExpense(String id) async {
    final db = await instance.database;
    final maps = await db.query(
      'monthlyExpenses',
      columns: ['id', 'title', 'amount', 'dueDate'],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return MonthlyExpenses.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<List<MonthlyExpenses>> getAllExpenses() async {
    final db = await instance.database;
    final result = await db.query('monthlyExpenses');
    return result.map((json) => MonthlyExpenses.fromMap(json)).toList();
  }

  Future<int> updateExpense(MonthlyExpenses expense) async {
    final db = await instance.database;
    return db.update(
      'monthlyExpenses',
      expense.toMap(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }

  Future<int> deleteExpense(String id) async {
    final db = await instance.database;
    return await db.delete(
      'monthlyExpenses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
