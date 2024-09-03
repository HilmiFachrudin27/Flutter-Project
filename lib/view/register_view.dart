import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:revisisurveypisangver2/view/activation_view.dart';
import 'package:revisisurveypisangver2/view/buttonactivation.dart';
//import 'package:revisisurveypisang/view/activation_view.dart';
//import 'package:revisisurveypisang/view/buttonactivation.dart';
//import 'package:revisisurveypisang/view/buttondaftar.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController  = TextEditingController();
  final TextEditingController _emailController  = TextEditingController();
  final TextEditingController _passwordController  = TextEditingController();
  final TextEditingController _nohandphoneController  = TextEditingController();
  String? _selectedRole;

  final List<String> _roles = [ 'Kementrian Pendidikan dan Kebudayaan','PT LSKK', 'PT Telkom Indonesia', 'Pos Indonesia'];

  Future<void> _register() async {
    if (_formKey.currentState?.validate() ??  false){
      final response = await http.post(Uri.parse('https://sso.pptik.id/api/v1/users/register'),
      headers: <String, String>{
        'Content-Type'  : 'application/json; charset=UTF-8',
      },

      body: jsonEncode(<String, String>{
        'email' : _emailController.text,
        'password':  _passwordController.text,
        'phoneNumber':  _nohandphoneController.text,
        'name': _nameController.text,
        'guidAplication' : 'PROJECT-81385174-5459-436a-9756-01de7d32299a-2024',
        'role' : 'admin',
        'companyGuid' : 'COMPANY-b3465656-0f2b-4a70-801b-80a1e9cc7fb8-2024',
      }),

     );

     print('status Code : ${response.statusCode}');
     print('Response Body : ${response.body}');

     if(response.statusCode == 200) {
      //print('account created'
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration Succesful')),
      );
      //Navigator.pop(context);
      Navigator.push(
        context, MaterialPageRoute(
          //builder: (context)  =>  Buttonactivation(email: _emailController.text),
          builder: (context)  =>  ActivationView(
            email:_emailController.text),
        ),
      ); 
    }/*else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to Register')),
      );
     }*/
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Akun'),
        backgroundColor: Colors.yellow,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child : SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget> [
                SizedBox(height: 20),
                Container(
                  alignment: Alignment.center,
                ),

                Text(
                  'Survey Pisang',
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
                    'Pendaftaran',
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
                    'Selamat Datang, Daftarkan akun untuk melanjutkan',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                     // fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Asal Instansi',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),

                const SizedBox(height: 5),
                DropdownButtonFormField<String>(
                  value: _selectedRole,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.yellow,
                        width: 2.0,
                      ),
                    ),
                  ),
                  items: _roles.map((pilihan) {
                    return DropdownMenuItem<String>(
                      value: pilihan,
                      child: Text(pilihan),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedRole = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Pilih Asal Instansi';
                    }
                    return null;
                  },
                ),
                  

                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Nama Lengkap',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
      
                const SizedBox(height: 5),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                  //  labelText: 'Nama Lengkap',
                    hintText: 'Masukkan Nama Lengkap',
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
                  keyboardType: TextInputType.name,
                  validator: (value) {
                  if (value  ==  null || value.isEmpty){
                      return 'Please Enter your name';
                  } 
                  return null;
                  }
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
                  obscureText: false,
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
                    'Password',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),

                SizedBox(height: 5),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    hintText: 'Masukkan Password',
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
                      return 'Please enter your password';
                    }
                    if (value.length < 6 ) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 25),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'No Handphone',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),


                SizedBox(height: 5),
                TextFormField(
                  controller: _nohandphoneController,
                  decoration: InputDecoration(
                    hintText: 'Masukkan No. Handphone',
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
                      return 'Please enter your phone number';
                    }
                    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                      return 'Please enter a valid phone number';
                    }
                    return null;
                  },
                ),  

                SizedBox(height: 20), 
                ElevatedButton(
                  onPressed: _register, 
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                    minimumSize: Size(600, 50),
                  ),
                  child:Text (
                    'Daftar',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    //  fontWeight: FontWeight.bold,
                    ),
                  ), 
                ),

                SizedBox(height: 20),
                Buttonactivation(),

                //Buttonactivation(),

              /*  const SizedBox(height: 20),
                Container(alignment: Alignment.center),
                Text('Pendaftaran'),
                TextStyle(
                  color: Colors.purple,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),*/
                
              ],
            ),
          ),  
        ),
      ),
    );
    }
  }