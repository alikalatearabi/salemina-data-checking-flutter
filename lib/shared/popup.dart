import 'package:flutter/material.dart';
import 'package:salemina_data/shared/styled_button.dart';

void popUp(BuildContext context, String text) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          backgroundColor: Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 33, 95, 35),
                  ),
                  textAlign: TextAlign.right,
                  
                ),
              ),
              TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Container(
                margin: const EdgeInsets.only(top: 20),
                child: const StyledButton("تایید")
              ),
            ),
            ],
          ),
        );
      },
    );
  }