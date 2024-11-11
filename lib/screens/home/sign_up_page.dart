import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:salemina_data/screens/home/home.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FractionallySizedBox(
          widthFactor: 0.8,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Text(
                  'ثبت نام',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20.0),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'نام کاربری',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: const BorderSide(
                        color: Colors.black,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15.0),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'رمز عبور',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: const BorderSide(
                        color: Colors.black,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15.0),
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'تایید رمز عبور',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: const BorderSide(
                        color: Colors.black,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () async {
                    if (_passwordController.text != _confirmPasswordController.text) {
                      _showErrorDialog('رمز عبور و تایید رمز عبور مطابقت ندارند');
                      return;
                    }

                    final result = await register(
                      _nameController.text,
                      _passwordController.text,
                    );

                    if (result == 'Registration successful!') {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setString('username', _nameController.text);
                      _showSuccessDialog('ثبت نام با موفقیت انجام شد!');
                    } else {
                      _showErrorDialog(result);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: const Text(
                    'ثبت نام',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                Center(
                  child: GestureDetector(
                    onTap: () {},
                    child: const Text.rich(
                      TextSpan(
                        text: 'حساب کاربری ندارید؟ ',
                        children: <TextSpan>[
                          TextSpan(
                            text: 'ثبت نام کنید',
                            style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        title: const Text('خطا', style: TextStyle(color: Colors.red)),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('باشه'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        title: const Text('موفقیت', style: TextStyle(color: Colors.green)),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MyHomePage()),
              );
            },
            child: const Text('باشه'),
          ),
        ],
      ),
    );
  }
}