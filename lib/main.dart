// ignore_for_file: non_constant_identifier_names, prefer_const_constructors, deprecated_member_use, sized_box_for_whitespace
import 'dart:core';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:salemina_data/screens/home/home.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Yekan'),
      home: const MyHomePage(),
    );
  }
}