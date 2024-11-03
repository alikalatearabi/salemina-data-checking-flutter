import 'package:flutter/material.dart';

class SampleImage extends StatelessWidget {
  const SampleImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    child: Image.asset(
                      'assets/maininfopicture.jpg',
                      width: 300,
                      height: 300,
                    ),
                  );
                },
              );
            },
            child: Image.asset(
              'assets/maininfopicture.jpg',
              width: 150,
              height: 100,
              color: const Color.fromARGB(250, 250, 238, 147),
              colorBlendMode: BlendMode.multiply,
            ),
          ),
          const SizedBox(width: 15),
          InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    child: Image.asset(
                      'assets/mainpicture.jpg',
                      width: 200,
                      height: 300,
                    ),
                  );
                },
              );
            },
            child: Image.asset(
              'assets/mainpicture.jpg',
              width: 100,
              height: 100,
              color: const Color.fromARGB(250, 250, 238, 147),
              colorBlendMode: BlendMode.multiply,
            ),
          ),
        ],
      ),
    );
  }
}
