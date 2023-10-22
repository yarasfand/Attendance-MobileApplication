import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:project/constants/AppBar_constant.dart';
import 'package:project/introduction/bloc/bloc_internet/internet_bloc.dart';
import 'package:project/introduction/bloc/bloc_internet/internet_state.dart';

import '../../../No_internet/no_internet.dart';
import '../models/AdminEditProfileModel.dart';
import '../models/AdminEditProfileRepository.dart';

class AdminEditProfilePage extends StatefulWidget {
  const AdminEditProfilePage({Key? key}) : super(key: key);

  @override
  State<AdminEditProfilePage> createState() => _AdminEditProfilePageState();
}

class _AdminEditProfilePageState extends State<AdminEditProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final AdminEditProfileRepository _editProfileRepository =
  AdminEditProfileRepository('http://62.171.184.216:9595');

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final adminEditProfile = AdminEditProfile(
        userLoginId: 'ptsadmin',
        // You may use a user ID from your app
        userName: _usernameController.text,
        userPassword: _passwordController.text,
        email: _emailController.text,
        mobile: _phoneNumberController.text,
      );

      final success =
      await _editProfileRepository.updateAdminProfile(adminEditProfile);

      if (success) {
        // Handle success, e.g., show a success message
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text('Profile updated successfully'),
        //   ),
        // );
        Fluttertoast.showToast(msg: "Changes have been applied");
      } else {
        // Handle error, e.g., show an error message
        Fluttertoast.showToast(msg: "Failed to update profile!");
      }
    }
  }
  bool isInternetLost = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InternetBloc, InternetStates>(
      listener: (context, state) {
        // TODO: implement listener
        if (state is InternetLostState) {
          // Set the flag to true when internet is lost
          isInternetLost = true;
          Future.delayed(Duration(seconds: 2), () {
            Navigator.push(
              context,
              PageTransition(
                child: NoInternet(),
                type: PageTransitionType.rightToLeft,
              ),
            );
          });
        } else if (state is InternetGainedState) {
          // Check if internet was previously lost
          if (isInternetLost) {
            // Navigate back to the original page when internet is regained
            Navigator.pop(context);
          }
          isInternetLost = false; // Reset the flag
        }
      },
      builder: (context, state) {
        if(state is InternetGainedState)
          {
            return Scaffold(
              appBar: AppBar(
                title: Text('Edit Profile', style: AppBarStyles.appBarTextStyle,),
                backgroundColor: AppBarStyles.appBarBackgroundColor,
                iconTheme: IconThemeData(color: AppBarStyles.appBarIconColor),
                centerTitle: true,
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _usernameController,
                              decoration: InputDecoration(labelText: 'Username'),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Username is required';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: _passwordController,
                              decoration: InputDecoration(labelText: 'Password'),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Password is required';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(labelText: 'Email'),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Email is required';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: _phoneNumberController,
                              decoration: InputDecoration(
                                  labelText: 'Phone Number'),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Phone Number is required';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: _submitForm,
                              child: Text('Submit'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
        else {
          return Scaffold(
            body: Center(
                child: CircularProgressIndicator()),
          );
        }

      },
    );
  }
}
