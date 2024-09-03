// logout_service.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../view/login_view.dart'; // Adjust path to your LoginView

Future<void> logout(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  
  // Remove tokens from SharedPreferences
  await prefs.remove('appToken');
  await prefs.remove('userToken');
  
  // Navigate to the Login screen
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => LoginView()),
  );
}
