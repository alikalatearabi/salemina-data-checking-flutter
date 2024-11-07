import 'package:flutter/material.dart';

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

void showSnackBarMessagefailure(
  BuildContext context,
) {
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
