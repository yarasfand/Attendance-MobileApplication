
import 'package:flutter/Material.dart';

class GlobalObjects{
   static Object? obj;
   static String? empCode;
   static int? empId;
   static String? empMail;
   static  DateTime? empJoinDate;
   static String? empProfilePic;
   static String? empName;
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
               title: Text('Alert'),
               content: Text('Please Select The Employee..'),
               actions: <Widget>[
                  TextButton(
                     onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                     },
                     child: Text('Ok'),
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
               title: Text('Alert'),
               content: Text('Please Fill The Form..'),
               actions: <Widget>[
                  TextButton(
                     onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                     },
                     child: Text('Ok'),
                  ),
               ],
            );
         },
      );
   }
}