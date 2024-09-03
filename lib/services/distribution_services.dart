import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/distribution_model.dart';
import '../server/constants.dart'; // Ensure this contains the correct API URL
import 'package:shared_preferences/shared_preferences.dart';

class DistributionService {
  // Save token to SharedPreferences
  Future<void> _saveToken(String appToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('appToken', appToken);
    print('Token Saved : $appToken');//debugging
  }
  //RETRIEVE TOKEN
  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final appToken = prefs.getString('appToken');
    print('Retrieved Token: $appToken');
    return appToken ?? '';
  }
  //VALIDATE TOKEN USAGE
  Future<List<Distribution>> getDistributions() async {
  try {
    final appToken = await _getToken();
    final response = await http.get(
      Uri.parse('$apiUrlDistributionUser/distribution'),
      headers: {
        'Authorization': 'Bearer $appToken',
      },
    );

    print('Request URL: ${Uri.parse('$apiUrlDistributionUser/distribution')}');
    print('Authorization Header: Bearer $appToken');
    print('Response Status Code:  ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseJson = json.decode(response.body);
      final List<dynamic> distributionsJson = responseJson['data'];
      return distributionsJson
          .map((json) => Distribution.fromJson(json))
          .toList();
    } else {
      print('Failed to load distributions. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load distributions');
    }
  } catch (e) {
    print('Error: $e');
    rethrow;
  }
}


  Future<Distribution> getDistributionById(String id) async {
    final appToken = await _getToken();
    final response = await http.get(
      Uri.parse('$apiUrlDistributionUser/distribution/$id'),
      headers: {
        'Authorization': 'Bearer $appToken',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseJson = json.decode(response.body);
      if (responseJson['status'] == true) {
        return Distribution.fromJson(responseJson['data']);
      } else {
        throw Exception('API returned an error: ${responseJson['message']}');
      }
    } else {
      throw Exception('Failed to load distribution. Status code: ${response.statusCode}');
    }
  }

  Future<void> createDistribution(Distribution distribution) async {
    final appToken = await _getToken();
    final response = await http.post(
      Uri.parse('$apiUrlDistributionUser/distribution'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      
        'Authorization': 'Bearer $appToken',
      },
      body: json.encode(distribution.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create distribution. Status code: ${response.statusCode}');
    }
  }

  Future<void> updateDistribution(String id, Distribution distribution) async {
    final appToken = await _getToken();
    final response = await http.put(
      Uri.parse('$apiUrlDistributionUser/distribution/$id'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $appToken',
      },
      body: json.encode(distribution.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update distribution. Status code: ${response.statusCode}');
    }
  }

  Future<void> deleteDistribution(String id) async {
    final appToken = await _getToken();
    final response = await http.delete(
      Uri.parse('$apiUrlDistributionUser/distribution/$id'),
      headers: {
        'Authorization': 'Bearer $appToken',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete distribution. Status code: ${response.statusCode}');
    }
  }
}
