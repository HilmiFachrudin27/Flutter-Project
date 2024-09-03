import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:revisisurveypisangver2/view/buttoneditprofile.dart';
import 'package:revisisurveypisangver2/view/buttonlogout.dart';
import 'package:revisisurveypisangver2/view/buttonupdatepassword.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../model/user_model.dart';
import '../services/user_services.dart';
import 'login_view.dart';

class ProfileView extends StatefulWidget {
  final String token; // Bearer token to authenticate API requests
  

  const ProfileView({super.key, required this.token});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  //late Future<Profile> _profile;
  late Future<UserModel> futureUser;

  @override
  void initState() {
    super.initState();
    futureUser = UserService().fetchUserProfile();
    /*_profile = getProfile(widget.token);
    print('ini function');
    print(_profile);*/
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Color(0xFFFFD245),
            fontWeight: FontWeight.bold,
        ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<UserModel>(
          future: futureUser,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return Center(child: Text('No data available'));
            }

            final profile = snapshot.data!;

            return SingleChildScrollView(
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
               /* Center(
                  child: CircleAvatar(
                    radius: 100,
                    backgroundImage: AssetImage(''),
                  ), 
                ),*/
                const SizedBox(height: 20),
                buildProfileInfo('Nama Pengguna', profile.name),
        
                const SizedBox(height: 20),
                buildProfileInfo('Email Pengguna', profile.email),
                
                 const SizedBox(height: 20),
                buildProfileInfo('No Handphone:', profile.phoneNumber),
                
                const SizedBox(height: 20),
                buildProfileInfo('Alamat:', profile.address),

                const SizedBox(height: 20),
                //buildProfileInfo('Asal Instansi:', profile._selectedRole), NOTSOLVED
                

              /*  const SizedBox(height: 20),
                buildProfileInfo('Asal Instansi:', profile.selectedRole),
              //  Text('Asal Instansi: ${profile.selectedRole}', style: TextStyle(fontSize: 18)),*/
                
                
                SizedBox(height: 20),
                ButtonEditProfile(),
                SizedBox(height: 20),
                ButtonGantiPassword(),
                SizedBox(height: 20),
                Buttonlogout(),
              /*  IconButton(
                  icon: Icon(Icons.logout, color: Colors.red),
                    onPressed: () => _logout(context),
                ), */ 
                
                

              ],
              )
            );
          },
        ),
      ),
    );
  }
}

Widget buildProfileInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),

        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            //fontWeight: FontWeight.bold,
          ),
        ),

      ],
    );
  }





  