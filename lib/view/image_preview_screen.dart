import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ImagePreviewScreen extends StatefulWidget {
  final XFile imageFile;

  const ImagePreviewScreen({Key? key, required this.imageFile}) : super(key: key);

  @override
  _ImagePreviewScreenState createState() => _ImagePreviewScreenState();
}

class _ImagePreviewScreenState extends State<ImagePreviewScreen> {
  Position? _currentPosition;
  String? _currentDate;
  String? _address;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _getCurrentDate();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = position;
      });
      await _getAddressFromCoordinates(position.latitude, position.longitude);
    } catch (e) {
      print('Failed to get location: $e');
      setState(() {
        _isLoading = false;
        _address = 'Failed to retrieve address';
      });
    }
  }

  Future<void> _getAddressFromCoordinates(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        setState(() {
          _address = '${placemark.street ?? ''}, ${placemark.subLocality ?? ''}, ${placemark.locality ?? ''}, ${placemark.postalCode ?? ''}, ${placemark.country ?? ''}';
        });
      } else {
        setState(() {
          _address = 'Address not found';
        });
      }
    } catch (e, stackTrace) {
      print('Failed to get address: $e');
      print('StackTrace: $stackTrace');
      setState(() {
        _address = 'Failed to retrieve address';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _getCurrentDate() {
    setState(() {
      _currentDate = DateTime.now().toLocal().toString().split(' ')[0];
    });
  }

  Future<void> _submit() async {
    if (_currentPosition == null || _address == null || _currentDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all the required fields.')),
      );
      return;
    }

    try {
      final imageFile = File(widget.imageFile.path);
      final uploadResponse = await uploadImage(imageFile);

      final url = 'https://yourapiendpoint.com/submit'; // Replace with your API endpoint
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        'date': _currentDate,
        'address': _address,
        'latitude': _currentPosition!.latitude,
        'longitude': _currentPosition!.longitude,
        'image_url': uploadResponse['imageUrl'], // Replace with the key returned by your server
      });

      final response = await http.post(Uri.parse(url), headers: headers, body: body);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data submitted successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit data.')),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred.')),
      );
    }
  }

  Future<Map<String, dynamic>> uploadImage(File imageFile) async {
    final url = 'https://youruploadendpoint.com/upload'; // Replace with your upload URL
    final request = http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    final response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      return jsonDecode(responseData);
    } else {
      throw Exception('Failed to upload image');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Preview'),
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
            // Center the image at the top
            if (widget.imageFile != null)
              Center(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      File(widget.imageFile.path),
                      fit: BoxFit.cover,
                      height: 300,
                      width: 300,
                    ),
                  ),
                ),
              ),
            SizedBox(height: 20),
            // Description header
            Text(
              'Description',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Container(
              height: 1,
              color: Colors.grey,
            ),
            SizedBox(height: 20),
            // Display current date and address in columns
            Expanded(
              child: Row(
                children: [
                  // Left side column
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_currentDate != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Text.rich(
                              TextSpan(
                                text: 'Date: ',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: '$_currentDate',
                                    style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if (_address != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Text.rich(
                              TextSpan(
                                text: 'Address: ',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: '$_address',
                                    style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  // Right side column
                  if (_currentPosition != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Text.rich(
                            TextSpan(
                              text: 'Latitude: ',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              children: <TextSpan>[
                                TextSpan(
                                  text: '${_currentPosition!.latitude}',
                                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            text: 'Longitude: ',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            children: <TextSpan>[
                              TextSpan(
                                text: '${_currentPosition!.longitude}',
                                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Submit button
            Center(
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow, // Background color
                  //onPrimary: Colors.white, // Text color
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                child: 
                Text(
                  'Submit',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
