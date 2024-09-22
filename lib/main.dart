import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lingopanda_task/provider/auth_provider.dart';
import 'package:lingopanda_task/provider/comment_provider.dart';
import 'package:lingopanda_task/screens/comments/comment_screen.dart';
import 'package:lingopanda_task/screens/login/login_screen.dart';
import 'package:lingopanda_task/screens/signup/signup_screen.dart';
import 'package:lingopanda_task/utils/colors.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserAuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CommentProvider(),
        ),
      ],
      
      child: OverlaySupport.global(
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: PopScope(
            canPop: false,
            child: MaterialApp(
              title: 'Flutter Demo',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: kPrimaryColor),
                useMaterial3: true,
                textTheme:
                    GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
              ),
              themeMode: ThemeMode.light,
              home: Consumer<UserAuthProvider>(
                builder: (context, value, child) {
                  // if(value.user!=null)
                  // {
                  //   return CommentScreen();
                  // } return SignUpScreen();

                  switch (value.status) {
                    case Status.SignUp:
                      return SignUpScreen();
                    case Status.Login:
                      return LoginInScreen();
                    case Status.Authenticating:
                    case Status.Authenticated:
                      return CommentScreen();
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
