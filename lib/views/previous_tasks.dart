import 'package:flutter/material.dart';
import 'package:tasker/widgets/previous_task.dart';


class PreviousTasks extends StatefulWidget {
  const PreviousTasks({Key key}) : super(key: key);

  @override
  _PreviousTasksState createState() => _PreviousTasksState();
}

class _PreviousTasksState extends State<PreviousTasks> {

  final List<String> _customPreviousTasks = <String>[
    'Eat', 'Sleep', 'Feed my dog', 'Meeting', 'Study'
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          padding: const EdgeInsets.all(20.0),
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {},
                    ),
                    const SizedBox(height: 10.0),
                    const Text('All Tasks', style: TextStyle(
                      fontSize: 20.0
                    ),),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: ListView(
                        shrinkWrap: true,
                        children: List<Widget>.generate(_customPreviousTasks.length, (int index) {
                          return PreviousTaskItem(
                            title: _customPreviousTasks[index],
                          );
                        })
                      ),
                    )
                  ],
                ),
              ),

              Align(
                alignment: Alignment.bottomCenter,
                child: MaterialButton(
                  height: 50.0,
                  color: Colors.blue,
                  textColor: Colors.white,
                  minWidth: double.infinity,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)
                  ),
                  child: const Text('CONTINUE'),
                  onPressed: () {},
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}