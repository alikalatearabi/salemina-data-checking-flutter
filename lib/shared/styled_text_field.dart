import 'package:flutter/material.dart';

class StyledTextField extends StatelessWidget {
  const StyledTextField({
    super.key,
    this.controller,
    required this.labelText,
    this.readOnly,
  });

  final TextEditingController? controller;
  final String labelText;
  final bool? readOnly;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      width: MediaQuery.of(context).size.width * 0.43,
      height: 40,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: TextField(
          readOnly: readOnly ?? false,
          controller: controller,
          style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              fontFamily: 'Yekan',
          ),
          textDirection: TextDirection.rtl,
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: const TextStyle(
              color: Color.fromARGB(255, 40, 40, 40),
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide:  (readOnly ?? false) ? const BorderSide(color: Color.fromARGB(255, 128, 125, 125), width: 0.0) : const BorderSide(color: Color.fromARGB(255, 240, 189, 189), width: 0.0) 
            ),
            focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.grey, width: 0.0)),
          ),
        ),
      ),
    );
  }
}