import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  Future<void> _resetPassword() async {
    if (_formKey.currentState?.validate() ?? false) {
      final response = await http.post(
        Uri.parse('https://sso.pptik.id/api/v1/users/forgot-password'), // Ganti dengan URL API reset password
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': _emailController.text,
        }),
      );

      print('status Code : ${response.statusCode}');
      print('Response Body : ${response.body}');

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password reset link sent to your email')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send password reset link')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Survey Pisang'),
          backgroundColor: Colors.yellow,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 20),
              Text(
                'Lupa Kata Sandi',
                style: TextStyle(
                  color: Colors.yellow,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),
                Container(
                  alignment: Alignment.topLeft,
                  child: 
                  Text(
                    'Lupa Kata Sandi',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                 const SizedBox(height: 5),
                Container(
                  alignment: Alignment.topLeft,
                  child: 
                  Text(
                    'Kirim Permintaan Reset Password',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                     // fontWeight: FontWeight.bold,
                    ),
                  ),
                ),


              const SizedBox(height: 25),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'E-Mail Saat ini',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),


              SizedBox(height: 5),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Masukkan Email saat ini',
                  border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.yellow,
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black,width: 1.0),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _resetPassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFFD245),
                   minimumSize: Size(600, 50),
                ),
                child: Text(
                  'Kirim',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
