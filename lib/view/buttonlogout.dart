import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../view/login_view.dart'; // Adjust path to your LoginView
import '../services/logout_services.dart'; // Adjust path to your logout service

class Buttonlogout extends StatefulWidget {
  const Buttonlogout({super.key});

  @override
  State<Buttonlogout> createState() => _ButtonlogoutState();
}

class _ButtonlogoutState extends State<Buttonlogout> {
  Future<void> _handleLogout() async {
    await logout(context); // Call the logout function
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _handleLogout, // Handle the tap event
      child: Container(
        alignment: Alignment.center,
        height: 55,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: Colors.yellow,
              blurRadius: 10,
            ),
          ],
        ),
        child: Text(
          'LogOut',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}


/*import 'package:flutter/material.dart';
import '../view/dashboardview.dart';

class Buttonlogout extends StatefulWidget {
  const Buttonlogout({super.key});

  @override
  State<Buttonlogout> createState() => _ButtonlogoutState();
}

class _ButtonlogoutState extends State<Buttonlogout> {

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        alignment: Alignment.center,
        height: 55,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: Colors.yellow,
              blurRadius: 10,
            ),
          ],
        ),

        child: Text(
          'LogOut',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      );
  }
}*/