import 'dart:ui';

import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:dynamic_theme/theme_switcher_widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:TakeNote/models/todo.dart';
import 'package:TakeNote/db/db_helper.dart';
import 'package:TakeNote/utils/colors.dart';
import 'package:TakeNote/utils/navigation.dart';
import 'package:TakeNote/utils/preferences.dart';
import 'package:TakeNote/views/add_task.dart';
import 'package:TakeNote/widgets/task.dart';


class AllTasks extends StatefulWidget {
  const AllTasks({
    Key key,
  }) : super(key: key);

  @override
  _AllTasksState createState() => _AllTasksState();
}

class _AllTasksState extends State<AllTasks> {
  final DBHelper _databaseHelper = DBHelper();
  List<TodoTask> _tasksList;
  int _count = 0;

  bool isChecked;
  DateTime dateTime;
  final CalendarController _calendarController = CalendarController();

  String dayName = '';
  String fetchedDate = '';


  final List<String> _days = <String>[
    '1', '2', '3', '4', '5', '6', '7'
  ];


  final List<String> _daysOfTheWeek = <String>[
    'Monday', 
    'Tuesday', 
    'Wednesday', 
    'Thursday', 
    'Friday'
  ];

  final List<String> _months = <String>[
    'January', 'February', 
    'March', 'April', 
    'May', 'June', 
    'July', 'August', 
    'September', 'October', 
    'November', 'December'
  ];


  
  
  @override
  void initState() {
    dateTime = DateTime.now();
    dayName = DateFormat('EEEE').format(dateTime);  
    // getDate();
    deleteTasks();
    _syncCurrentDate();
    // formatDate();
    
    super.initState();
  }
  

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_tasksList == null) {
      _tasksList = List<TodoTask>();
      updateListView();
    }
    // updateListView();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(25.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[              
                Text(
                  '$dayName, ${_months[dateTime.month - 1]} ${dateTime.day}', 
                  style: TextStyle(
                    color: XColors.greyTextColor, 
                    fontSize: 16.0
                  )
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'TO-DO List',
                      style: TextStyle(
                        // color: XColors.darkTextColor,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold
                      ),
                    ),       
                    IconButton(
                      icon: Icon(Icons.brightness_4),
                      iconSize: 20.0,
                      onPressed: () {
                        showChooser();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20.0,),
                TableCalendar(
                  calendarController: _calendarController,
                  headerVisible: false,
                  initialCalendarFormat: CalendarFormat.twoWeeks,
                  // onDaySelected: (DateTime dateSelected, List<dynamic> onSelectedDay) {},
                ),        
                const SizedBox(height: 10.0),
                const Divider(),
                Builder(
                  builder: (BuildContext context) {
                    updateListView();
                    if(_tasksList == null || _tasksList.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            const SizedBox(height: 20.0),
                            Icon(Icons.add, size: 70.0, color: Colors.grey),
                            const SizedBox(height: 10.0),
                            const Text(
                              'You currently dont have \nany item on your todo list',
                               textAlign: TextAlign.center),
                          ],
                        ),
                      );
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: _count,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          final TodoTask item = _tasksList[index];
                          final TodoTask task = TodoTask(
                            _tasksList[index].title,
                            _tasksList[index].scheduledTime,
                            _tasksList[index].category,
                            _tasksList[index].priority,
                            _tasksList[index].timeToStartAlarm,
                            _tasksList[index].isDone,
                            _tasksList[index].uploadedTime,
                          );
                          
                          return TaskItem(
                            key: Key(item.scheduledTime),
                            title: _tasksList[index].title,
                            isTaskDone: _tasksList[index].isDone == 0 ? false : true,
                            priorityColor: _tasksList[index].priority == 0 ? Colors.red : Colors.blue,
                            isChecked: item.isDone  == 0 
                                ? false : true,
                            onChanged: (bool value) {
                              if(item.isDone == 0) {
                                showRemoveDialog(context, item);
                              }
                              task.isDone = value == true ? 1 : 0;
                              task.id = _tasksList[index].id;
                              _databaseHelper.updateTask(task);
                              updateListView();
                            },
                            onPressed: () => showDetails(item),
                            onDeleteTapped: () {
                              _delete(context, _tasksList[index]);
                              print(_tasksList[index].title);
                            },
                          );
                        },
                      ); 
                    }
                  },
                )                   
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            push(context, const AddTask()); 
          },
          child: Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),  
    );  
  }

  Future<void> _syncCurrentDate() async {
    await setPreference('CURRENT_DATE', DateTime.now().toString());
  }
  
  Future<void> deleteTasks() async {
    final String _stringDate = await getPreference('CURRENT_DATE');
    final DateTime date = DateFormat('yyyy-M-d').parse(_stringDate);

    final String pastDateMonth = date.year.toString() + date.month.toString() + date.day.toString();
    final String currentDateMonth = dateTime.year.toString() + dateTime.month.toString() + dateTime.day.toString();
    
    if(pastDateMonth != currentDateMonth) {
      await _databaseHelper.deleteAllTask();
      updateListView();
    } else {
      if(_tasksList == null) {
      _tasksList = <TodoTask>[];
      updateListView();
    }
    }
  }

  void showRemoveDialog(BuildContext context, TodoTask todo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text('Remove from todo-list?'),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                _databaseHelper.deleteTask(todo.id);
                updateListView();
                Navigator.pop(context);
              },
              child: const Text('YES'),
            ),
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('NO'),
            ),
          ],
        );
      }
    );
  }

  void showDetails(TodoTask todo) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0)
        )
      ), 
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildListTile(
                  'Task', todo.title, Icon(Icons.event)
                ),
                const SizedBox(height: 20.0),
                _buildListTile(
                  'Scheduled time', todo.scheduledTime, Icon(Icons.timer)
                ),
                const SizedBox(height: 20.0),
                _buildListTile(
                  'Priority', todo.priority == 0
                      ? 'HIGH'
                      : 'LOW', 
                    Container(
                      width: 10.0,
                      height: 10.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: todo.priority == 0
                          ? Colors.red
                          : Colors.blue
                      ),
                    ),
                    todo.priority == 0 
                      ? Colors.red
                      : Colors.blue
                ),
                const SizedBox(height: 20.0),
                _buildListTile(
                  'Category', todo.category, Icon(Icons.category)
                ),
                // const SizedBox(height: 20.0),
                // _buildListTile(
                //   'To notify', '${todo.timeToStartAlarm} minutes before', Icon(Icons.timelapse)
                // ),
                const SizedBox(height: 20.0),
                _buildListTile(
                  'Status', todo.isDone == 0
                      ? 'Not done'
                      : 'Done', Icon(Icons.event)
                ),
                const SizedBox(height: 20.0),

              ],
            ),
          ),
        );
      }
    );
  }

  void changeColor() {
    DynamicTheme.of(context).setThemeData(ThemeData(
      brightness: Brightness.dark,
      primaryColor: Theme.of(context).primaryColor == Colors.blue
          ? Colors.black26
          : Colors.blue));
  }

  void showChooser() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return BrightnessSwitcherDialog(
          onSelectedTheme: (Brightness brightness) {
            DynamicTheme.of(context).setBrightness(brightness);
            Navigator.pop(context);
          },
        );
    });
  }

  Widget _buildListTile(String title, String subtitle, Widget icon, [Color color]) {
    return ListTile(
       leading: icon,
       title: Text(
          title, style: const TextStyle(fontSize: 18.0),
       ),
       subtitle: Text(subtitle, style: TextStyle(fontSize: 20.0, color: color))
    );
  }

  Future<void> _delete(BuildContext context, TodoTask task) async {
    final int result = await _databaseHelper.deleteTask(task.id);
    if (result != 0) {
      // _showSnackbar(context, 'Note deleted');
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = _databaseHelper.initializeDatabase();
    dbFuture.then((Database database) {
      final Future<List<TodoTask>> taskListFuture = _databaseHelper.getTaskList();
      taskListFuture.then((List<TodoTask> taskList) {
        setState(() {
          this._tasksList = taskList;
          this._count = taskList.length;
        });
      });
    });
  }
}