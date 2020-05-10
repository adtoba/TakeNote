import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tasker/core/models/task.dart';
import 'package:tasker/core/services/database_helper.dart';
import 'package:tasker/utils/colors.dart';
import 'package:tasker/views/create.dart';
import 'package:tasker/widgets/item.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final DatabaseHelper _databaseHelper = DatabaseHelper();

  List<Task> _tasksList;
  int count = 0;

  @override
  void initState() { 

    if(_tasksList == null) {
      _tasksList = <Task>[];
      updateListView();
    }
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double deviceHeight = size.height;
    final double deviceWidth = size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        leading: Icon(Icons.menu),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: const BoxDecoration(
                color: Colors.white
              ),
              child: Text(
                'Daily Task', style: TextStyle(fontSize: 24.0, color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.all(30.0),
              width: deviceWidth,
              height: deviceHeight,
              decoration: BoxDecoration(
                color: XColors.dailyTaskBGColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0)
                )
              ),
              child: ListView.builder(
                itemCount: count,
                itemBuilder: (BuildContext context, int index) {
                  return SingleItem(
                    title: _tasksList[index].title,
                    description: _tasksList[index].description,
                    dateTime: _tasksList[index].dateTime,
                    index: index,
                    priority: _tasksList[index].priority,
                  );
                },
              ),
              
            ),
          )
        ],
      )
    );
  }

  void updateListView() {
    final Future<Database> dbFuture = _databaseHelper.initializeDatabase();
    dbFuture.then((Database database) {
      final Future<List<Task>> taskListFuture = _databaseHelper.getTaskList();
      taskListFuture.then((List<Task> taskList) {
        setState(() {
          _tasksList = taskList;
          count = taskList.length;
        });
      });
    });
  }

  
}