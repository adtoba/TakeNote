import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tasker/core/models/task.dart';
import 'package:tasker/core/models/todo.dart';
import 'package:tasker/utils/constants.dart';

class DBHelper {
  factory DBHelper() {
    return _databaseHelper ?? DBHelper._createInstance();
  }

  DBHelper._createInstance();

  static Database _database;
  static DBHelper _databaseHelper;

  // This function is used to get the instance of the database
  Future<Database> get database async {
    return _database ?? await initializeDatabase();
  }

  // This function initializes the database and opens it
  Future<Database> initializeDatabase() async {
    final Directory directory = await getApplicationDocumentsDirectory(); 
    final String path = directory.path + Constants.TODO_DBNAME;

    final Database _taskDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return _taskDatabase;
  }

  // This function creates the database and its variables
  Future<void> _createDb(Database db, int version) async {
    await db.execute('CREATE TABLE ${Constants.TODO_TASK_TABLE}(${Constants.colId} INTEGER PRIMARY KEY AUTOINCREMENT, ${Constants.colTitle} TEXT, '
      '${Constants.colScheduledTime} TEXT, ${Constants.colCategory} TEXT, ${Constants.colPriority} INTEGER, ${Constants.colUploadedTime} TEXT, ${Constants.colStartupTime} TEXT, ${Constants.colIsDone} INTEGER)'
    );
  }

  // This function inserts a new task to the database
  Future<int> insertTask(TodoTask task) async {
    final Database dbClient = await database;
    final Future<int> result = dbClient.insert(Constants.TODO_TASK_TABLE, task.toMap());
    print('${task.title} was added successfully');
    print('${task.scheduledTime} was scheduled');
    return result;
  }

  // This function updates a task in the database with new fields
  Future<int> updateTask(TodoTask task) async {
    final Database dbClient = await database;
    final Future<int> result = dbClient.update(Constants.TODO_TASK_TABLE, task.toMap(), where: '${Constants.colId} = ?', whereArgs: [task.id]);

    return result;
  }

  // This function deletes a task from the database via its ID
  Future<int> deleteTask(int id) async {
    final Database dbClient = await database;
    final Future<int> result = dbClient.rawDelete('DELETE FROM ${Constants.TODO_TASK_TABLE} WHERE ${Constants.colId} = $id');
    print('Task deleted');
    return result;
  }

  // This function gets the total number of tasks in the database
  Future<int> getCount() async {
    final Database dbClient = await database;
    final List<Map<String, dynamic>> X = await dbClient.rawQuery('SELECT COUNT (*) from ${Constants.TODO_TASK_TABLE}');

    return Sqflite.firstIntValue(X);
  }

  // This function gets all the tasks in the database as a map object
  Future<List<Map<String, dynamic>>> getTaskMapList() async {
    final Database dbClient = await database;
    final List<Map<String, dynamic>> taskList = await dbClient.query(Constants.TODO_TASK_TABLE, orderBy: '${Constants.colPriority} ASC');

    return taskList;
  }

  // This function gets all the tasks as a List object from the map object 
  Future<List<TodoTask>> getTaskList() async {
    final List<Map<String, dynamic>> taskMapList = await getTaskMapList();
    final int count = taskMapList.length;
    final List<TodoTask> taskList = <TodoTask>[];

    for(int i = 0; i < count; i++) {
      taskList.add(TodoTask.fromMap(taskMapList[i]));
    }

    return taskList;

  }
}