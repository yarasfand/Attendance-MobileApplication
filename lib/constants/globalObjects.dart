import 'package:flutter/Material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GlobalObjects {
  static Object? obj;
  static String? empCode;
  static int? empId;
  static String? empMail;
  static DateTime? empJoinDate;
  static String? empProfilePic;
  static String? empName;
  static String? empFatherName;
  static String? empPassword;
  static String? empPhone;
  // admin objects
  static String? adminCorpId;
  int? adminId;
  static String? adminMail;
  static String? adminusername;
  static String? adminpassword;
  static String? adminemail;
  static String? adminphonenumber;

  static void checkForSelection(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
           elevation: 8,
          contentPadding: EdgeInsets.only(top:20),
          content: const Text('Please Select The Employee',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                 fontSize: 15
              )),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  static void checkForLeaveForm(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: const Text('Please Fill The Form..'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }
}
