import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../model/student.dart';

class DBProvider {
  // singleton pattern for database
  DBProvider._();
  static final DBProvider db = DBProvider._();

  String studentsTable = 'Students';
  String columnId = 'id';
  String columnName = 'name';

  // object of the database
  static late Database _database;

  // create the object of database
  Future<Database> get database async {
    //if (_database != null) return _database;
    _database = await _initDB();
    return _database;
  }

  Future<Database> _initDB() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + 'Student.db'; // path of the db
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // Our table will be:
  // Student
  // Id | Name
  // 0    ..
  // 1    ..

  void _createDB(Database db, int version) async {
    await db.execute(
      'CREATE TABLE $studentsTable($columnId INTEGER PRIMARY KEY AUTOINCREMENT, $columnName TEXT)',
    );
  }

  // READ method
  Future<List<Student>> getStudents() async {
    Database db = await this.database;
    final List<Map<String, dynamic>> studentsMapList =
        await db.query(studentsTable);
    final List<Student> studentsList = [];
    studentsMapList.forEach((studentMap) {
      studentsList.add(Student.fromMap(studentMap));
    });
    return studentsList;
  }

  // INSERT
  Future<Student> insertStudent(Student student) async {
    Database db = await this.database;
    student.id = await db.insert(studentsTable, student.toMap());
    return student;
  }

  // UPDATE
  Future<int> updateStudent(Student student) async {
    Database db = await this.database;
    return await db.update(
      studentsTable,
      student.toMap(),
      where: '$columnId = ?',
      whereArgs: [student.id],
    );
  }

  // DELETE
  Future<int> deleteStudent(int id) async {
    Database db = await this.database;
    return await db.delete(
      studentsTable,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }
}
