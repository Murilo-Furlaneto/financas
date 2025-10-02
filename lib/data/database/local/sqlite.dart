import 'package:financas/domain/model/monthly_expenses/monthly_expenses_model.dart';
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
    return await openDatabase(path,
        version: 2, onCreate: _createDB, onUpgrade: _upgradeDB);
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
    category $textType,
    amount $doubleType,
    dueDate $intType,
    createdAt $intType
  )
''');
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(
          'ALTER TABLE monthlyExpenses ADD COLUMN createdAt INTEGER NOT NULL DEFAULT 0');
    }
  }

  Future<int> createExpense(MonthlyExpenses expense) async {
    final db = await instance.database;
    return await db.insert('monthlyExpenses', expense.toMap());
  }

  Future<MonthlyExpenses?> getExpense(String id) async {
    final db = await instance.database;
    final version = await db.getVersion();
    final maps = await db.query(
      'monthlyExpenses',
      columns: version < 2 ? ['id', 'title', 'category', 'amount', 'dueDate'] : ['id', 'title', 'category', 'amount', 'dueDate', 'createdAt'],
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

  Future<List<MonthlyExpenses>> getAllExpensesByMonth(
      int month, int year) async {
    final db = await instance.database;
    final startDate = DateTime(year, month, 1).millisecondsSinceEpoch;
    final endDate = DateTime(year, month + 1, 1)
        .subtract(const Duration(days: 1))
        .millisecondsSinceEpoch;

    final result = await db.query(
      'monthlyExpenses',
      where: 'createdAt >= ? AND createdAt <= ?',
      whereArgs: [startDate, endDate],
    );

    return result.map((json) => MonthlyExpenses.fromMap(json)).toList();
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

  Future<Map<String, double>> getExpensesGroupedByCategory(int month, int year,
      {String? category}) async {
    final db = await instance.database;
    final startDate = DateTime(year, month, 1).millisecondsSinceEpoch;
    final endDate = DateTime(year, (month + 1).toInt(), 1)
        .subtract(const Duration(days: 1))
        .millisecondsSinceEpoch;

    String whereClause = 'createdAt >= $startDate AND createdAt <= $endDate';
    if (category != null) {
      whereClause += ' AND category = \'$category\'';
    }

    final result = await db.rawQuery('''
      SELECT category, SUM(amount) as total
      FROM monthlyExpenses
      WHERE $whereClause
      GROUP BY category
    ''');

    final Map<String, double> expensesByCategory = {};
    for (var row in result) {
      expensesByCategory[row['category'] as String] = row['total'] as double;
    }
    return expensesByCategory;
  }

  Future<List<MonthlyExpenses>> getExpensesByMonth(int month, int year,
      {String? category}) async {
    final db = await instance.database;
    final startDate = DateTime(year, month, 1).millisecondsSinceEpoch;
    final endDate = DateTime(year, month + 1, 0).millisecondsSinceEpoch;

    String whereClause = 'createdAt >= ? AND createdAt <= ?';
    List<dynamic> whereArgs = [startDate, endDate];

    if (category != null) {
      whereClause += ' AND category = ?';
      whereArgs.add(category);
    }

    final result = await db.query(
      'monthlyExpenses',
      where: whereClause,
      whereArgs: whereArgs,
    );

    return result.map((json) => MonthlyExpenses.fromMap(json)).toList();
  }
}
