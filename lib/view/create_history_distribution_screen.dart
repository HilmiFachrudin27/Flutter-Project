import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../view/additional_info_screen.dart'; // Import AdditionalInfoScreen

class CreateHistoryDistribution extends StatefulWidget {
  final VoidCallback onDistributionCreated;

  CreateHistoryDistribution({required this.onDistributionCreated});

  @override
  _CreateHistoryDistributionState createState() => _CreateHistoryDistributionState();
}

class _CreateHistoryDistributionState extends State<CreateHistoryDistribution> {
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });

      // Navigate to AdditionalInfoScreen with the selected image
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AdditionalInfoScreen(imageFile1: _imageFile!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create History Distribution'),
        backgroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: Colors.black,
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
