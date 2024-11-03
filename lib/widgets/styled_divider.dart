import 'package:flutter/material.dart';

class StyledDivider extends StatelessWidget {
  const StyledDivider({
    super.key,
    required this.text
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15, top: 15),
      width: MediaQuery.of(context).size.width * 0.9,
      alignment: Alignment.topRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              height: 2,
              color: Colors.black,
            ),
          ),
          Text(
            text,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
          )
        ],
      ),
    );
  }
}
