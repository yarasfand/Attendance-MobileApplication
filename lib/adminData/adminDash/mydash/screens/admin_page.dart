import 'package:flutter/material.dart';
import '../components/options_detail.dart';
import '../constants/constants.dart';
import '../responsive.dart';
import 'admin_data.dart';
import 'header.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  // Change this to the actual notification count

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        primary: false,
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            const SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.calendar_month,
                            color: Colors.green,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "05 Sep",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Tuesday",
                                style: TextStyle(
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                          Icon(Icons.settings, color: Colors.grey),
                        ],
                      ),
                      const AdminData(),
                      const SizedBox(height: defaultPadding),
                      if (Responsive.isMobile(context)) const StorageDetails(),
                      const SizedBox(height: defaultPadding),
                      if (Responsive.isMobile(context))
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text(
                                  "Contact Details",
                                  style: TextStyle(color: Colors.black,fontSize: 10),
                                ),
                                Text(
                                  "FOR SUPPORT: 123456789",
                                  style: TextStyle(color: Colors.black,fontSize: 10),
                                ),
                                Text(
                                  "POWERED BY: PIONEER 2023",
                                  style: TextStyle(color: Colors.black,fontSize: 10),
                                ),
                              ],
                            ),
                            FloatingActionButton.extended(
                              onPressed: () {},
                              label: Icon(Icons.message_outlined),
                            ),

                          ],
                        ),
                      SizedBox(height: 20,),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
