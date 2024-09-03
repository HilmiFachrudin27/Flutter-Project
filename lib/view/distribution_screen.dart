/*import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/distribution_model.dart'; // Adjust the import based on your project structure

class DistributionService {
  final String _baseUrl = 'https://example.com/api/distributions'; // Replace with your API URL

  // Fetch distributions from the API
  Future<List<Distribution>> fetchDistributions() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == true) {
          List<dynamic> distributionsJson = data['data'];
          return distributionsJson.map((json) => Distribution.fromJson(json)).toList();
        } else {
          throw Exception('API returned an error: ${data['message']}');
        }
      } else {
        throw Exception('Failed to load distributions');
      }
    } catch (e) {
      print('Error fetching distributions: $e');
      throw Exception('Failed to load distributions');
    }
  }
}*/
