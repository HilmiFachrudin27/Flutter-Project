import 'package:flutter/material.dart';
import 'package:revisisurveypisangver2/view/activation_view.dart';

import 'package:revisisurveypisangver2/view/dashboardview.dart';
import 'package:revisisurveypisangver2/view/login_view.dart';
import 'package:revisisurveypisangver2/view/register_view.dart';
import 'package:revisisurveypisangver2/view/splashscreen.dart';
import 'package:revisisurveypisangver2/view/update_password_view.dart';

void main(){
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //home: RegisterView(),
      //home: LoginView(),
      home: SplashScreen(),
      //home: Dashboardview(token: '123'),
      //home: UpdatePasswordView(),
      //home: ActivationView(email: email),
      //home: ActivationView(),
    );
  }
}