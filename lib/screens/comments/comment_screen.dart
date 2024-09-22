import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lingopanda_task/screens/comments/components/comments_body.dart';
import 'package:lingopanda_task/utils/colors.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({super.key});

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: kPrimaryColor,
      ),
      child: Scaffold(
        backgroundColor: kBgColor,
        body: CommentListBody(),
        resizeToAvoidBottomInset: false,
      ),
    );
  }
}
