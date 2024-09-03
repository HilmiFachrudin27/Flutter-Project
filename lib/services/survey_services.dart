import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/survey_model.dart'; // Adjust the import according to your file structure
import '../server/constants.dart'; // Ensure this contains the correct API URL

class SurveyService {
  // Save token to SharedPreferences
  Future<void> _saveTokenSurveyService(String appToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('appToken', appToken);
    print('Token Saved: $appToken'); // Debugging
  }

  // Retrieve token from SharedPreferences
  Future<String> _retrieveTokenSurveyService() async {
    final prefs = await SharedPreferences.getInstance();
    final appToken = prefs.getString('appToken');
    print('Retrieved Token: $appToken'); // Debugging
    return appToken ?? '';
  }

  // Validate token
  Future<bool> _validateToken() async {
    final appToken = await _retrieveTokenSurveyService();
    return appToken.isNotEmpty;
  }

  // Fetch all surveys
  Future<List<Survey>> getSurveys() async {
    try {
      final tokenValid = await _validateToken();
      if (!tokenValid) {
        throw Exception('Invalid or missing token');
      }
      final appToken = await _retrieveTokenSurveyService();
      final url = Uri.parse('$apiUrlSurvey/survey');
      print('Request URL: $url');
      print('Authorization Header: Bearer $appToken');

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $appToken',
        },
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseJson = json.decode(response.body);
        final List<dynamic> surveysJson = responseJson['data'];
        return surveysJson.map((json) => Survey.fromJson(json)).toList();
      } else {
        print('Failed to load surveys. Status code: ${response.statusCode}');
        throw Exception('Failed to load surveys');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  // Fetch survey by ID
  Future<Survey> getSurveyById(String id) async {
    try {
      final tokenValid = await _validateToken();
      if (!tokenValid) {
        throw Exception('Invalid or missing token');
      }
      final appToken = await _retrieveTokenSurveyService();
      final url = Uri.parse('$apiUrlSurvey/survey/SURVEY-09560791-1b50-4065-84be-eece6662f566-2024');
      print('Request URL: $url');
      print('Authorization Header: Bearer $appToken');

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $appToken',
        },
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseJson = json.decode(response.body);
        if (responseJson['status'] == true) {
          return Survey.fromJson(responseJson['data']);
        } else {
          throw Exception('API returned an error: ${responseJson['message']}');
        }
      } else {
        throw Exception('Failed to load survey. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  // Create a new survey
  Future<void> createSurvey(Survey survey) async {
    try {
      final tokenValid = await _validateToken();
      if (!tokenValid) {
        throw Exception('Invalid or missing token');
      }
      final appToken = await _retrieveTokenSurveyService();
      final url = Uri.parse('$apiUrlSurvey/survey');
      print('Request URL: $url');
      print('Authorization Header: Bearer $appToken');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $appToken',
        },
        body: json.encode(survey.toJson()),
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode != 201) {
        throw Exception('Failed to create survey. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  // Update an existing survey
  Future<void> updateSurvey(String id, Survey survey) async {
    try {
      final tokenValid = await _validateToken();
      if (!tokenValid) {
        throw Exception('Invalid or missing token');
      }
      final appToken = await _retrieveTokenSurveyService();
      final url = Uri.parse('$apiUrlSurvey/survey/$id');
      print('Request URL: $url');
      print('Authorization Header: Bearer $appToken');

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $appToken',
        },
        body: json.encode(survey.toJson()),
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode != 200) {
        throw Exception('Failed to update survey. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  // Delete a survey
  Future<void> deleteSurvey(String id) async {
    try {
      final tokenValid = await _validateToken();
      if (!tokenValid) {
        throw Exception('Invalid or missing token');
      }
      final appToken = await _retrieveTokenSurveyService();
      final url = Uri.parse('$apiUrlSurvey/survey/$id');
      print('Request URL: $url');
      print('Authorization Header: Bearer $appToken');

      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $appToken',
        },
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode != 200) {
        throw Exception('Failed to delete survey. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }
}
