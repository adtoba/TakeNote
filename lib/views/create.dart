import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:tasker/core/models/task.dart';
import 'package:tasker/core/services/database_helper.dart';
import 'package:tasker/utils/colors.dart';
import 'package:tasker/widgets/back_button.dart';
import 'package:tasker/widgets/button.dart';
import 'package:tasker/widgets/text_input.dart';


const String MIN_DATETIME = '2019-05-15 20:10:55';
const String MAX_DATETIME = '2035-07-01 12:30:40';
const String INIT_DATETIME = '2019-05-16 09:00:58';
const String DATE_FORMAT = 'yyyy-MM-dd,H:mm:';

class CreateTask extends StatefulWidget {
  const CreateTask(this.task);
  final Task task;

  @override
  _CreateTaskState createState() => _CreateTaskState(task);
}

class _CreateTaskState extends State<CreateTask> {
  _CreateTaskState(this.task);
  
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  DateTime _dateTime;
  DateTime _currentDateTime;
  String _currDateTime;

  Task task;

  

  @override
  void initState() {
    _currentDateTime = DateTime.now();
    _currDateTime = _currentDateTime.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double deviceHeight = size.height;
    final double deviceWidth = size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: XColors.buttonColor,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: deviceHeight / 4,
                  decoration: BoxDecoration(
                    color: XColors.buttonColor
                  ),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        top: 20.0,
                        left: 20.0,
                        child: XBackButton(),
                      ),

                      Positioned(
                        bottom: 40,
                        left: 20.0,
                        right: 20.0,
                        child: Text(
                          'Create New Task', style: TextStyle(
                            fontSize: 24.0, color: Colors.white
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: deviceHeight - (deviceHeight / 3.6),
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
                  decoration: BoxDecoration(
                    color: XColors.dailyTaskBGColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(40.0),
                      topRight: Radius.circular(40.0)
                    )
                  ),
                  child: Stack(
                    children: <Widget>[
                      SingleChildScrollView(
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Text('Date', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 10.0),
                               Container(
                                child: DateTimePickerWidget(
                                  minDateTime: DateTime.parse(_currDateTime),
                                  maxDateTime: DateTime.parse(MAX_DATETIME),
                                  initDateTime: DateTime.parse(_currDateTime),
                                  dateFormat: DATE_FORMAT,
                                  pickerTheme: DateTimePickerTheme(
                                    showTitle: true,
                                    title: const Text('Select date and time'),
                                    backgroundColor: Colors.white,
                                  ),
                                  onChange: (DateTime dateTime, List<int> selectedIndex) {
                                    setState(() {
                                      _dateTime = dateTime;
                                    });
                                    print(_dateTime);
                                  },
                                ),
                              ),
                              const Text('Title', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 10.0),
                              TextInput(
                                controller: _titleController, 
                                hint: 'Write the title', 
                                maxLines: 1,
                                onChanged: (String value) {
                                  updateTitle(value);
                                }
                              ),
                              const SizedBox(height: 20.0),
                              const Text('Description', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 10.0),
                              TextInput(
                                controller: _descriptionController, 
                                hint: 'Write the description', 
                                maxLines: 3,
                                onChanged: (String value) {
                                  updateDescription(value);
                                }
                              ),
                              
                              const SizedBox(height: 100.0)
                            ],
                          ),
                        ),
                      ),

                      Positioned(
                        bottom: 0.0,
                        right: 0.0,
                        child: XButton(
                          caption: 'SAVE',
                          onPressed: () => _save(),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        )
      ),
    );
  }

  void updateTitle(String value) {
    task.title = value;
    print(_titleController.text);
  }

  void updateDescription(String value) {
    task.description = value;
    print(_descriptionController.text);
  }

  Future<void> _save() async {
    task.dateTime = _dateTime.toString();
    task.priority = 1;

    if(task.id == null) {
      await _databaseHelper.insertTask(task);
    } else {
      await _databaseHelper.updateTask(task);
    }
  }
}