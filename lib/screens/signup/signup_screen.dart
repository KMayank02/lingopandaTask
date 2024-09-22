import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lingopanda_task/screens/signup/components/signup_body.dart';
import 'package:lingopanda_task/utils/colors.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: kBgColor,
      ),
      child: Scaffold(
        backgroundColor: kBgColor,
        body: SignUpBody(),
        resizeToAvoidBottomInset: false,
      ),
    );
  }
}
