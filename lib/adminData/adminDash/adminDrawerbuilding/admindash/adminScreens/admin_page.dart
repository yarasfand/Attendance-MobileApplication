import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:project/bloc_internet/internet_bloc.dart';
import 'package:project/bloc_internet/internet_state.dart';
import '../adminConstants/adminconstants.dart';
import '../adminResponsive.dart';
import '../admincomponents/adminOptions_detail.dart';
import 'admin_data.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InternetBloc, InternetStates>(
      builder: (context, state) {
        if(state is InternetGainedState)
          {
        return Scaffold(
          key: _scaffoldKey,
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
                          if (AdminResponsive.isMobile(
                              context)) const AdminStorageDetails(),
                          const SizedBox(height: defaultPadding),
                          if (AdminResponsive.isMobile(context))
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      "Contact Details",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 10),
                                    ),
                                    Text(
                                      "FOR SUPPORT: 123456789",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 10),
                                    ),
                                    Text(
                                      "POWERED BY: PIONEER 2023",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 10),
                                    ),
                                  ],
                                ),
                                FloatingActionButton.extended(
                                  onPressed: () {
                                    // Save data
                                  },
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
        else if(state is InternetLostState)
          {
            return Expanded(
              child: Scaffold(
                body: Container(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "No Internet Connection!",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Lottie.asset('assets/no_wifi.json'),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        else{
          return Expanded(
            child: Scaffold(
              body: Container(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "No Internet Connection!",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Lottie.asset('assets/no_wifi.json'),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      }
    );
  }
}
