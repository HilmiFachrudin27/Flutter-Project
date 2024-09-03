import 'dart:convert'; // For JSON encoding
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;

class AdditionalInfoScreen extends StatefulWidget {
  final XFile imageFile1;

  const AdditionalInfoScreen({Key? key, required this.imageFile1}) : super(key: key);

  @override
  _AdditionalInfoScreenState createState() => _AdditionalInfoScreenState();
}

class _AdditionalInfoScreenState extends State<AdditionalInfoScreen> {
  Position? _currentPosition;
  String? _currentDate;
  String? _address;
  bool _isLoading = true;
  String? _selectedMaturityLevel;

  final List<String> _maturityLevels = [
    'Mentah',
    'Matang',
    'Buruk',
  ];

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
    if (_currentPosition == null || _address == null || _selectedMaturityLevel == null) {
      // Handle the case where some data might be missing
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all the required fields.')),
      );
      return;
    }

    final url = 'https://sso.pptik.id/api/v1/survey';
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'date': _currentDate,
      'address': _address,
      'latitude': _currentPosition!.latitude,
      'longitude': _currentPosition!.longitude,
      //'maturity_level': _selectedMaturityLevel,
    });

    try {
      final response = await http.post(Uri.parse(url), headers: headers, body: body);
      if (response.statusCode == 200) {
        // Handle successful response
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data submitted successfully!')),
        );
      } else {
        // Handle error response
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit data.')),
        );
      }
    } catch (e) {
      // Handle network error
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Additional Info'),
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
            // Center the image at the top
            if (widget.imageFile1 != null)
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
                      File(widget.imageFile1.path),
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
                        // Dropdown for maturity level placed below the address
                        DropdownButton<String>(
                          value: _selectedMaturityLevel,
                          hint: Text('Tingkat Kematangan'),
                          items: _maturityLevels.map((String level) {
                            return DropdownMenuItem<String>(
                              value: level,
                              child: Text(level),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedMaturityLevel = newValue;
                            });
                          },
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
                child: Text(
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
