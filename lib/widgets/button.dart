import 'package:flutter/material.dart';
import 'package:tasker/utils/colors.dart';


class XButton extends StatelessWidget {
  const XButton({
    this.width,
    @required this.caption,
    this.onPressed
  });

  final double width;
  final String caption;
  final GestureTapCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: width ?? 120,
      decoration: BoxDecoration(
        color: XColors.buttonColor,
        borderRadius: BorderRadius.circular(20.0)
      ),
      child: InkWell(
        onTap: onPressed,
        child: Center(
          child: Text(caption, style: const TextStyle(color: Colors.white),),
        ),
      ),
    );
  }
}