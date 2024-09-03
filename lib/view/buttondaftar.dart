import 'package:flutter/material.dart';
import 'package:revisisurveypisangver2/view/activation_view.dart';
import 'package:revisisurveypisangver2/view/register_view.dart';

class Buttondaftar extends StatelessWidget {
  const Buttondaftar({super.key});

  @override
  Widget build(BuildContext context) {
    return  InkWell(
      onTap: () {
        Navigator.push(
          context, MaterialPageRoute(
            builder: (context) => RegisterView()),
        );
      },
      child: Container(
        alignment: Alignment.center,
        height: 55,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: Colors.yellow,
              blurRadius: 10,
            ),
          ],
        ),

        child: Text(
          'Daftarkan Akun',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}