import 'package:flutter/material.dart';

class myProfile extends StatelessWidget {
  const myProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE26142),
        title: const Text("MY PROFILE"),
      ),
    );
  }
}
