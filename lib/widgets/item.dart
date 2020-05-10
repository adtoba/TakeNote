import 'package:flutter/material.dart';
import 'package:tasker/utils/colors.dart';


class SingleItem extends StatelessWidget {
  const SingleItem({
    @required this.title,
    @required this.description,
    @required this.dateTime,
    this.index,
    this.priority
  });

  final String title;
  final String description;
  final String dateTime;
  final int index;
  final int priority;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Container(
            height: 120,
            width: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50.0),
              color: index % 3 ==  0 
                ? XColors.meetingDeepColor
                : (index + 1) / 3 == 1
                ? XColors.travelingDeepColor
                : XColors.studyDeepColor
            ),
            child: Center(
              child: RotatedBox(
                quarterTurns: 1,
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 20.0),
        Expanded(
          flex: 3,
          child: Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(vertical: 5.0),
            decoration: BoxDecoration(
              color: index % 3 ==  0 
                ? XColors.meetingColor
                : (index + 1) / 3 == 1
                ? XColors.travelingColor
                : XColors.studyColor,
              borderRadius: BorderRadius.circular(10.0)
            ),
            child: Row(
              children: <Widget>[
                Container(
                  width: 7.0,
                  height: 120,
                  decoration: BoxDecoration(
                    color: index % 3 ==  0 
                      ? XColors.meetingDeepColor
                      : (index + 1) / 3 == 1
                      ? XColors.travelingDeepColor
                      : XColors.studyDeepColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      bottomLeft: Radius.circular(20.0)
                    )
                  ),
                  
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Icon(Icons.alarm, color: XColors.meetingDeepColor,),
                            Text(dateTime.substring(11, 16), style: TextStyle(color: XColors.meetingDeepColor),)
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        Text(
                          description, overflow: TextOverflow.ellipsis, style: TextStyle(
                            color: Colors.white, fontSize: 20.0
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                           priority == 0 ? 'HIGH' : 'LOW', overflow: TextOverflow.ellipsis, style: TextStyle(
                              color: Colors.white, fontSize: 20.0
                            ),
                          ),
                        ),
                        
                        // Text(
                        //   '10:00 AM'
                        // )

                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}