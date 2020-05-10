import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tasker/core/models/task.dart';
import 'package:tasker/utils/constants.dart';

class DatabaseHelper {
  factory DatabaseHelper() {
    return _databaseHelper ?? DatabaseHelper._createInstance();
  }

  DatabaseHelper._createInstance();

  static Database _database;
  static DatabaseHelper _databaseHelper;

  // This function is used to get the instance of the database
  Future<Database> get database async {
    return _database ?? await initializeDatabase();
  }

  // This function initializes the database and opens it
  Future<Database> initializeDatabase() async {
    final Directory directory = await getApplicationDocumentsDirectory(); 
    final String path = directory.path + Constants.DBNAME;

    final Database _taskDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return _taskDatabase;
  }

  // This function creates the database and its variables
  Future<void> _createDb(Database db, int version) async {
    await db.execute('CREATE TABLE ${Constants.TASK_TABLE}(${Constants.colId} INTEGER PRIMARY KEY AUTOINCREMENT, ${Constants.colTitle} TEXT, '
      '${Constants.colDescription} TEXT, ${Constants.colPriority} INTEGER, ${Constants.colDateTime} TEXT)'
    );
  }

  // This function inserts a new task to the database
  Future<int> insertTask(Task task) async {
    final Database dbClient = await database;
    final Future<int> result = dbClient.insert(Constants.TASK_TABLE, task.toMap());

    return result;
  }

  // This function updates a task in the database with new fields
  Future<int> updateTask(Task task) async {
    final Database dbClient = await database;
    final Future<int> result = dbClient.update(Constants.TASK_TABLE, task.toMap(), where: '${Constants.colId} = ?', whereArgs: [task.id]);

    return result;
  }

  // This function deletes a task from the database via its ID
  Future<int> deleteTask(int id) async {
    final Database dbClient = await database;
    final Future<int> result = dbClient.rawDelete('DELETE FROM ${Constants.TASK_TABLE} WHERE ${Constants.colId} = $id');

    return result;
  }

  // This function gets the total number of tasks in the database
  Future<int> getCount() async {
    final Database dbClient = await database;
    final List<Map<String, dynamic>> X = await dbClient.rawQuery('SELECT COUNT (*) from ${Constants.TASK_TABLE}');

    return Sqflite.firstIntValue(X);
  }

  // This function gets all the tasks in the database as a map object
  Future<List<Map<String, dynamic>>> getTaskMapList() async {
    final Database dbClient = await database;
    final List<Map<String, dynamic>> taskList = await dbClient.query(Constants.TASK_TABLE, orderBy: '${Constants.colPriority} ASC');

    return taskList;
  }

  // This function gets all the tasks as a List object from the map object 
  Future<List<Task>> getTaskList() async {
    final List<Map<String, dynamic>> taskMapList = await getTaskMapList();
    final int count = taskMapList.length;
    final List<Task> taskList = <Task>[];

    for(int i = 0; i < count; i++) {
      taskList.add(Task.fromMap(taskMapList[i]));
    }

    return taskList;

  }
}