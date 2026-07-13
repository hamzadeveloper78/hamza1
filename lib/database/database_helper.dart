import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/student.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'Students.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      '''
      CREATE TABLE Students(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        idType TEXT NOT NULL,
        idNumber TEXT NOT NULL,
        governorate TEXT,
        district TEXT,
        village TEXT,
        isolation TEXT,
        specialization TEXT,
        level TEXT,
        phone TEXT
      )
      '''
    );
    await db.execute('CREATE INDEX idx_name ON Students(name)');
    await db.execute('CREATE INDEX idx_idnumber ON Students(idNumber)');
  }

  Future<int> insertStudent(Student student) async {
    Database db = await database;
    return await db.insert('Students', student.toMap());
  }

  Future<List<Student>> getStudents() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('Students');
    return List.generate(maps.length, (i) {
      return Student.fromMap(maps[i]);
    });
  }

  Future<List<Student>> searchStudents(String query) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'Students',
      where: 'name LIKE ? OR idNumber LIKE ?',
      whereArgs: ['%\$query%', '%\$query%'],
    );
    return List.generate(maps.length, (i) {
      return Student.fromMap(maps[i]);
    });
  }

  Future<int> updateStudent(Student student) async {
    Database db = await database;
    return await db.update(
      'Students',
      student.toMap(),
      where: 'id = ?',
      whereArgs: [student.id],
    );
  }

  Future<int> deleteStudent(int id) async {
    Database db = await database;
    return await db.delete(
      'Students',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<String> getDatabasePath() async {
    return join(await getDatabasesPath(), 'Students.db');
  }

  Future<void> close() async {
    Database db = await database;
    db.close();
  }
}
