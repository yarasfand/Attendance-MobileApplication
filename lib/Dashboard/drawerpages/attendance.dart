import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class attendance extends StatelessWidget {
  final VoidCallback openDrawer;

  const attendance({super.key, required this.openDrawer,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.bars),
          color: Colors.white,
          onPressed: openDrawer,
        ),
        backgroundColor: const Color(0xFFE26142),
        elevation: 0,
        title: const Center(
          child: Padding(
            padding:  EdgeInsets.only(right: 55.0), // Add right padding
            child: Text(
              "ATTENDANCE",
              style: TextStyle(
                  color: Colors.white
              ),
            ),
          ),
        ),
      ),
    );
  }
}
