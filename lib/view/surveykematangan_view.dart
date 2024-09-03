import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:revisisurveypisangver2/view/survey_create_screen.dart';
import '../model/survey_model.dart';
import '../services/survey_services.dart';
import '../view/surveykematangan_view.dart'; // Import your SurveyDetailScreen here
import 'package:http/http.dart' as http;

class SurveyListScreen extends StatefulWidget {
  @override
  _SurveyListScreenState createState() => _SurveyListScreenState();
}

class _SurveyListScreenState extends State<SurveyListScreen> {
  final SurveyService _surveyService = SurveyService();
  late Future<List<Survey>> _surveys;

  @override
  void initState() {
    super.initState();
    _loadSurveys();
  }

  void _loadSurveys() {
    setState(() {
      _surveys = _surveyService.getSurveys();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        title: Text(
          'Riwayat Survey Kematangan',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),  
        ),
      ),*/
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SurveyCreateScreen(onSurveyCreated: _loadSurveys),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFFD245), // Background color
                padding: EdgeInsets.symmetric(horizontal: 500, vertical: 28),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(80),
                ),
              ),
              child:Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, color: Colors.black), // Add icon
                  SizedBox(width: 8),
                  Text(
                  'Tambah Riwayat Survey',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                ),
              ),
                ],
              ) 
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Riwayat Survey Kematangan',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Survey>>(
              future: _surveys,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No surveys found.'));
                } else {
                  final surveys = snapshot.data!;
                  return ListView.builder(
                    itemCount: surveys.length,
                    itemBuilder: (context, index) {
                      final survey = surveys[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SurveyDetailScreen(survey: survey),
                            ),
                          );
                        },
                        child: Card(
                          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 4),
                                          Text(
                                            'ID : ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            '${survey.id}',
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            'Tanggal : ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            '${survey.date}',
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            'Created At : ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            '${survey.createdAt}',
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 4),
                                          Text(
                                            'GUID: ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            '${survey.guid}',
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            'Description: ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            '${survey.description}',
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SurveyCreateScreen(onSurveyCreated: _loadSurveys),
          ),
        ),
        child: Icon(Icons.add),
      ),
    );
  }
}

// The remaining code for SurveyDetailScreen, SurveyCreateScreen, and SurveyUpdateScreen remains unchanged


class SurveyDetailScreen extends StatelessWidget {
  final Survey survey;

  SurveyDetailScreen({required this.survey});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Preview Survey Details',
          style: TextStyle(
            color: Colors.yellow,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (survey.image.isNotEmpty)
                Image.network(survey.image),
              SizedBox(height: 16),
              Text(
                'Deskripsi',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),

              SizedBox(height:15), // Add some space between the title and the line
              Container(
                height: 1, // Height of the horizontal line
                color: Colors.grey, // Color of the line
              ),


              SizedBox(height: 20),
              Text(
                'GUID : ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '${survey.guid}',
                  style: TextStyle(
                    fontSize: 16,
                  ),
              ),

              SizedBox(height: 16),
              Text(
                'Company GUID : ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '${survey.guidCompany}',
                  style: TextStyle(
                    fontSize: 16,
                  ),
              ),

              SizedBox(height: 16),
              Text(
                'Tanggal : ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '${survey.date}',
                  style: TextStyle(
                    fontSize: 16,
                  ),
              ),

              SizedBox(height: 16),
              Text(
                'Description : ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '${survey.description}',
                  style: TextStyle(
                    fontSize: 16,
                  ),
              ),

              

              /*Text(
                'ID: ${survey.id}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),*/
             /* SizedBox(height: 8),
              Text(
                'GUID: ${survey.guid}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),*/
              /*SizedBox(height: 8),
              Text(
                'Company GUID: ${survey.guidCompany}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                'Date: ${survey.date}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                'Description: ${survey.description}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),*/
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SurveyUpdateScreen(survey: survey),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow, // Mengatur warna latar belakang tombol menjadi kuning
                  //onPrimary: Colors.black, // Mengatur warna teks tombol
                  minimumSize: Size(double.infinity, 50), // Lebar memanjang dan tinggi tombol
                    shape: 
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80), // Membuat tombol bulat
                      ),
                ),
                child: Text(
                  'Update Survey',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15, // Mengatur warna teks tombol
                  ),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  final service = SurveyService();
                  try {
                    await service.deleteSurvey(survey.id);
                    Navigator.pop(context);
                  } catch (e) {
                    print('Failed to delete survey: $e');
                  }
                },
                child: Text(
                  'Delete Survey',
                  style: TextStyle(
                    color: Colors.black, // Warna teks tombol
                    fontSize: 15,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow, // Warna latar belakang tombol
                  //onPrimary: Colors.black, // Warna teks tombol
                  minimumSize: Size(double.infinity, 50), // Lebar memanjang dan tinggi tombol
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25), // Membuat tombol dengan sudut membulat
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16), // Padding horizontal untuk memperlebar tombol
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

/*class SurveyCreateScreen extends StatefulWidget {
  final VoidCallback onSurveyCreated;

  SurveyCreateScreen({required this.onSurveyCreated});

  @override
  _SurveyCreateScreenState createState() => _SurveyCreateScreenState();
}

class _SurveyCreateScreenState extends State<SurveyCreateScreen> {
  final _descriptionController = TextEditingController();
  final _dateController = TextEditingController();
  String _imagePath = '';
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery, // or ImageSource.camera
    );

    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  Future<String> _uploadImage() async {
    if (_imagePath.isEmpty) return '';

    final request = http.MultipartRequest(
      'POST', 
      Uri.parse('https://sso.pptik.id/api/v1/survey') // Replace with your image upload API endpoint
    );

    request.files.add(await http.MultipartFile.fromPath('file', _imagePath));
    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);
      final responseJson = json.decode(responseString);

      // Assuming the response contains the URL of the uploaded image
      return responseJson['imageUrl'];
    } else {
      throw Exception('Failed to upload image');
    }
  }

  void _createSurvey() async {
    String imageUrl = '';

    try {
      if (_imagePath.isNotEmpty) {
        imageUrl = await _uploadImage();
      }

      final survey = Survey(
        id: '', // ID will be generated by the server
        guid: '', // GUID can be generated if needed
        guidCompany: '', // GUID for the company
        date: _dateController.text,
        description: _descriptionController.text,
        image: imageUrl, // Use the uploaded image URL
        createdAt: DateTime.now().toIso8601String(),
        coordinates: Coordinates(latitude: 0.0, longitude: 0.0), // Placeholder values
      );

      final service = SurveyService();
      await service.createSurvey(survey);
      widget.onSurveyCreated();
      Navigator.pop(context);
    } catch (e) {
      print('Failed to create survey: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Survey'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: _dateController,
                decoration: InputDecoration(labelText: 'Date'),
              ),
              SizedBox(height: 16),
              _imagePath.isEmpty
                  ? Text('No image selected.')
                  : Image.file(File(_imagePath)),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Pick Image'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _createSurvey,
                child: Text('Create Survey'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}*/

class SurveyUpdateScreen extends StatefulWidget {
  final Survey survey;

  SurveyUpdateScreen({required this.survey});

  @override
  _SurveyUpdateScreenState createState() => _SurveyUpdateScreenState();
}

class _SurveyUpdateScreenState extends State<SurveyUpdateScreen> {
  late final TextEditingController _descriptionController;
  late final TextEditingController _dateController;
  late final TextEditingController _imageController;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(text: widget.survey.description);
    _dateController = TextEditingController(text: widget.survey.date);
    _imageController = TextEditingController(text: widget.survey.image);
  }

  void _updateSurvey() async {
    final updatedSurvey = widget.survey.copyWith(
      description: _descriptionController.text,
      date: _dateController.text,
      image: _imageController.text,
    );

    final service = SurveyService();
    try {
      await service.updateSurvey(updatedSurvey.id, updatedSurvey);
      Navigator.pop(context);
    } catch (e) {
      print('Failed to update survey: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Survey'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: _dateController,
              decoration: InputDecoration(labelText: 'Date'),
            ),
            TextField(
              controller: _imageController,
              decoration: InputDecoration(labelText: 'Image URL'),
            ),
            ElevatedButton(
              onPressed: _updateSurvey,
              child: Text('Update Survey'),
            ),
          ],
        ),
      ),
    );
  }
}


/*import 'package:flutter/material.dart';
import 'package:revisisurveypisangver2/view/addview.dart';
import 'package:revisisurveypisangver2/view/profile_view.dart';
import 'dart:math';

class SurveyKematanganView extends StatelessWidget {
  // Function to generate random dummy data
  List<Map<String, String>> generateDummySurveys(int count) {
    final random = Random();
    final List<String> sampleDescriptions = [
      'Survey description goes here.',
      'Detailed information about the survey.',
      'Another example description for the survey.',
      'This is a placeholder description for survey details.',
    ];

    return List.generate(count, (index) {
      return {
        'ID Distribusi': '${index + 1}',
        'Nama Petugas': 'Petugas ${index + 1}',
        'Tanggal Distribusi': '23 Agustus 2024',
        //'Tingkat Kematangan': random.choice(['Matang', 'Belum Matang']),
        'description': sampleDescriptions[random.nextInt(sampleDescriptions.length)],
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    // Generate 10 dummy surveys
    final List<Map<String, String>> surveys = generateDummySurveys(10);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Survey Pisang',
          style: TextStyle(
            color: Color(0xFFFFD245),
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        backgroundColor: Colors.white,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.person, color: Color(0xFFFFD245)),
            onPressed: () {
              var appToken = ''; // Replace with actual token if available
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileView(token: appToken),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddView()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFFD245),
                padding: EdgeInsets.symmetric(horizontal: 85.0, vertical: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(80.0),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, color: Colors.black),
                  SizedBox(width: 8),
                  Text(
                    'Tambah Riwayat Survey',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Riwayat Survey Kematangan',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: surveys.length,
              itemBuilder: (context, index) {
                final survey = surveys[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  elevation: 4.0,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16.0),
                    title: Text(
                      survey['ID Distribusi'] ?? 'Unknown ID',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text(
                      '${survey['Nama Petugas']}\n'
                      'Tanggal: ${survey['Tanggal Distribusi']}\n'
                      'Tingkat Kematangan: ${survey['Tingkat Kematangan']}\n'
                      '${survey['description']}',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}*/


