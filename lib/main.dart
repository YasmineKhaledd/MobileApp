import 'package:flutter/material.dart';
import 'package:muproject/login_screen.dart';
import 'package:muproject/signup_screen.dart';
import 'package:muproject/edit_profile_screen.dart';
import 'package:muproject/home_screen.dart';
import 'splashscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Local DB Demo',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
      primarySwatch: Colors.purple,
      ),
      home:  Splash(),
      initialRoute: "home_screen",

      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
        '/edit':(context) => EditProfileScreen(),
      },
    );
  }
}