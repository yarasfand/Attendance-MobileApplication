
import 'package:flutter/Material.dart';

class GlobalObjects{
   static Object? obj;
   static String? empCode;
   static int? empId;
   static String? empMail;
   static  DateTime? empJoinDate;
   static String? empProfilePic;
   static String? empName;

   static String? adminCorpId;
   int? adminId;
   static String? adminName;
   static String? adminMail;



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
}