import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:salemina_data/methods/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

void showLoginPopup(BuildContext context, ValueNotifier<String> nameNotifier,
    TextEditingController passwordController) {
  showDialog(
    context: context,
    barrierDismissible: false,
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
              const Text(
                'برای استفاده از امکانات سامانه وارد شوید',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField(context, 'نام کاربری', nameNotifier),
              const SizedBox(height: 10),
              _buildTextField(context, 'رمزعبور', passwordController),
              const SizedBox(height: 20),
              InkWell(
                child: _buildButton(context, 'ورود'),
                onTap: () {
                  loginAndHandleResponse(
                      context, nameNotifier, passwordController);
                },
              ),
              const SizedBox(height: 5),
              TextButton(
                onPressed: () {
                  showSignUpPopup(context, nameNotifier, passwordController);
                },
                child: const Text(
                  '.حساب کاربری ندارید؟ ثبت‌نام کنید',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<void> loginAndHandleResponse(
    BuildContext context,
    ValueNotifier<String> nameNotifier,
    TextEditingController passwordController) async {
  final username = nameNotifier.value;
  final password = passwordController.text;

  final url = Uri.parse('http://194.147.222.179:3005/api/auth/login');

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      SharedPreferences.setMockInitialValues({});
      final storage = await SharedPreferences.getInstance();

      String username = json.decode(response.body)['username'];
      await storage.setString('username', username);

      Navigator.of(context).pop();
      showSnackBarMessagesuccess(context, username);
    } else {
      showSnackBarMessagefailure(context);
    }
  } catch (e) {
    showSnackBarMessagefailure(context);
  }
}

void showSnackBarMessagesuccess(BuildContext context, String username) {
  final snackBar = SnackBar(
    content: const Text(
      "با موفقیت وارد شدید",
      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
      textAlign: TextAlign.right,
    ),
    backgroundColor: Colors.green,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    duration: const Duration(seconds: 3),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void showSnackBarMessagefailure(BuildContext context) {
  final snackBar = SnackBar(
    content: const Text(
      "مجددا تلاش کنید",
      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
      textAlign: TextAlign.right,
    ),
    backgroundColor: Colors.red,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    duration: const Duration(seconds: 3),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

Widget _buildTextField(
    BuildContext context, String labelText, dynamic controller) {
  return Container(
    margin: const EdgeInsets.only(bottom: 6),
    width: MediaQuery.of(context).size.width * 0.40,
    child: Directionality(
      textDirection: TextDirection.rtl,
      child: controller is ValueNotifier<String>
          ? ValueListenableBuilder<String>(
              valueListenable: controller,
              builder: (context, value, child) {
                return TextField(
                  onChanged: (newValue) => controller.value = newValue,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w600),
                  textDirection: TextDirection.rtl,
                  decoration: InputDecoration(
                    labelText: labelText,
                    labelStyle: const TextStyle(
                      color: Color.fromARGB(255, 40, 40, 40),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 0.0),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 0.0),
                    ),
                  ),
                );
              },
            )
          : TextField(
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
