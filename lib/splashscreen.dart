import 'dart:async';

import 'package:flutter/material.dart';
import 'Home_screen.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override

  void initState() {
    // TODO: implement initState
    super.initState();

    Timer( const Duration(seconds: 5),
        (){
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>HomeScreen()));
        }

    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0,0.5,1],
              colors: [
                Color.fromARGB(255, 219, 151, 233),
                Colors.white,
                Color.fromARGB(255, 83, 23, 88)
                  ])),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                  Text('Welcome',
                    style: TextStyle(fontSize: 30,color: Colors.black),
                  ),

                ],
                ),
                ),

      ),
    );
  }
}
