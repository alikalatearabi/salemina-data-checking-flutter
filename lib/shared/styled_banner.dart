import 'package:flutter/material.dart';

void styledBanner(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showMaterialBanner(
    MaterialBanner(
      backgroundColor: Colors.red,
      content: Text(
        content,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
          },
          child: const Text(
            'باشه',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
        ),
      ],
    ),
  );

  Future.delayed(const Duration(seconds: 2), () {
    ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
  });
}