/*import 'package:flutter/material.dart';
import 'dart:async';

import 'package:revisisurveypisangver2/view/login_view.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    _animateBanana();
    _goHome();
  }

  // Method to handle the navigation after a delay
  void _goHome() async {
    await Future.delayed(const Duration(milliseconds: 1000)); // Delay for 1 second
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(builder: (context) => const LoginView()),
    );
  }

  // Method to animate the banana
  void _animateBanana() async {
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _opacity = 1.0; // Fade in the banana
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow, // Background color of the splash screen
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedOpacity(
              opacity: _opacity,
              duration: const Duration(seconds: 1),
              child: Image.asset('assets/banana.png', height: 100.0),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Survey Pisang',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/



import 'package:flutter/material.dart';
import 'dart:async';

import 'package:revisisurveypisangver2/view/login_view.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    _gohome();
    super.initState();
    
  }

  _gohome() async {
    await Future.delayed(const Duration(milliseconds: 1000), (){} );
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(builder: (context) => const LoginView()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow, // Warna latar belakang splash screen
      body: Center(
        child: Text(
          'Survey Pisang',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

/*import 'package:flutter/material.dart';
import 'dart:async';

import 'package:revisisurveypisangver2/view/login_view.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    _gohome();
    super.initState();
  }

  _gohome() async {
    await Future.delayed(const Duration(milliseconds: 1000), (){} );
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(builder: (context) => const LoginView()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow, // Background color of splash screen
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/banana.png'), // Your PNG image
            SizedBox(height: 20),
            Text(
              'Survey Pisang',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/

