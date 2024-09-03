import 'package:flutter/material.dart';
//import 'package:revisisurveypisang/view/activation_view.dart';
import 'package:revisisurveypisangver2/view/activation_view.dart';


class Buttonactivation extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  Buttonactivation({super.key});
  

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context, MaterialPageRoute(
            builder: (context) => ActivationView(
              email:_emailController.text),
            ),
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
          'Aktivasi Akun',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}