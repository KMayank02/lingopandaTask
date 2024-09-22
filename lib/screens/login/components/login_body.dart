import 'package:flutter/material.dart';
import 'package:lingopanda_task/provider/auth_provider.dart';
import 'package:lingopanda_task/utils/colors.dart';
import 'package:lingopanda_task/utils/size_config.dart';
import 'package:lingopanda_task/widgets/button.dart';
import 'package:provider/provider.dart';

class LoginBody extends StatefulWidget {
  const LoginBody({super.key});

  @override
  State<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  final _formKey = GlobalKey<FormState>();

  String? email = "";
  String? password = "";

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final user = Provider.of<UserAuthProvider>(context);
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 35),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Comments',
                  style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: 25,
                      fontWeight: FontWeight.w900),
                ),
                verticalSpaceHuge,
                verticalSpaceHuge,
                verticalSpaceHuge,
                Form(
                  key: _formKey,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      TextFormField(
                        key: ValueKey("email"),
                        onSaved: (newValue) {
                          email = newValue!;
                        },
                        validator: (value) {
                          const pattern =
                              r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
                              r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
                              r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
                              r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
                              r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
                              r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
                              r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
                          final regex = RegExp(pattern);
                          if (value!.isEmpty) {
                            return "This field cannot be blank";
                          }
                          if (!regex.hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                        cursorColor: kPrimaryColor,
                        style: TextStyle(color: kTextColor, fontSize: 14),
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          // prefixIcon: Container(
                          //   width: 15,
                          //   height: 15,
                          //   alignment: Alignment.center,
                          //   child: SvgPicture.asset(
                          //     'assets/icons/email.svg',
                          //   ),
                          // ),
                          errorStyle: TextStyle(
                            color: kPrimaryColor,
                          ),
                          hintText: 'Email',
                          hintStyle: TextStyle(color: kTextColor, fontSize: 14),
                          filled: true,
                          fillColor: kWhiteColor,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      verticalSpaceSmall,
                      verticalSpaceSmall,
                      TextFormField(
                        key: ValueKey("password"),
                        onSaved: (newValue) {
                          password = newValue!;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "This field cannot be blank";
                          }
                          if (value.length < 6) {
                            return "Minimum 6 characters required";
                          }
                          return null;
                        },
                        cursorColor: kPrimaryColor,
                        style: TextStyle(color: kTextColor, fontSize: 14),
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          errorStyle: TextStyle(
                            color: kPrimaryColor,
                          ),
                          hintText: 'Password',
                          hintStyle: TextStyle(color: kTextColor, fontSize: 14),
                          filled: true,
                          fillColor: kWhiteColor,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Center(
              child: user.status == Status.Authenticating
                  ? Center(child: CircularProgressIndicator(color: kPrimaryColor,))
                  : Column(
                      children: [
                        SubmitBtn(
                          text: 'Login',
                          onTap: () async {
                            var isValid = _formKey.currentState!.validate();
                            if (isValid) {
                              print(email);
                              _formKey.currentState!.save();
                              FocusScope.of(context).unfocus();
                              if (email != null && password != null) {
                                await user.login(email!, password!);
                              }
                            }
                          },
                        ),
                        verticalSpaceSmall,
                        verticalSpaceSmall,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'New here?',
                              style: TextStyle(
                                color: kTextColor,
                              ),
                            ),
                            horizontalSpaceTiny,
                            GestureDetector(
                              child: Text(
                                'Signup',
                                style: TextStyle(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onTap: () {
                                user.toggleLogin(Status.SignUp);
                              },
                            )
                          ],
                        ),
                      ],
                    ),
            )
          ],
        ),
      ),
    );
  }
}
