import 'dart:io'; //mine

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/models/task_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database _db;

  DatabaseHelper._instance();

  String taskTable = 'task_tables';
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colDate = 'date';
  String colPriority = 'priority';
  String colStatus = 'status';
  String colnotifyMe = 'notifyMe';
  String colalarm = 'alarm';

  //Task Tables
  //Task  | Title | Description | Date  | Priority  | Status  | notifyMe (noitification)  | Alarm
  //0     | T     | Des         | D     | P         |0        | 1 or 0                    | 1 or 0
  //1     | T     | Des         | D     | P         |1
  //2     | T     | Des         | D     | P         |1

  Future<Database> get db async {
    if (_db == null) {
      _db = await _initDb();
    }
    return _db;
  }

  Future<Database> _initDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + 'todo_list.db';
    final todoListDb =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return todoListDb;
  }

  void _createDb(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $taskTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, $colDescription TEXT, $colDate TEXT, $colPriority TEXT, $colStatus INTEGER, $colnotifyMe BOOL, $colalarm BOOL)');
  }

  Future<List<Map<String, dynamic>>> getTaskMapList() async {
    Database db = await this.db;
    final List<Map<String, dynamic>> result = await db.query(taskTable);
    return result;
  }

  Future<List<Task>> getTaskList() async {
    final List<Map<String, dynamic>> taskMapList = await getTaskMapList();
    final List<Task> taskList = [];
    taskMapList.forEach((taskMap) {
      taskList.add(Task.fromMap(taskMap));
    });
    taskList.sort((taskA, taskB) => taskA.date.compareTo(taskB.date));
    return taskList;
  }

  Future<int> insertTask(Task task) async {
    Database db = await this.db;
    final int result = await db.insert(taskTable, task.toMap());
    return result;
  }

  Future<int> updateTask(Task task) async {
    Database db = await this.db;
    final int result = await db.update(taskTable, task.toMap(),
        where: '$colId = ?', whereArgs: [task.id]);
    return result;
  }

  Future<int> deleteTask(int id) async {
    Database db = await this.db;
    final int result =
        await db.delete(taskTable, where: '$colId = ?', whereArgs: [id]);
    return result;
  }
}
