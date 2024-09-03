import 'dart:io'; // Import for File class
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart'; // Import image picker
import 'dart:convert';

class AddDistributionView extends StatefulWidget {
  const AddDistributionView({Key? key}) : super(key: key);

  @override
  _AddDistributionViewState createState() => _AddDistributionViewState();
}

class _AddDistributionViewState extends State<AddDistributionView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  File? _image; // To store the selected image

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('https://survey-pisang.pptik.id/api/v1/survey'),
      );

      request.headers['Content-Type'] = 'application/json; charset=UTF-8';
      request.fields['guidDistribution'] = 'DISTRIBUTION-91371b58-41c1-4f1b-9f78-0cfb7232d1b0-2024';
      request.fields['date'] = _dateController.text;
      request.fields['description'] = _descriptionController.text;
      request.fields['latitude'] = _latitudeController.text;
      request.fields['longitude'] = _longitudeController.text;

      if (_image != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'image',
            await _image!.readAsBytes(),
            filename: _image!.path.split('/').last,
          ),
        );
      }

      final response = await request.send();

      if (response.statusCode == 201) {
        final responseBody = await response.stream.bytesToString();
        Map<String, dynamic> decodedResponse = json.decode(responseBody);
        bool success = decodedResponse['success'];
        String message = decodedResponse['message'];

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Distribution added successfully')),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add distribution: $message')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Request failed with status: ${response.statusCode}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Update Distribusi',
          style: TextStyle(
            color: Color(0xFFFFD245),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _dateController,
                  decoration: InputDecoration(
                    labelText: 'Date',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter date';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _latitudeController,
                  decoration: InputDecoration(
                    labelText: 'Latitude',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please input latitude';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _longitudeController,
                  decoration: InputDecoration(
                    labelText: 'Longitude',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please input longitude';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 5, // Makes the text field taller
                  minLines: 3, // Minimum height of the text field
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _pickImage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFFD245),
                        minimumSize: Size(120, 50), 
                      ),
                      child: Text(
                        'Pick Image',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    if (_image != null)
                      Text('Image selected: ${_image!.path.split('/').last}')
                  ],
                ),
                SizedBox(height: 40),
                Center(
                  child: ElevatedButton(
                    onPressed: _submit, 
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFFD245),
                      minimumSize: Size(300, 50)
                    ),
                  child: Text(
                    'Submit',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),  
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
