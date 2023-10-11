import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:muproject/DBHelper.dart';
import 'package:muproject/signup_screen.dart';
import 'package:muproject/edit_profile_screen.dart';

import 'package:muproject/already_have_an_acount_check.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  String email = _emailController.text.trim();
                  String password = _passwordController.text.trim();
                  Map<String, dynamic> user = await DBHelper.getUser(email);
                  if (user.isNotEmpty && user[DBHelper.PASSWORD] == password) {
                    // Login successful
                    Fluttertoast.showToast(msg: 'Login successful');
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>EditProfileScreen()));

                  } else {
                    // Login failed
                    Fluttertoast.showToast(msg: 'Invalid email or password');
                  }
                },
                child: const Text('Login'),
              ),
            ),
            const SizedBox(height: 16.0),
           AlreadyHaveAnAccountCheck(
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return SignUpScreen();
                  },
                ),
              );
            },
          ),
          ],
        ),
      ),
    );
  }
}