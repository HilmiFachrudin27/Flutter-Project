import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateProfileView extends StatefulWidget {
  const UpdateProfileView({super.key, required this.userToken});

  final String userToken;

  @override
  State<UpdateProfileView> createState() => _UpdateProfileViewState();
}

class _UpdateProfileViewState extends State<UpdateProfileView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  File? _image;
  String? _selectedRole;

  final List<String> _roles = [
    'Kementrian Pendidikan dan Kebudayaan',
    'PT LSKK',
    'PT Telkom Indonesia',
    'Pos Indonesia'
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Use the widget.userToken directly
  }




// Save token
Future<void> _saveToken(String userToken) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('userToken', userToken);
  print('Token saved: $userToken');
}

// Retrieve token
Future<String?> _getToken() async {
  final prefs = await SharedPreferences.getInstance();
  final userToken = prefs.getString('userToken');
  print('Retrieved token: $userToken');
  return userToken;
}



  Future<void> _loadUserData() async {
  try {
    final response = await http.get(
      Uri.parse('https://sso.pptik.id/api/v1/users/profile'),
      headers: <String, String>{
        'Authorization': 'Bearer ${widget.userToken}',
      },
    );

    print('Load User Data Response Status: ${response.statusCode}');
    print('Load User Data Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final user = data['data']['user'];

      setState(() {
        _nameController.text = user['name'];
        _emailController.text = user['email'];
        _phoneNumberController.text = user['phoneNumber'];
        _addressController.text = user['address'] ?? '';
        _selectedRole = user['applications'].isNotEmpty ? user['applications'][0]['role'] : _roles.isNotEmpty ? _roles[0] : null;
      });
    } else {
      print('Failed to load user data');
    }
  } catch (e) {
    print('Error loading user data: $e');
  }
}


  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
  if (_image == null) return;

  try {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('https://sso.pptik.id/api/v1/images/profile'),
    );

    request.files.add(
      await http.MultipartFile.fromPath('image', _image!.path),
    );

    final response = await request.send();

    final responseBody = await response.stream.bytesToString();

    print('Upload Image Response Status: ${response.statusCode}');
    print('Upload Image Response Body: $responseBody');

    if (response.statusCode == 200) {
      print('Image uploaded successfully');
    } else {
      print('Failed to upload image');
    }
  } catch (e) {
    print('Error uploading image: $e');
  }
}

Future<void> _updateProfile() async {
  if (_formKey.currentState?.validate() ?? false) {
    try {
      final response = await http.post(
        Uri.parse('https://sso.pptik.id/api/v1/users/edit-profile'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${widget.userToken}',
        },
        body: jsonEncode(<String, dynamic>{
          'newName': _nameController.text,
          //'email': _emailController.text,
          'newPhoneNumber': _phoneNumberController.text,
          'newAddress': _addressController.text,
          //'role': _selectedRole,
        }),
      );

      print('Update Profile Response Status: ${response.statusCode}');
      print('Update Profile Response Body: ${response.body}');

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully')),
        );

        // Optionally upload image if provided
        await _uploadImage();

        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile')),
        );
      }
    } catch (e) {
      print('Error updating profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred')),
      );
    }
  }
}




  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        'Update Profile',
        style: TextStyle(
          color: Colors.yellow,
          fontWeight: FontWeight.bold,
          fontSize: 25,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 30),
              Text(
                'Edit Profile',
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Ubah Detail Pengguna',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _nameController,
                label: 'Nama Pengguna',
                hint: 'Masukkan Nama Pengguna',
                validator: (value) => value == null || value.isEmpty ? 'Please enter your name' : null,
              ),
              const SizedBox(height: 25),
              _buildTextField(
                controller: _emailController,
                label: 'E-Mail',
                hint: 'Masukkan Email',
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter your email';
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return 'Please enter a valid email';
                  return null;
                },
              ),
              const SizedBox(height: 25),
              _buildTextField(
                controller: _phoneNumberController,
                label: 'No Handphone',
                hint: 'Masukkan Nomor Telepon',
                keyboardType: TextInputType.phone,
                validator: (value) => value == null || value.isEmpty ? 'Please enter your phone number' : null,
              ),
              const SizedBox(height: 25),
              _buildTextField(
                controller: _addressController,
                label: 'Alamat Lengkap',
                hint: 'Masukkan Alamat Lengkap',
                maxLines: 3,
                validator: (value) => value == null || value.isEmpty ? 'Please enter your address' : null,
              ),
              const SizedBox(height: 25),
              Text(
                'Role',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 5),
              DropdownButtonFormField<String>(
                value: _roles.contains(_selectedRole) ? _selectedRole : _roles.isNotEmpty ? _roles[0] : null,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedRole = newValue;
                  });
                },
                items: _roles.map((String role) {
                  return DropdownMenuItem<String>(
                    value: role,
                    child: Text(role),
                  );
                }).toList(),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.yellow,
                      width: 2.0,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              const SizedBox(height: 25),
              _image != null
                  ? Image.file(_image!)
                  : IconButton(
                      icon: Icon(Icons.add_a_photo),
                      onPressed: _pickImage,
                    ),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: _updateProfile, // Call the update profile method
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow, // Set the background color to yellow
                  //onPrimary: Colors.black, // Set the text color to black
                ),
                child: Text(
                  'Update Profile',
                  style: TextStyle(
                    color: Colors.black, // Set the text color to black
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

Widget _buildTextField({
  required TextEditingController controller,
  required String label,
  required String hint,
  TextInputType keyboardType = TextInputType.text,
  int maxLines = 1,
  String? Function(String?)? validator,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(fontSize: 16),
      ),
      SizedBox(height: 5),
      TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.yellow,
              width: 2.0,
            ),
          ),
        ),
        validator: validator,
      ),
    ],
  );
}
}