// lib/screens/survey_create_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'image_preview_screen.dart'; // Import the ImagePreviewScreen

class SurveyCreateScreen extends StatefulWidget {
  final VoidCallback onSurveyCreated;

  SurveyCreateScreen({required this.onSurveyCreated});

  @override
  _SurveyCreateScreenState createState() => _SurveyCreateScreenState();
}

class _SurveyCreateScreenState extends State<SurveyCreateScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });

      // Automatically navigate to the preview screen with the selected image
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImagePreviewScreen(imageFile: _imageFile!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Survey'),
        backgroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: Colors.yellow,
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_imageFile != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Image.file(
                  File(_imageFile!.path),
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFFD245),
                  ),
                  child: const Text(
                    'Pick Image from Gallery',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => _pickImage(ImageSource.camera),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFFD245),
                  ),
                  child: const Text(
                    'Pick Image from Camera',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
