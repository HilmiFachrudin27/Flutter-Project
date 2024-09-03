import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../server/constants.dart';  // Pastikan path ini sesuai dengan struktur proyek Anda
import '../model/user_model.dart';  // Import model yang sudah Anda buat

class UserService {
  Future<UserModel> fetchUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String ? userToken = prefs.getString('userToken');
    final response = await http.get(Uri.parse('$apiUrlUser/users/profile'),
    headers: {
        'Authorization': 'Bearer $userToken',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      print(jsonResponse);
      return UserModel.fromJson(jsonResponse['data']['user']);
    } else {
      throw Exception('Failed to load user profile');
    }
  }
}