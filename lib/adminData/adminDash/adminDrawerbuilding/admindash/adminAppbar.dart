import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AdminAppBar extends StatefulWidget {
  final VoidCallback openDrawer;

  const AdminAppBar({
    Key? key,
    required this.openDrawer,
  }) : super(key: key);

  @override
  State<AdminAppBar> createState() => _AdminAppBarState();
}

class _AdminAppBarState extends State<AdminAppBar> {

  // Maps working
  late bool locationError = true;
  double? lat;
  double? long;
  String? corporateID;
  String? username;
  String? password;

  @override
  void initState() {
    super.initState();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text(message),
        duration: Duration(seconds: 2), // Adjust the duration as needed
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const FaIcon(FontAwesomeIcons.bars),
        color: Colors.white,
        onPressed: widget.openDrawer,
      ),
      backgroundColor: const Color(0xFFE26142),
      elevation: 0,
      title: const Center(
        child: Padding(
          padding: EdgeInsets.only(right: 55.0), // Add right padding
          child: Text(
            "       ADMIN",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
