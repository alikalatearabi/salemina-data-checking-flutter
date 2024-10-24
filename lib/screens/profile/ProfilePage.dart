import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final String profileName;

  const ProfilePage({super.key, required this.profileName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile of $profileName'),
      ),
      body: Center(
        child: Text('Profile Page for $profileName'),
      ),
    );
  }
}