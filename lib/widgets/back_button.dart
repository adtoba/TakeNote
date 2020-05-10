import 'package:flutter/material.dart';
import 'package:tasker/utils/colors.dart';


class XBackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      decoration: BoxDecoration(
        color: XColors.dailyTaskBGColor.withOpacity(0.4),
        borderRadius: BorderRadius.circular(20.0)
      ),
      child: InkWell(
        onTap: () => Navigator.pop(context),
        child: Row(
          children: <Widget>[
            Icon(Icons.close, color: Colors.white, size: 20,),
            const SizedBox(width: 3.0),
            const Text('Back', style: TextStyle(color: Colors.white, fontSize: 16),)
          ],
        ),
      ),
    );
  }
}