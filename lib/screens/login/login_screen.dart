import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lingopanda_task/screens/login/components/login_body.dart';
import 'package:lingopanda_task/utils/colors.dart';

class LoginInScreen extends StatefulWidget {
  const LoginInScreen({super.key});

  @override
  _LoginInScreenState createState() => _LoginInScreenState();
}

class _LoginInScreenState extends State<LoginInScreen> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: kBgColor,
      ),
      child: Scaffold(
        backgroundColor: kBgColor,
        body: LoginBody(),
        resizeToAvoidBottomInset: false,
      ),
    );
  }
}
