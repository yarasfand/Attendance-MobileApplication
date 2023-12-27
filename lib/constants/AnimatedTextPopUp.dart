import 'dart:ui';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../admin/adminDashboard/screen/adminMain.dart';
import '../employee/empDashboard/screens/employeeMain.dart';


class CustomDialog extends StatelessWidget {
  final String message;
  final AnimationController animationController;

  CustomDialog({required this.message, required this.animationController});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Wrap(
        children: [
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 12,
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15),
                  InkWell(
                    onTap: () {
                      animationController.reverse();
                    },
                    child: const Icon(Icons.cancel,color: Colors.red,),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

addToCartPopUpSuccess(AnimationController animationController, String message) {
  return SlideTransition(
    position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(animationController),
    child: Align(
      alignment: Alignment.bottomCenter,
      child: Wrap(
        children: [
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 12,
            margin: const EdgeInsets.all(15),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10), // Set the border radius here
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              padding: EdgeInsets.all(15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message,
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 4),

                      ],
                    ),
                  ),
                  const SizedBox(width: 15),
                  const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Icon(FontAwesomeIcons.check, color: Colors.green),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

addToCartPopUpFailed(AnimationController animationController, String message) {
  return SlideTransition(
    position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(animationController),
    child: Align(
      alignment: Alignment.bottomCenter,
      child: Wrap(
        children: [
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 12,
            margin: const EdgeInsets.all(15),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10), // Set the border radius here
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              padding: EdgeInsets.all(15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message,
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 4),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15),
                  InkWell(
                    onTap: () {
                      animationController.reverse();
                    },
                    child: const Icon(Icons.cancel,color: Colors.red,),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

addToCartPopUpNoCrossMessage(AnimationController animationController, String message) {
  return AnimatedBuilder(
    animation: animationController,
    builder: (context, child) {
      return Stack(
        children: [
          // Blurred Background (conditionally rendered)
          if (animationController.status == AnimationStatus.forward)
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(color: Colors.transparent),
              ),
            ),
          // Pop-up Content
          SlideTransition(
            position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
                .animate(animationController),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Wrap(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 12,
                    margin: const EdgeInsets.all(15),
                    child:Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10), // Set the border radius here
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  message,
                                  style: const TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 4),
                              ],
                            ),
                          ),
                          const SizedBox(width: 15),
                          InkWell(
                            onTap: () {
                              animationController.reverse();
                            },
                            child: const Icon(FontAwesomeIcons.warning,color: Colors.yellow,),
                          ),
                        ],
                      ),
                    ),

                  ),
                ],
              ),
            ),
          ),
        ],
      );
    },
  );
}

addToCartPopUpMessage(AnimationController animationController,String message,VoidCallback onPressed) {
  return SlideTransition(
    position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(animationController),
    child: Align(
      alignment: Alignment.bottomCenter,
      child: Wrap(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 12,
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15),

                  InkWell(
                    onTap: onPressed,
                    child: const Icon(Icons.cancel,color: Colors.red,), // Use any icon you want
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

void showCustomSuccessAlertEmployee(BuildContext context, String successMessage) {
  CoolAlert.show(
    context: context,
    type: CoolAlertType.success,
    title: 'Success',
    text: successMessage,
    confirmBtnText: '', // Set confirm button text to an empty string
    confirmBtnColor: Colors.transparent,
    borderRadius: 10.0,
  );

  // Delay the navigation until after the animation completes
  Future.delayed(Duration(seconds: 3), () {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => EmpMainPage()));
  });
}
void showCustomSuccessAlertEditEmployee(BuildContext context, String successMessage) {
  CoolAlert.show(
    context: context,
    type: CoolAlertType.success,
    title: 'Success',
    text: successMessage,
    autoCloseDuration: Duration(seconds: 3), // Auto-close after 2 seconds
    confirmBtnText: 'Ok', // Set confirm button text to an empty string
    confirmBtnColor: Colors.blue,
    borderRadius: 10.0,
  );
}
void showCustomSuccessAlertAdmin(BuildContext context, String successMessage) {
  CoolAlert.show(
    context: context,
    type: CoolAlertType.success,
    title: 'Success',
    text: successMessage,
    confirmBtnText: '', // Set confirm button text to an empty string
    confirmBtnColor: Colors.transparent,
    borderRadius: 10.0,
  );

  // Delay the navigation until after the animation completes
  Future.delayed(Duration(seconds: 3), () {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminMainPage()));
  });
}




void showCustomFailureAlert(BuildContext context, String errorMessage) {
  CoolAlert.show(
    context: context,
    type: CoolAlertType.error,
    title: 'Oops...',
    text: errorMessage,
    backgroundColor: Colors.red,
    autoCloseDuration: Duration(seconds: 2), // Auto-close after 2 seconds
    borderRadius: 10.0,
    confirmBtnColor: Colors.transparent, // Set button color to transparent
    confirmBtnText: '', // Set confirm button text to an empty string
  );
}


void showCustomWarningAlert(BuildContext context, String warningMessage) {
  CoolAlert.show(
    context: context,
    type: CoolAlertType.warning,
    title: 'Warning',
    text: warningMessage,
    autoCloseDuration: Duration(seconds: 2), // Auto-close after 2 seconds
    confirmBtnText: '', // Set confirm button text to an empty string
    borderRadius: 10.0,
    confirmBtnColor: Colors.transparent, // Set button color to transparent

  );
}










