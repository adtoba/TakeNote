import 'package:TakeNote/models/todo.dart';
import 'package:TakeNote/db/db_helper.dart';
import 'package:flutter/material.dart';


class AddTask extends StatefulWidget {
  const AddTask({
    Key key
  }) : super(key: key);

  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Database helper
  final DBHelper _dbHelper = DBHelper();

  final List<String> _categoryList = <String>[
    'Home', 'School', 'Work', 'Others'
  ];

  final List<Icon> _categoryIcon = <Icon>[
    Icon(Icons.home),
    Icon(Icons.school),
    Icon(Icons.work),
    Icon(Icons.more)
  ];
   
  // All variables needed to save task
  TimeOfDay scheduledTime;
  String _selectedPriority;
  int _selectedTimeBefore;
  
  String _category;
  DateTime _timePosted;

  TodoTask todoTask = TodoTask(
    '', // title
    '', // scheduled time
    '', // category
    1, // priority
    '', // timeToStartAlarm
    0, // isDone
    '', // timePosted
  );

  // Text controller
  TextEditingController _taskController;

  @override
  void initState() {
    _taskController = TextEditingController();
    _timePosted = DateTime.now();
    super.initState();
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.all(20.0),
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        const SizedBox(height: 3.0),
                        TextFormField(
                          controller: _taskController,
                          cursorColor: Colors.grey,
                          maxLines: 4,
                          textInputAction: TextInputAction.done,
                          style: const TextStyle(fontSize: 23.0),
                          decoration: const InputDecoration(
                            hintText: 'Write task here',
                            hintStyle: TextStyle(fontSize: 30.0),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none
                            )
                          ),
                          onChanged: (String value) {
                            updateTitle(value);
                          },
                          validator: (String value) {
                            if(value.isEmpty) {
                              return 'Oops, you forgot to add a title';
                            } else if(_category == null) {
                              return 'select a category';
                            } else if(scheduledTime == null){
                              return 'choose time';
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(height: 10.0),
                        ListTile(
                          leading: Icon(Icons.timer),
                          title: Text(
                            scheduledTime != null 
                              ? scheduledTime.format(context) 
                              : 'Schedule time'
                          ),
                          onTap: () async {
                            final TimeOfDay selectedTime = await showTimePicker(
                              context: context, 
                              initialTime: TimeOfDay.now()
                            );
                            setState(() {
                              scheduledTime = selectedTime;
                            });
                          },
                        ),
                       
                        ListTile(
                          leading: Icon(Icons.more),
                          title: Text(
                            _category == null 
                              ? 'Category' 
                              : _category
                          ),
                          onTap: () => showCategoryDialog(),
                        ),
                        const SizedBox(height: 40.0),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              const Text('Notes', style: TextStyle(fontSize: 18.0),),
                              _buildPriorityWidget()
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        persistentFooterButtons: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)
              ),
              minWidth: 500,
              height: 50.0,
              onPressed: () => _handleAddTask(),
              color: Colors.blue,
              textColor: Colors.white,
              child: const Text('Add'),
            ),
          ),
        ],
      ),
    );
  }
  

  Widget _buildPriorityWidget() {
    return InkWell(
      onTap: () => showPriorityDialog(),
      borderRadius: BorderRadius.circular(20.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey.withOpacity(0.3)
        ),
        child: Row(
          children: <Widget>[
            Icon(Icons.priority_high, color: _selectedPriority == 'High' ? Colors.red : Colors.blue,),
            const SizedBox(width: 2.0),
            Text(_selectedPriority == null
                  ? 'Priority'.toUpperCase()
                  : _selectedPriority.toUpperCase(), style: TextStyle(color: _selectedPriority == 'High' ? Colors.red : Colors.blue)),
          ],
        ),
      ),
    );
  }

  Future<void> _handleAddTask() async {
    if(_formKey.currentState.validate()) {
      todoTask.scheduledTime = scheduledTime.format(context);
      todoTask.timeToStartAlarm = '';
      todoTask.category = _category;
      todoTask.uploadedTime = _timePosted.toString();
      if(_selectedPriority == 'High') {
        todoTask.priority = 0;
      } else {
        todoTask.priority = 1;
      }
      todoTask.isDone = 0;
      
      await _dbHelper.insertTask(todoTask);
      Navigator.pop(context);
    }   
}

  void updateTitle(String title) {
    todoTask.title = title;
  }

  void showCategoryDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            height: 250.0,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: List<Widget>.generate(_categoryList.length, (int index) {
                  return  ListTile(
                    leading: _categoryIcon[index],
                    title: Text(_categoryList[index]),
                    onTap: () {
                      setState(() {
                        _category = _categoryList[index];
                      });
                      Navigator.pop(context);
                    },
                  );
                })
              ),
            ),
          ),
        );
      }
    );
  }

  void showPriorityDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            height: 150.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ListTile(
                  leading: Container(
                    width: 10.0,
                    height: 10.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red
                    ),
                  ),
                  title: const Text('High'),
                  onTap: () {
                    setState(() {
                      _selectedPriority = 'High';
                    });
                    Navigator.pop(context);
                    print(_selectedPriority);
                  },
                ),
                ListTile(
                  leading: Container(
                    width: 10.0,
                    height: 10.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue
                    ),
                  ),
                  title: const Text('Low'),
                  onTap: () {
                    setState(() {
                      _selectedPriority = 'Low';
                    });
                    Navigator.pop(context);
                    print(_selectedPriority);
                  },
                )
              ],
            ),
          ),
        );
      }
    );
  }
}