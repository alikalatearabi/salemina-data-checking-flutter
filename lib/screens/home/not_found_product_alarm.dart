import 'package:flutter/material.dart';

class NotFoundProductAlarm extends StatelessWidget {
  const NotFoundProductAlarm({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width * 1.0,
      height: 50,
      decoration: BoxDecoration(
          color: Colors.red, borderRadius: BorderRadius.circular(12)),
      child: const Text(
        'محصول در پایگاه داده موجود نیست',
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
