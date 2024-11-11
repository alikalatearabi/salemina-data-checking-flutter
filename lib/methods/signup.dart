import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void showSignUpPopup(BuildContext context, TextEditingController nameController, TextEditingController passwordController) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        contentPadding: const EdgeInsets.all(16.0),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 25),
              const Text(
                'ثبت‌نام کنید',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField(context, 'نام کاربری', nameController),
              const SizedBox(height: 10),
              _buildTextField(context, 'رمزعبور', passwordController, obscureText: true),
              const SizedBox(height: 20),
              InkWell(
                child: _buildButton(context, 'ثبت'),
                onTap: () async {
                  final result = await register(nameController.text, passwordController.text);
                  if (result == 'Registration successful!') {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setString('username', nameController.text);
                    Navigator.of(context).pop();
                    _showSuccessDialog(context, result);
                  } else {
                    _showErrorDialog(context, result);
                  }
                },
              ),
              const SizedBox(height: 25),
            ],
          ),
        ),
      );
    },
  );
}

Future<String> register(String username, String password) async {
  final url = Uri.parse('http://194.147.222.179:3005/api/auth/register');
  final headers = {'Content-Type': 'application/json'};
  final body = jsonEncode({
    'username': username,
    'password': password,
  });

  try {
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 201) {
      return 'Registration successful!';
    } else if (response.statusCode == 400) {
      final responseBody = jsonDecode(response.body);
      return 'Registration failed: ${responseBody['error'] ?? 'Unknown error'}';
    } else {
      return 'Unexpected error: ${response.statusCode}, ${response.body}';
    }
  } catch (e) {
    return 'An error occurred: $e';
  }
}

Widget _buildTextField(BuildContext context, String labelText, TextEditingController controller, {bool obscureText = false}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 6),
    width: MediaQuery.of(context).size.width * 0.40,
    child: Directionality(
      textDirection: TextDirection.rtl,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        textDirection: TextDirection.rtl,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(
            color: Color.fromARGB(255, 40, 40, 40),
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 0.0),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 1.0),
          ),
        ),
      ),
    ),
  );
}

Widget _buildButton(BuildContext context, String text) {
  return Container(
    alignment: Alignment.center,
    width: MediaQuery.of(context).size.width * 0.34,
    height: 45,
    margin: const EdgeInsets.only(bottom: 6),
    decoration: BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}

void _showErrorDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Error'),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

void _showSuccessDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Success'),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}