import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:salemina_data/widgets/custom_snack_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String?> loginService(
  BuildContext context,
  TextEditingController nameController,
  TextEditingController passwordController,
) async {
  final username = nameController.text.trim();
  final password = passwordController.text.trim();

  final url = Uri.parse('http://194.147.222.179:3005/api/auth/login');

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body) as Map<String, dynamic>;
      final storage = await SharedPreferences.getInstance();

      final username = responseData['username'] as String;
      await storage.setString('username', username);

      if (context.mounted) {
        showSnackBarMessagesuccess(context, username);
      }

      return 'success';
    } else {
      if (context.mounted) {
        showSnackBarMessagefailure(context);
        return 'error';
      }
    }
  } catch (e) {
    if (context.mounted) {
      showSnackBarMessagefailure(context);
      return 'error';
    }
  }
  return 'error';
}
