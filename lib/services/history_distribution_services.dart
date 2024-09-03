import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/histori_distribution_model.dart'; // Adjust the import according to your file structure
import '../server/constants.dart'; // Ensure this contains the correct API URL

class HistoriDistributionService {
  // Save token to SharedPreferences
  Future<void> _saveTokenHistoriDistribution(String appToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('appToken', appToken);
    print('Token Saved: $appToken'); // Debugging
  }

  // Retrieve token from SharedPreferences
  Future<String> _getTokenHistoriDistribution() async {
    final prefs = await SharedPreferences.getInstance();
    final appToken = prefs.getString('appToken');
    print('Retrieved Token: $appToken'); // Debugging
    return appToken ?? '';
  }

  // Validate token usage (this function can be customized based on how you want to validate tokens)
  Future<bool> _validateToken() async {
    final appToken = await _getTokenHistoriDistribution();
    return appToken.isNotEmpty;
  }

  // Fetch histori distribusi
  Future<List<HistoriDistribusi>> getHistoriDistribusi() async {
    try {
      final appToken = await _getTokenHistoriDistribution();
      final response = await http.get(
        Uri.parse('$apiUrlHistoriDistribusi/histories'),
        headers: {
          'Authorization': 'Bearer $appToken',
        },
      );

      print('Request URL: ${Uri.parse('$apiUrlHistoriDistribusi/histories')}');
      print('Authorization Header: Bearer $appToken');
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseJson = json.decode(response.body);
        final List<dynamic> historiDistribusiJson = responseJson['data'];
        return historiDistribusiJson
            .map((json) => HistoriDistribusi.fromJson(json))
            .toList();
      } else {
        print('Failed to load histori distribusi. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load histori distribusi');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  // Fetch histori distribusi by ID
  Future<HistoriDistribusi> getHistoriDistribusiById(String id) async {
  final appToken = await _getTokenHistoriDistribution();
  final response = await http.get(
    Uri.parse('$apiUrlHistoriDistribusi/histories/HISTORY-75974175-6031-4fdb-bf77-d62a4dad93f1-2024'), // Use the dynamic ID
    headers: {
      'Authorization': 'Bearer $appToken',
    },
  );

  print('Request URL: ${Uri.parse('$apiUrlHistoriDistribusi/histories/HISTORY-75974175-6031-4fdb-bf77-d62a4dad93f1-2024')}');
  print('Authorization Header: Bearer $appToken');
  print('Response Status Code: ${response.statusCode}');
  print('Response Body: ${response.body}');

  if (response.statusCode == 200) {
    final Map<String, dynamic> responseJson = json.decode(response.body);
    if (responseJson['status'] == true) {
      return HistoriDistribusi.fromJson(responseJson['data']);
    } else {
      throw Exception('API returned an error: ${responseJson['message']}');
    }
  } else {
    throw Exception('Failed to load histori distribusi. Status code: ${response.statusCode}');
  }
}

Future<HistoriDistribusi> getHistoriByID(String distributionId) async {
  final appToken = await _getTokenHistoriDistribution();
  final response = await http.get(
    Uri.parse('$apiUrlHistoriDistribusi/histories/distribution/DISTRIBUTION-91371b58-41c1-4f1b-9f78-0cfb7232d1b0-2024'),
    headers: {
      'Authorization': 'Bearer $appToken',
    },
  );

  print('Request URL: ${Uri.parse('$apiUrlHistoriDistribusi/histories/distribution/DISTRIBUTION-91371b58-41c1-4f1b-9f78-0cfb7232d1b0-2024')}');
  print('Authorization Header: Bearer $appToken');
  print('Response Status Code: ${response.statusCode}');
  print('Response Body: ${response.body}');

  if (response.statusCode == 200) {
    final Map<String, dynamic> responseJson = json.decode(response.body);

    // Check for the status field in the response
    if (responseJson['status'] == true) {
      // Handle the case where 'data' is an array
      final List<dynamic> dataList = responseJson['data'];
      if (dataList.isNotEmpty) {
        return HistoriDistribusi.fromJson(dataList[0]);
      } else {
        throw Exception('No data found for the given distribution ID.');
      }
    } else {
      throw Exception('API returned an error: ${responseJson['message']}');
    }
  } else {
    throw Exception('Failed to load histori distribusi. Status code: ${response.statusCode}');
  }
}

Future<void> createHistoriDistribusi(HistoriDistribusi historiDistribusi) async {
  final appToken = await _getTokenHistoriDistribution();
  final url = Uri.parse('$apiUrlHistoriDistribusi/histories');
  
  print('Request URL: $url');
  print('Request Body: ${json.encode(historiDistribusi.toJson())}');
  
  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $appToken',
      },
      body: json.encode(historiDistribusi.toJson()),
    );

    // Print response details
    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');
   /* print('Request URL: $url');
    print('Request Body: ${json.encode(historiDistribusi.toJson())}');*/
    
    if (response.statusCode == 201) {
      // Handle success
      print('Histori Distribusi created successfully');
    } else {
      // Handle failure
      print('Error details: ${response.body}');
      throw Exception('Failed to create histori distribusi. Status code: ${response.statusCode}');
    }
  } catch (e) {
    // Handle any other errors
    print('Error: $e');
  }
}

  /*Future<void> createHistoriDistribusi(HistoriDistribusi historiDistribusi) async {
  final appToken = await _getTokenHistoriDistribution();
  final url = Uri.parse('$apiUrlHistoriDistribusi/histories');
  print('Request URL: $apiUrlHistoriDistribusi/histories');
  print('Request Body: ${json.encode(historiDistribusi.toJson())}');
  
  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $appToken',
    },
    body: json.encode(historiDistribusi.toJson()),
  );

  print('Response Status Code: ${response.statusCode}');
  print('Response Body: ${response.body}');
  
  if (response.statusCode != 201) {
    print('Error details: ${response.body}');
    throw Exception('Failed to create histori distribusi. Status code: ${response.statusCode}');
  }
}*/


  // Update an existing histori distribusi
  Future<void> updateHistoriDistribusi(String id, HistoriDistribusi historiDistribusi) async {
    final appToken = await _getTokenHistoriDistribution();
    final response = await http.put(
      Uri.parse('$apiUrlHistoriDistribusi/histories/$id'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $appToken',
      },
      body: json.encode(historiDistribusi.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update histori distribusi. Status code: ${response.statusCode}');
    }
  }

  // Delete a histori distribusi
  Future<void> deleteHistoriDistribusi(String id) async {
    final appToken = await _getTokenHistoriDistribution();
    final response = await http.delete(
      Uri.parse('$apiUrlHistoriDistribusi/histories/$id'),
      headers: {
        'Authorization': 'Bearer $appToken',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete histori distribusi. Status code: ${response.statusCode}');
    }
  }
}
