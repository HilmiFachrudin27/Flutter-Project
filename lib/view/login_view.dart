import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:revisisurveypisangver2/view/buttonactivation.dart';
import 'package:revisisurveypisangver2/view/buttondaftar.dart';
import 'package:revisisurveypisangver2/view/dashboardview.dart';
import 'package:revisisurveypisangver2/view/forgot_password.dart';
//import 'package:revisisurveypisang/view/buttonforgotpassword.dart';
//import 'package:revisisurveypisang/view/forgot_password.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:revisisurveypisangver2/view/register_view.dart';
//import 'package:revisisurveypisang/view/buttondaftar.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      final response = await http.post(
        Uri.parse('https://sso.pptik.id/api/v1/users/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': _emailController.text,
          'guidAplication': 'PROJECT-81385174-5459-436a-9756-01de7d32299a-2024',
          'password': _passwordController.text,
        }),
      );
      if (response.statusCode == 201) {
        // Decode the response body, which is a JSON string
        Map<String, dynamic> decodedResponse = json.decode(response.body);

        // Extract specific data
        bool success = decodedResponse['success'];
        String message = decodedResponse['message'];
        String appToken = decodedResponse['data']['appToken'];
        String userToken = decodedResponse['data']['userToken'];

        // Print the extracted values
        print('Success: $success');
        print('Message: $message');
        print('App Token: $appToken');
        print('User Token: $userToken');

        if (success) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('appToken', appToken); //saveapptoken
          SharedPreferences users = await SharedPreferences.getInstance();
          await users.setString('userToken', userToken); //saveusertoken
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => Dashboardview(token: appToken)),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login Failed')),
        );
        }
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }

     
    }
  }

  // Function to perform logout
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        title: Text ('Login'),
      ),*/
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 45),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Survey Pisang',
                    style: TextStyle(
                      color: Color(0xFFFFD245),
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                Container(
                  alignment: Alignment.topLeft,
                  child: 
                  Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                 const SizedBox(height: 10),
                Container(
                  alignment: Alignment.topLeft,
                  child: 
                  Text(
                    'Selamat Datang, masukkan akun untuk melanjutkan',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                     // fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
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

                SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.yellow,
                      width: 2.0,  
                    ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black,
                      width: 1.0,
                    ),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),

                //UI TAMPILAN
                //buat texttombol Lupa Kata Sandi
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ForgotPassword()),
                      );
                    },
                    child: const Text(
                      'Lupa Kata Sandi?',
                      style: TextStyle(
                        //alignment :Alignment.topRight,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 60),
                ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFFD245),
                        minimumSize: Size(600, 50),  
                      ),
                    child: Text(
                      'Masuk',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        //fontWeight: FontWeight.bold,
                      ),
                    )),

                SizedBox(height: 20),
                Buttondaftar(),

                SizedBox(height: 20),
                Buttonactivation(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
