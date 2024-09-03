import 'package:flutter/material.dart';
import 'package:revisisurveypisangver2/view/update_password_view.dart'; // Import the UpdatePasswordView

class ButtonGantiPassword extends StatelessWidget {
  const ButtonGantiPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const UpdatePasswordView(), // Navigate to UpdatePasswordView
          ),
        );
      },
      child: Container(
        alignment: Alignment.center,
        height: 55,
        decoration: BoxDecoration(
          color: Color(0xFFFFD245),
          borderRadius: BorderRadius.circular(60),
          boxShadow: [
            BoxShadow(
              color: Color(0xFFFFD245),
              blurRadius: 10,
            ),
          ],
        ),
        child: Text(
          'Ganti Password', // Button text
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
