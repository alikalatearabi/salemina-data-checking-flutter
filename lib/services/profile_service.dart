import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> fetchProfileData(String username) async {
  final url =
      Uri.parse('http://194.147.222.179:3005/api/product/status/$username');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      print('Failed to load user profile data: ${response.statusCode}');
      return {};
    }
  } catch (e) {
    print('Error fetching user profile data: $e');
    return {};
  }
}
