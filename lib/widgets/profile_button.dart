import 'package:flutter/material.dart';
import 'package:salemina_data/screens/profile/ProfilePage.dart';

class ProfileButton extends StatelessWidget {
  final String username;

  const ProfileButton({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 100),
      width: MediaQuery.of(context).size.width * 0.4,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfilePage(username: username),
            ),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Baseline(
              baseline: 20.0,
              baselineType: TextBaseline.alphabetic,
              child: Text(
                username,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const Icon(
              Icons.person,
              color: Colors.white,
              size: 26,
            ),
          ],
        ),
      ),
    );
  }
}