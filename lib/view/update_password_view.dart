import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UpdatePasswordView extends StatefulWidget {
  const UpdatePasswordView({super.key});

  @override
  State<UpdatePasswordView> createState() => _UpdatePasswordViewState();
}

class _UpdatePasswordViewState extends State<UpdatePasswordView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  Future<void> _updatePassword() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Replace with your API endpoint
      final response = await http.post(
        Uri.parse('https://sso.pptik.id/api/v1/users/edit-password'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email'       : _emailController.text,
          'currentPassword': _currentPasswordController.text,
          'newPassword': _newPasswordController.text,
        }),
      );

      print('status Code : ${response.statusCode}');
      print('Response Body : ${response.body}');

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password updated successfully')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update password')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Update Password',
          style: TextStyle(
            color: Color(0xFFFFD245),
            //fontWeight: FontWeight.bold,
          ),  
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                
                const SizedBox(height: 30),
                Container(
                  alignment: Alignment.topLeft,
                  child: 
                  Text(
                    'Ubah Password',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 25),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Email',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),

                SizedBox(height: 5),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'Masukkan Email',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.yellow,
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1.0),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  obscureText: true,
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

                const SizedBox(height: 25),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Password Lama',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),



                SizedBox(height: 5),
                TextFormField(
                  controller: _currentPasswordController,
                  decoration: InputDecoration(
                    hintText: 'Password Sebelumnya',
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
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _newPasswordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 25),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Password Baru',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),


                SizedBox(height: 5),
                TextFormField(
                  controller: _newPasswordController,
                  decoration: InputDecoration(hintText: 
                  'Masukkan Password Baru',
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
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your new password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _updatePassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:Color(0xFFFFD245),
                    minimumSize: Size(600, 50),
                  ),
                  child: Text(
                    'Simpan',
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
      ),
    );
  }
}
