import 'package:flutter/material.dart';
import 'package:lingopanda_task/utils/colors.dart';
import 'package:lingopanda_task/utils/size_config.dart';

class SubmitBtn extends StatelessWidget {
  const SubmitBtn({
    required this.text,
    required this.onTap,
    this.fillClr,
    super.key,
  });

  final String text;
  final Color? fillClr;
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SizeConfig.screenWidth/2,
      child: ElevatedButton(
        onPressed: onTap,
        child: Text(
          text,
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
        ),
        style: ElevatedButton.styleFrom(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // <-- Radius
            ),
            backgroundColor: fillClr ?? kPrimaryColor,
            padding: EdgeInsets.symmetric(vertical: 15)),
      ),
    );
  }
}
