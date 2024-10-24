import 'package:flutter/material.dart';
import 'package:salemina_data/services/api_service.dart';

class ProfilePage extends StatefulWidget {
  final String username;

  const ProfilePage({super.key, required this.username});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<Map<String, dynamic>?> userProfileData;

  @override
  void initState() {
    super.initState();
    userProfileData = fetchProfileData(widget.username);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Align(
          alignment: Alignment.centerRight,
          child: Text('پروفایل کاربر'),
        ),
      ),
      body: Center(
        child: FutureBuilder<Map<String, dynamic>?>(
          future: userProfileData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text('No data available');
            } else {
              if ((snapshot.data!['Main_data_status'] == null ||
                      snapshot.data!['Main_data_status'].isEmpty) &&
                  (snapshot.data!['Extra_data_status'] == null ||
                      snapshot.data!['Extra_data_status'].isEmpty)) {
                return const Card(
                  margin: EdgeInsets.all(16),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'هیچ داده‌ای وجود ندارد',
                      style: TextStyle(fontSize: 18, color: Colors.black87),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              } else {
                return _buildCardView(snapshot.data!);
              }
            }
          },
        ),
      ),
    );
  }

  Widget _buildCardView(Map<String, dynamic> data) {
    final statusMap = {
      '11': 'داده اصلی تایید شده توسط کاربر',
      '3': 'داده اصلی اصلاح شده توسط کاربر',
      '7': 'داده جدید وارد شده توسط کاربر',
      'extra11': 'داده تکمیلی تایید شده توسط کاربر',
      'extra3': 'داده تکمیلی اصلاح شده توسط کاربر',
      'extra7': 'داده تکمیلی وارد شده توسط کاربر',
    };

    List<Widget> cards = [];

    // Create Main Data Status Cards
    data['Main_data_status'].forEach((key, value) {
      cards.add(_buildCard(statusMap[key]!, value.toString()));
    });

    // Create Extra Data Status Cards
    data['Extra_data_status'].forEach((key, value) {
      cards.add(_buildCard(statusMap['extra$key']!, value.toString()));
    });

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: cards,
      ),
    );
  }

  Widget _buildCard(String title, String value) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Card(
        margin: const EdgeInsets.all(15),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              const Icon(
                Icons.info,
                size: 42,
                color: Color.fromARGB(255, 7, 73, 128),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
