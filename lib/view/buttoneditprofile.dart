import 'package:flutter/material.dart';
//import 'package:revisisurveypisangver2/view/edit_profile_view.dart'; // Import the EditProfileView
import 'package:revisisurveypisangver2/view/update_profile_view.dart';


class ButtonEditProfile extends StatelessWidget {
  const ButtonEditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const UpdateProfileView(userToken: 'userToken'), // Navigate to EditProfileView
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
              color: Colors.white,
              blurRadius: 10,
            ),
          ],
        ),
        child: Text(
          'Edit Profile', // Button text
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
