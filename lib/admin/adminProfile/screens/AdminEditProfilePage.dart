import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:project/constants/AppBar_constant.dart';
import 'package:project/constants/AppColor_constants.dart';
import 'package:project/constants/globalObjects.dart';
import 'package:project/introduction/bloc/bloc_internet/internet_bloc.dart';
import 'package:project/introduction/bloc/bloc_internet/internet_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Sqlite/admin_sqliteHelper.dart';
import '../../../constants/AnimatedTextPopUp.dart';
import '../../../No_internet/no_internet.dart';
import '../../../responsive/responsive_layout.dart';
import '../models/AdminEditProfileModel.dart';
import '../models/AdminEditProfileRepository.dart';

class AdminEditProfilePage extends StatefulWidget {
  final VoidCallback onSave;
  final VoidCallback? onSaveSuccess; // Define the onSaveSuccess callback

  AdminEditProfilePage({Key? key, required this.onSave, this.onSaveSuccess})
      : super(key: key);

  @override
  State<AdminEditProfilePage> createState() =>
      _AdminEditProfilePageState(onSave);
}

class _AdminEditProfilePageState extends State<AdminEditProfilePage>
    with TickerProviderStateMixin {
  final VoidCallback onSave;

  _AdminEditProfilePageState(this.onSave);
  late AnimationController addToCartPopUpAnimationController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController =
      TextEditingController(text: GlobalObjects.adminusername);
  final TextEditingController _passwordController =
      TextEditingController(text: GlobalObjects.adminpassword);
  final TextEditingController _emailController =
      TextEditingController(text: GlobalObjects.adminMail);
  final TextEditingController _phoneNumberController =
      TextEditingController(text: GlobalObjects.adminphonenumber);
  final AdminEditProfileRepository _editProfileRepository =
      AdminEditProfileRepository('http://62.171.184.216:9595');
  @override
  void initState() {
    addToCartPopUpAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    super.initState();
  }

  @override
  void dispose() {
    addToCartPopUpAnimationController.dispose();
    super.dispose();
  }

  Future<bool> _submitForm() async {
    final dbHelper = AdminDatabaseHelper();
    final adminList = await dbHelper.getAdmins();

    if (adminList.isNotEmpty) {
      final adminData = adminList.first;
      final adminEditProfile = AdminEditProfile(
        userLoginId: adminData['username'].toString(),
        userName: _usernameController.text,
        userPassword: _passwordController.text,
        email: _emailController.text,
        mobile: _phoneNumberController.text,
      );

      final success =
          await _editProfileRepository.updateAdminProfile(adminEditProfile);

      if (success) {
        GlobalObjects.adminphonenumber = adminEditProfile.mobile;
        GlobalObjects.adminMail = adminEditProfile.email;
        GlobalObjects.adminusername = adminEditProfile.userName;
        GlobalObjects.adminpassword = adminEditProfile.userPassword;

        addToCartPopUpAnimationController.forward();

        Timer(const Duration(seconds: 3), () {
          addToCartPopUpAnimationController.reverse();
          Navigator.pop(context);
          Navigator.pop(context, true);
        });
        showPopupWithSuccessMessage("Profile updated successfully!");
        onSave();

        // Set the boolean value to true
        widget.onSaveSuccess?.call();
      } else {
        addToCartPopUpAnimationController.forward();
        Timer(const Duration(seconds: 3), () {
          addToCartPopUpAnimationController.reverse();
          Navigator.pop(context, false);
        });
        showPopupWithFailedMessage("Failed to update profile!");
      }
    }

    return false; // Return false if form validation fails
  }

  bool isInternetLost = false;

  void showPopupWithSuccessMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return addToCartPopUpSuccess(
            addToCartPopUpAnimationController, message);
      },
    );
  }

  void showPopupWithFailedMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return addToCartPopUpFailed(addToCartPopUpAnimationController, message);
      },
    );
  }

  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InternetBloc, InternetStates>(
      listener: (context, state) {
        // TODO: implement listener
        if (state is InternetLostState) {
          // Set the flag to true when internet is lost
          isInternetLost = true;
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.push(
              context,
              PageTransition(
                child: const NoInternet(),
                type: PageTransitionType.rightToLeft,
              ),
            );
          });
        } else if (state is InternetGainedState && isInternetLost) {
          // Navigate back to the original page when internet is regained
          Navigator.pop(context);
          isInternetLost = false; // Reset the flag
        }
      },
      builder: (context, state) {
        if (state is InternetGainedState) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Edit Profile',
                style: AppBarStyles.appBarTextStyle,
              ),
              backgroundColor: AppBarStyles.appBarBackgroundColor,
              iconTheme:
                  const IconThemeData(color: AppBarStyles.appBarIconColor),
              centerTitle: true,
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    margin: ResponsiveLayout.contentPadding(context),
                    child: Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              alignment: Alignment.topCenter,
                              child: Image.asset(
                                'assets/icons/userrr.png',
                                height: ResponsiveLayout.isSmallScreen(context)
                                    ? 100
                                    : 200,
                                width: ResponsiveLayout.isSmallScreen(context)
                                    ? 100
                                    : 200,
                              ),
                            ),
                            SizedBox(
                                height: ResponsiveLayout.isSmallScreen(context)
                                    ? 20
                                    : 30),
                            TextFormField(
                              controller: _usernameController,
                              decoration:
                                  const InputDecoration(labelText: 'Username'),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Username is required';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: !_isPasswordVisible,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                  },
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Password is required';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: _emailController,
                              decoration:
                                  const InputDecoration(labelText: 'Email'),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Email is required';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: _phoneNumberController,
                              decoration: const InputDecoration(
                                  labelText: 'Phone Number'),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Phone Number is required';
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                                height: ResponsiveLayout.isSmallScreen(context)
                                    ? 10
                                    : 20),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 50),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: AppColors.primaryColor,

                              ),
                              child: SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _submitForm,
                                  style: ElevatedButton.styleFrom(
                                    primary: AppColors.primaryColor, // Set the button background color
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50), // Set the border radius
                                    ),
                                  ),
                                  child: Text('Submit',style: TextStyle(color: Colors.white,fontSize: 18),),
                                ),
                              ),
                            )


                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
