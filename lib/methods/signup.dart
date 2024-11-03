import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

void showSignUpPopup(BuildContext context, ValueNotifier<String> nameNotifier,
    TextEditingController passwordController) {
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
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              _buildTextFieldWithNotifier(context, 'نام کاربری', nameNotifier),
              const SizedBox(height: 10),
              _buildTextFieldWithController(
                  context, 'رمزعبور', passwordController),
              const SizedBox(height: 20),
              InkWell(
                child: _buildButton(context, 'ثبت'),
                onTap: () async {
                  String result = await register(
                      nameNotifier.value, passwordController.text);
                  Navigator.of(context).pop();
                  _showSnackBar(context, result);
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

void _showSnackBar(BuildContext context, String message) {
  final snackBar = SnackBar(
    content: Text(
      message,
      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
      textAlign: TextAlign.right,
    ),
    backgroundColor: message.contains('successful') ? Colors.green : Colors.red,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    duration: const Duration(seconds: 3),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

Widget _buildTextFieldWithNotifier(
    BuildContext context, String labelText, ValueNotifier<String> notifier) {
  return Container(
    margin: const EdgeInsets.only(bottom: 6),
    width: MediaQuery.of(context).size.width * 0.40,
    child: Directionality(
      textDirection: TextDirection.rtl,
      child: ValueListenableBuilder<String>(
        valueListenable: notifier,
        builder: (context, value, child) {
          return TextField(
            onChanged: (newValue) => notifier.value = newValue,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            textDirection: TextDirection.rtl,
            decoration: InputDecoration(
              labelText: labelText,
              labelStyle: const TextStyle(
                color: Color.fromARGB(255, 40, 40, 40),
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 0.0),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 0.0),
              ),
            ),
          );
        },
      ),
    ),
  );
}

Widget _buildTextFieldWithController(
    BuildContext context, String labelText, TextEditingController controller) {
  return Container(
    margin: const EdgeInsets.only(bottom: 6),
    width: MediaQuery.of(context).size.width * 0.40,
    child: Directionality(
      textDirection: TextDirection.rtl,
      child: TextField(
        controller: controller,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        textDirection: TextDirection.rtl,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(
            color: Color.fromARGB(255, 40, 40, 40),
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 0.0),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 0.0),
          ),
        ),
        obscureText: labelText == 'رمزعبور', // Hide password input
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
    ),
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 9,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}
