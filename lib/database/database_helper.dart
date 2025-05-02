import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../models/reminder.dart';

class DatabaseHelper {
  static const _databaseName = 'reminders.db';
  static const _databaseVersion = 2;
  static const table = 'reminders';

  static const columnId = 'id';
  static const columnName = 'name';
  static const columnMobile = 'mobile';
  static const columnLocation = 'location';
  static const columnDob = 'dob';
  static const columnAnniversary = 'anniversary';
  static const columnHowWeMet = 'howWeMet';
  static const columnComment = 'comment';
  static const columnCallTime = 'callTime';

  static Database? _database;
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $columnId TEXT PRIMARY KEY,
        $columnName TEXT NOT NULL,
        $columnMobile TEXT,
        $columnLocation TEXT,
        $columnDob TEXT,
        $columnAnniversary TEXT,
        $columnHowWeMet TEXT,
        $columnComment TEXT,
        $columnCallTime TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertReminder(Reminder reminder) async {
    final db = await instance.database;
    return await db.insert(table, reminder.toMap());
  }

  Future<List<Reminder>> getAllReminders() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      table,
      orderBy: 'callTime DESC',
    );
    return List.generate(maps.length, (i) => Reminder.fromMap(maps[i]));
  }

  Future<Reminder> getReminderById(String id) async {
    final db = await instance.database;
    final maps = await db.query(
      'reminders',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return Reminder.fromMap(maps.first);
  }

  Future<int> updateReminder(Reminder reminder) async {
    final db = await instance.database;
    return await db.update(
      table,
      reminder.toMap(),
      where: '$columnId = ?',
      whereArgs: [reminder.id],
    );
  }

  Future<int> deleteReminder(String id) async {
    final db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
}
