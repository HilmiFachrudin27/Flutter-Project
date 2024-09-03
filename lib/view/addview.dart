import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart'; // Add geolocator package for location services

class AddView extends StatefulWidget {
  const AddView({super.key});

  @override
  State<AddView> createState() => _AddViewState();
}

class _AddViewState extends State<AddView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  File? _imageFile;

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _latitudeController.text = position.latitude.toString();
        _longitudeController.text = position.longitude.toString();
      });
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });

      // Get current location after picking the image
      await _getCurrentLocation();
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('https://survey-pisang.pptik.id/api/v1/histories'), // Replace with your API endpoint
      );

      request.fields['guidDistribution'] = 'DISTRIBUTION-91371b58-41c1-4f1b-9f78-0cfb7232d1b0-2024';
      request.fields['date'] = _dateController.text;
      request.fields['description'] = _descriptionController.text;
      request.fields['latitude'] = _latitudeController.text;
      request.fields['longitude'] = _longitudeController.text;

      if (_imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath('file', _imageFile!.path),
        );
      }

      final response = await request.send();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data submitted successfully')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit data')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tambahkan Data Sesuatu',
          style: TextStyle(
            color: Color(0xFFFFD245),
            fontSize: 20,
            fontWeight: FontWeight.bold,
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
              mainAxisSize: MainAxisSize.min, // Prevent column from expanding to the maximum height
              children: <Widget>[
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Tanggal',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(height: 5),
                TextFormField(
                  controller: _dateController,
                  decoration: InputDecoration(
                    labelText: 'Masukkan Tanggal',
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a date';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Latitude',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(height: 5),
                TextFormField(
                  controller: _latitudeController,
                  decoration: InputDecoration(
                    labelText: 'Masukkan Latitude',
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a Latitude';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Longitude',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(height: 5),
                TextFormField(
                  controller: _longitudeController,
                  decoration: InputDecoration(
                    labelText: 'Masukkan Longitude',
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a Longitude';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Deskripsi',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Masukkan Deskripsi',
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
                  maxLines: 5,
                  minLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                _imageFile == null
                    ? Text('No image selected.')
                    : Image.file(_imageFile!, height: 150),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _pickImage,
                      child: Text('Upload Image',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFFD245),
                        minimumSize: Size(150, 50), // Ensure minimum size for button
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 25),
                Center(
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    child: Text('Submit',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFFD245),
                      minimumSize: Size(200, 50), // Ensure minimum size for button
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
