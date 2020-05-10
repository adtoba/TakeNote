import 'package:flutter/material.dart';

class PreviousTaskItem extends StatelessWidget {
  const PreviousTaskItem({
    @required this.title
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.0,
      child: Container(
        height: 70,
        width: double.infinity,
        child: Row(
          children: <Widget>[
            Container(
              width: 10.0,
              height: 10.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red
              ),
            ),

            const SizedBox(width: 25.0),

            Text(
              title, 
              style: TextStyle(
                decorationColor: Colors.black,
                decoration: TextDecoration.lineThrough
              ),
            ),

            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Checkbox(
                  value: true,
                  onChanged: (bool val) {},
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
}