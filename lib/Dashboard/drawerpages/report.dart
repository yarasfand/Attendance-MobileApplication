import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class reports extends StatelessWidget {
  const reports({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.bars),
          color: Colors.white,
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        backgroundColor: const Color(0xFFE26142),
        elevation: 0,
        title: const Center(
          child: Padding(
            padding: EdgeInsets.only(right: 55.0), // Add right padding
            child: Text(
              "REPORTS",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
