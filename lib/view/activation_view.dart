import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ActivationView extends StatefulWidget {
  final String email;
  const ActivationView({Key? key, required this.email}) : super(key: key);

  @override
  State<ActivationView> createState() => _ActivationViewState();
}

class _ActivationViewState extends State<ActivationView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  Future<void> _activate() async {
    if (_formKey.currentState?.validate() ?? false) {
      final response = await http.post(
        Uri.parse('https://sso.pptik.id/api/v1/users/activate'), // Ganti dengan URL API aktivasi
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': _emailController.text,
          'guidAplication' : 'PROJECT-81385174-5459-436a-9756-01de7d32299a-2024',
          'otp': _otpController.text,
        }),
      );

      print('status Code : ${response.statusCode}');
      print('Response Body : ${response.body}');

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Activation Successful')),
        );
        //Navigator.pop(context);
        Navigator.pushReplacementNamed(context, 'LoginView()');
      } /*else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to activate')),
        );
      }*/
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activate Account'),
        backgroundColor: Colors.yellow,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 10),
                Text(
                  'Survey Pisang ',
                  style: TextStyle(
                    color: Color(0xFFFFD245),
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),

              const SizedBox(height: 20),
                Container(
                  alignment: Alignment.topLeft,
                  child: 
                  Text(
                    'Aktivasi Akun',
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
                    'E-Mail',
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
                      borderSide: BorderSide(color: Colors.black,width: 1.0),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'please enter Email';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 25),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'OTP',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),

              SizedBox(height: 5),
              TextFormField(
                controller: _otpController,
                decoration: InputDecoration(
                  hintText: 'Masukkan Kode OTP',
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
                obscureText: false,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the activation code';
                  }
                  return null;
                },
              ),
              
              /*Align(
                alignment: Alignment.centerLeft,
               /* child: TextButton(
                  onPressed: () {
                    Navigator.push(context, route)
                  },
                ),*/
                child: const Text(
                  'Send Kode OTP',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                )
              ),*/

              

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _activate,
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
    ),
    );
  }
}
