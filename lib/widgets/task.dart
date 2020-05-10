import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';


class TaskItem extends StatefulWidget {
  const TaskItem({
    Key key,
    @required this.title,
    this.isChecked = false,
    this.onChanged,
    this.priorityColor,
    this.onPinnedTapped,
    this.onDeleteTapped,
    this.onPressed,
    this.isTaskDone
  }) : super(key: key);

  final String title;
  final bool isChecked;
  final Function(bool) onChanged;
  final GestureTapCallback onPinnedTapped;
  final GestureTapCallback onDeleteTapped;
  final Color priorityColor;
  final GestureTapCallback onPressed;
  final bool isTaskDone;

  @override
  _TaskItemState createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: const SlidableStrechActionPane(),
      actionExtentRatio: 0.2,
      secondaryActions: <Widget>[
        // IconSlideAction(
        //   onTap: widget.onPinnedTapped,
        //   iconWidget: Icon(Icons.edit, color: Colors.grey, size: 30.0),
        // ),
         IconSlideAction(
           onTap: widget.onDeleteTapped,
          iconWidget: Icon(Icons.delete_outline, color: Colors.grey, size: 30.0),    
        )
      ],
      child: Card(
        elevation: 0.0,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          width: double.infinity,
          height: 70.0,
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    width: 10.0,
                    height: 10.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.priorityColor
                    ),
                  ),
                  const SizedBox(width: 25.0),
                  Expanded(
                    flex: 4,
                    child: GestureDetector(
                      onTap: widget.onPressed,
                      child: Text(
                        widget.title, style: TextStyle(
                          fontSize: 18.0, decoration: widget.isTaskDone ? TextDecoration.lineThrough : TextDecoration.none
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),

                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Checkbox(
                        value: widget.isChecked,
                        onChanged: widget.onChanged
                      ),
                    ),
                  ),
                  Visibility(
                    visible: isVisible,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Checkbox(
                        value: widget.isChecked,
                        onChanged: widget.onChanged
                      ),
                    ),
                  )

                ],
              ),

              const Divider()
            ],
          ),
        ),
      ),
    );
  }
}