import 'package:flutter/material.dart';
import 'package:muproject/edit_profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to My App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to My App!',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 32),
            
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: const Text('Login'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signup');
              },
              child: const Text('Sign Up'),
            ),

              const SizedBox(height: 16),
            ElevatedButton(onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  EditProfileScreen()),
                );   },
                child:Padding(
                  padding: const EdgeInsets.all(13.0),
                child: Text('Profile'),
          )),
          ],
        ),
      ),
    );
  }
}

