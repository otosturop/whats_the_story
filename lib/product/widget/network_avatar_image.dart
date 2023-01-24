import 'package:flutter/material.dart';

class NetworkAvatarImage extends StatelessWidget {
  final String isGoogle;
  final String avatarUrl;
  final String baseUrl;

  const NetworkAvatarImage({super.key, required this.isGoogle, required this.avatarUrl, required this.baseUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
      ),
      child: CircleAvatar(
        radius: 40,
        child: ClipOval(
            child: Image.network(
          isGoogle == "1" ? avatarUrl : "$baseUrl$avatarUrl",
          fit: BoxFit.cover,
        )),
      ),
    );
  }
}
