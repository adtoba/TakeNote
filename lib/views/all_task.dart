import 'dart:isolate';
import 'dart:math';
import 'dart:ui';

import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tasker/core/models/task.dart';
import 'package:tasker/core/models/todo.dart';
import 'package:tasker/core/services/db_helper.dart';
import 'package:tasker/utils/colors.dart';
import 'package:tasker/utils/navigation.dart';
import 'package:tasker/views/add_task.dart';
import 'package:tasker/widgets/task.dart';


class AllTasks extends StatefulWidget {
  const AllTasks({
    Key key,
    this.port
  }) : super(key: key);

  final ReceivePort port;
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

  var dayName;

  final List<String> _daysList = <String>[
    'S', 'S', 'M', 'T', 'W', 'T', 'F'
  ];

  final List<String> _days = <String>[
    '1', '2', '3', '4', '5', '6', '7'
  ];

  final List<String> _randomTasks = <String>[
    'Daily UI challenge', 'Study', 'Meeting', 'Travel', 'Explore',
    'Daily UI challenge', 'Study', 'Meeting', 'Travel', 'Explore'
  ];

  final List<String> _daysOfTheWeek = <String>[
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'
  ];

  final List<String> _months = <String>[
    'January', 'February', 'March', 'April', 'May', 'June', 'July',
    'August', 'September', 'October', 'November', 'December'
  ];

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

  NotificationAppLaunchDetails notificationAppLaunchDetails;



  int _counter = 0;

  @override
  void initState() {
    if(_tasksList == null) {
      _tasksList = <TodoTask>[];
      updateListView();
    }

    AndroidAlarmManager.initialize();
    
    widget.port.listen((_) async => await _incrementCounter());
    dateTime = DateTime.now();
    dayName = DateFormat('EEEE').format(dateTime);

    
    super.initState();
  }
  static const String isolateName = 'isolate';

  SharedPreferences prefs;


  static SendPort uiSendPort;
  static const String countKey = 'count';

  Future<void> _incrementCounter() async {
    print('Increment counter!');
    prefs = await SharedPreferences.getInstance();

    // Ensure we've loaded the updated count from the background isolate.
    await prefs.reload();

    setState(() {
      _counter++;
    });
  }
  
  Future<void> callback() async {
    print('Alarm fired!');
  
    // Get the previous cached count and increment it.
    final prefs = await SharedPreferences.getInstance();
    int currentCount = prefs.getInt(countKey);
    await prefs.setInt(countKey, currentCount + 1);

    // This will be null if we're running in the background.
    uiSendPort ??= IsolateNameServer.lookupPortByName(isolateName);
    uiSendPort?.send(null);
  }

  @override
  void didChangeDependencies() {
    updateListView();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
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
                        color: XColors.darkTextColor,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold
                      ),
                    ),       
                    IconButton(
                      icon: Icon(Icons.search),
                      iconSize: 20.0,
                      key: const ValueKey('RegisterOneShotAlarm'),
                      onPressed: () async {
                         await AndroidAlarmManager.oneShot(
                          const Duration(seconds: 2),
                          // Ensure we have a unique alarm ID.
                          Random().nextInt(pow(2, 31)),
                          callback,
                          exact: true,
                          wakeup: true,
                          // alarmClock: true,
                          allowWhileIdle: true
                        );
                      },
                    ),

                    // Text(
                    //   prefs.getInt(countKey).toString(),
                    //   key: ValueKey('BackgroundCountText'),
                      
                    // ),

                  ],
                ),
                const SizedBox(height: 20.0,),
                TableCalendar(
                  calendarController: _calendarController,
                  headerVisible: false,
                  initialCalendarFormat: CalendarFormat.twoWeeks,
                ),
                
                const SizedBox(height: 10.0),
                const Divider(),

                Builder(
                  builder: (BuildContext context) {
                    if(_tasksList.isEmpty) {
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
                            
                            return TaskItem(
                              key: Key(item.scheduledTime),
                              title: _tasksList[index].title,
                              isTaskDone: _tasksList[index].isDone == 0 ? false : true,
                              priorityColor: _tasksList[index].priority == 0 ? Colors.red : Colors.blue,
                              isChecked: item.isDone  == 0 
                                  ? false : true,
                              onChanged: (bool value) {
                                TodoTask task = TodoTask(
                                  _tasksList[index].title,
                                  _tasksList[index].scheduledTime,
                                  _tasksList[index].category,
                                  _tasksList[index].priority,
                                  _tasksList[index].timeToStartAlarm,
                                  _tasksList[index].isDone,
                                  _tasksList[index].uploadedTime
                                );
                                task.isDone = value == true ? 1 : 0;

                                task.id = _tasksList[index].id;
                                _databaseHelper.updateTask(task);
                                updateListView();
                              },
                              onPressed: () {
                                showDetails(item);
                              },
                              onPinnedTapped: () {
                                
                              },
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
                const SizedBox(height: 20.0),
                _buildListTile(
                  'To notify', '${todo.timeToStartAlarm} minutes before', Icon(Icons.timelapse)
                ),
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
          _tasksList = taskList;
          _count = taskList.length;
        });
      });
    });
  }
}